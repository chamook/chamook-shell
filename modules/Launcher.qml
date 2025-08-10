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
        id: launcherContent
        anchors.fill: parent
        anchors.topMargin: 100
        topLeftRadius: 20
        topRightRadius: 20
        color: "#121212"

        StateGroup {
            id: launcherContentStates

            states: [
                State {
                    name: "apps"
                },
                State {
                    name: "zen"
                }
            ]

            transitions: [
                Transition {
                    to: "zen"
                    SequentialAnimation {
                        PropertyAction {
                            target: launcherApps
                            property: "visible"
                            value: false
                        }
                        PropertyAction {
                            target: launcherZen
                            property: "visible"
                            value: true
                        }
                    }
                },
                Transition {
                    to: "apps"
                    SequentialAnimation {
                        PropertyAction {
                            target: launcherApps
                            property: "visible"
                            value: true
                        }
                        PropertyAction {
                            target: launcherZen
                            property: "visible"
                            value: false
                        }
                    }
                }
            ]
        }

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
                            if (searchInput.displayText == "") {
                                launcherContentStates.state = "zen"
                            }
                            else {
                                launcherContentStates.state = "apps"
                            }
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

            Rectangle {
                id: launcherZen
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                Layout.topMargin: 50
                width: 1105
                height: 400
                color: "transparent"

                Text {
                    text: "Хотели как лучше, а получилось как всегда"
                    color: "#999999"
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 30
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            if (!launcher.visible) {
                launcherStates.state = "showing"
                launcherContentStates.state = "zen"
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

