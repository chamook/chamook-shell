import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "launcherItems"
import "../utils/fzf.js" as Fzf

PanelWindow {
    readonly property var fzf: new Fzf.Finder(DesktopEntries.applications.values, Object.assign({selector}, ({})))

    id: launcher
    color: "transparent"
    implicitHeight: 0
    implicitWidth: 1200
    visible: false
    focusable: true
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: this.visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    anchors {
        bottom: true
    }

    margins {
        bottom: 20
    }

    StateGroup {
        id: launcherStates

        states: [
            State {
                name: "showing"
            },
            State {
                name: "hidden"
            }
        ]

        transitions: [
            Transition {
                to: "showing"
                SequentialAnimation {
                    PropertyAction {
                        target: launcher
                        property: "visible"
                        value: true
                    }
                    NumberAnimation {
                        target: launcher
                        properties: "height"
                        from: 300
                        to: 1200
                        duration: 100
                    }
                }
            },
            Transition {
                to: "hidden"
                SequentialAnimation {
                    NumberAnimation {
                        target: launcher
                        properties: "height"
                        from: 1200
                        to: 300
                        duration: 100
                    }
                    PropertyAction {
                        target: launcher
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
    }

    function fzfSearch(search: string) : list<var> {
        const results =
            this.fzf
                .find(search)
                .sort((a, b) => {
                    if (a.score === b.score)
                        return selector(a.item).trim().length - selector(b.item).trim().length;
                    return b.score - a.score;
                })
                .map(r => r.item);

        return results
    }

    function selector(item: var): string {
        return item["name"];
    }


    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 100
        radius: 20
        color: "#121212"


        ColumnLayout {
            anchors.margins: 40

            Rectangle {
                color: "#232323"
                Layout.preferredHeight: 60
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                Layout.topMargin: 60
                height: 60
                width: 1110
                radius: 10
                border.width: 1
                border.color: "#454545"

                TextField {
                    id: searchInput
                    text: ""
                    placeholderText: "Найти что-то"
                    placeholderTextColor: "#555555"
                    color: "white"
                    background: null
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.fill: parent
                    anchors.leftMargin: 10


                    function quitLauncher() {
                        searchInput.clear()
                        launcherApps.model.values = fzfSearch("")
                        launcherStates.state = "hidden"
                    }

                    function searchApps() {
                        console.log(searchInput.displayText)
                        launcherApps.currentIndex = 0;
                        launcherApps.model.values = fzfSearch(searchInput.text)
                    }

                    Keys.onReleased: (event) => {
                        switch (event.key) {
                        case Qt.Key_Escape:
                            quitLauncher()
                            return
                        case Qt.Key_Down:
                            launcherApps.incrementCurrentIndex();
                            break;
                        case Qt.Key_Up:
                            launcherApps.decrementCurrentIndex();
                            break;
                        case Qt.Key_Return:
                            launcherApps.model.values[launcherApps.currentIndex].execute()
                            quitLauncher();
                            return;
                        default:
                            searchApps();
                            break;
                        }
                    }
                }
            }
            ListView {
                id: launcherApps
                implicitHeight: 1080
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                Layout.topMargin: 50
                spacing: 5
                model: ScriptModel {
                    values: fzfSearch(searchInput.text)
                    onValuesChanged: launcherApps.currentIndex = 0
                }
                orientation: Qt.Vertical

                delegate:
                    AppItem {
                        id: delegate
                        SequentialAnimation {
                            id: removeAnimation
                            PropertyAction { target: delegate; property: "ListView.delayRemove"; value: true }
                            ParallelAnimation {
                                NumberAnimation { target: delegate; property: "opacity"; to: 0; duration: 150 }
                                NumberAnimation { target: delegate; property: "y"; to: delegate.y + 50; duration: 150 }
                            }
                            PropertyAction { target: delegate; property: "ListView.delayRemove"; value: false }
                        }
                        ListView.onRemove: removeAnimation.start()
                    }

                highlightMoveDuration: 50
                highlightResizeDuration: 150
                highlight:
                    Rectangle {
                        color: "#cdcdcd"
                        opacity: 0.8
                        radius: 10
                        border.width: 1
                        border.color: "#ffffff"
                    }

            }
        }

    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            if (!launcher.visible) {
                launcherStates.state = "showing"
            }
            else {
                launcherStates.state = "hidden"
            }

            searchInput.forceActiveFocus()
        }
    }
    Image {
        source: "../assets/hand.png"
        width: 100
        height: 100
        x: 40
        y: 40
    }
}

