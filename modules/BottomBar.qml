import Quickshell
import Quickshell.Wayland
import QtQuick
import "../services"

PanelWindow {
    property var modelData

    id: root
    screen: modelData
    implicitHeight: 30
    color: "transparent"
    WlrLayershell.exclusiveZone: NiriWorkspaceService.inOverview ? -1 : 30

    anchors {
        left: true
        right: true
        bottom: true
    }

    margins {
        left: 40
        right: 40
    }

    StateGroup {
        id: states
        states: [
            State {
                name: "normal"
            },
            State {
                name: "overview"
            }
        ]

        transitions: [
            Transition {
                to: "overview"
                SequentialAnimation {
                    YAnimator {
                        target: bottomBar
                        from: 0
                        to: 100
                    }
                    PropertyAction {
                        target: bottomBar
                        property: "visible"
                        value: false
                    }
                }
            },
            Transition {
                to: "normal"
                SequentialAnimation {
                    PropertyAction {
                        target: bottomBar
                        property: "visible"
                        value: true
                    }
                    YAnimator {
                        target: bottomBar
                        from: 100
                        to: 0
                    }
                }
            }
        ]
    }

    Connections {
        target: NiriWorkspaceService
        function onInOverviewChanged() {
            if (NiriWorkspaceService.inOverview) {
                states.state = "overview"
            }
            else {
                states.state = "normal"
            }
        }
    }

    Rectangle {
        id: bottomBar
        anchors.fill: parent
        topLeftRadius: 10
        topRightRadius: 10
        color: "#121212"
        y: 0
    }
}
