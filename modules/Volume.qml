import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

import "../services"

Scope {
    id: volumeRoot

    Connections {
        target: Audio.sink?.audio

        function onVolumeChanged() {
			      volumeStates.state = "showing";
			      hideTimer.restart();
		    }
    }

    // property bool shouldShowOsd: false

	  Timer {
		    id: hideTimer
		    interval: 1000
		    onTriggered: volumeStates.state = "hidden"//volumeRoot.shouldShowOsd = false
	  }

    PanelWindow {
        id: volumeWindow
        color: "transparent"
        // visible: volumeRoot.shouldShowOsd
        visible: false

        WlrLayershell.layer: WlrLayershell.Overlay
        WlrLayershell.exclusiveZone: -1

        anchors {
            right: true
            bottom: true
        }

        margins {
            right: 70
            bottom: 10
        }

        implicitWidth: 340
        implicitHeight: 60

        StateGroup {
            id: volumeStates

            state: "hidden"

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
                            target: volumeWindow
                            property: "visible"
                            value: true
                        }
                        NumberAnimation {
                            id: popUpAnimation
                            target: volumeWindow
                            properties: "implicitHeight"
                            from: 0
                            to: 60
                            duration: 150
                        }
                    }
                },
                Transition {
                    to: "hidden"
                    SequentialAnimation {
                        NumberAnimation {
                            id: popDownAnimation
                            target: volumeWindow
                            properties: "implicitHeight"
                            from: 60
                            to: 0
                            duration: 150
                        }
                        PropertyAction {
                            target: volumeWindow
                            property: "visible"
                            value: false
                        }
                    }
                }
            ]
        }


        Rectangle {
            anchors.fill: parent
            radius: 10
            color: "#121212"

            Rectangle {
                implicitHeight: 40
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                color: "#cccccc"
                width: Audio.volume * 320
                radius: 5

                Text {
                    text: Math.round(Audio.volume * 100)
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    font.family: "IBM Plex Sans"
                    font.bold: true
                    color: Audio.volume > 0.05 ? "#121212" : "white"
                }
            }
        }
    }
}
