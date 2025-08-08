import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "../components"
import "../data"

PanelWindow {

    property list<PowerOption> options: [
        PowerOption {
            name: "power"
            image: "../assets/play.svg"
            command: "systemctl poweroff"
        },
        PowerOption {
            name: "sleep"
            image: "../assets/pause.svg"
            command: "systemctl suspend"
        },
        PowerOption {
            name: "logout"
            image: "../assets/play.svg"
            command: "niri msg action quit"
        },
        PowerOption {
            name: "restart"
            image: "../assets/play.svg"
            command: "systemctl reboot"
        },
        PowerOption {
            name: "lock"
            image: "../assets/play.svg"
            command: "~/.config/swaylock/set-kb-and-lock.sh"
        }
    ]

    id: power
    color: "transparent"
    implicitHeight: 100
    implicitWidth: 600
    visible: false

    anchors {
        top: true
        right: true
    }

    margins {
        top: -10
        right: 40
    }

    StateGroup {
        id: powerStates

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
                        target: power
                        property: "visible"
                        value: true
                    }
                    YAnimator {
                        target: powerRectangle
                        from: -100
                        to: 0
                        duration: 100
                    }
                }
            },
            Transition {
                to: "hidden"
                SequentialAnimation {
                    YAnimator {
                        target: powerRectangle
                        from: 0
                        to: -100
                        duration: 100
                    }
                    PropertyAction {
                        target: power
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
    }

    Rectangle {
        id: powerRectangle
        color: "#121212"
        radius: 10
        anchors.fill: parent

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.leftMargin: 40

            Repeater {
                model: options
                delegate: PowerMenuButton {}
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    IpcHandler {
        target: "power"

        function menu(): void {
            if (powerStates.state != "showing") {
                powerStates.state = "showing"
            }
            else {
                powerStates.state = "hidden"
            }
        }
    }
}
