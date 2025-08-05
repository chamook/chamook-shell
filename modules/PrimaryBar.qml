import Quickshell // for PanelWindow
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts

import "../components"
import "../services"
import "../utils"

PanelWindow {
    property var primaryScreenName: "DP-1"

    property var modelData
    screen: modelData

    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        left: 40
        right: 40
        top: 10
    }

    implicitHeight: 60

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: "#121212"

        // --- media player ---
        MediaPlayer {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            visible: modelData.name == primaryScreenName
        }
        // --- weather ---
        Text {
            id: wttr
            visible: modelData.name != primaryScreenName
            anchors.verticalCenter: parent.verticalCenter
            x: 20
            color: "white"
            text: ""
            font.family: "IBM Plex Sans"
            font.bold: true
            font.pixelSize: 16

            Process {
                id: wttrProc
                command: ["curl", "https://wttr.in/55.7475456,12.474267?format=1"]
                stdout: StdioCollector {
                  onStreamFinished: wttr.text = this.text
                }
                running: true
            }

            Timer {
                interval: 300000
                running: true
                repeat: true
                onTriggered: wttrProc.running = true
            }

        }

        // --- window title ---
        WindowTitle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.centerIn: parent
        }

        // --- system tray ---
        Tray {
            anchors.right: fuzzyClock.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 30
            Layout.alignment: Qt.AlignRight
        }

        // --- clock ---
        FuzzyClock {
            id: fuzzyClock
        }

        // --- power button ---
        Button {
            id: powerButton
            text: ""
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            font.family: "IBM Plex Sans"
            font.pixelSize: 16
            flat: true
            anchors.margins: modelData.name == primaryScreenName ? 20 : 0
            background: Rectangle {
                color: "transparent"
            }
            contentItem: Label {
                text: powerButton.text
                color: "white"
            }
            onClicked: powerButtonProc.startDetached()
            visible: modelData.name == primaryScreenName
            width: modelData.name == primaryScreenName ? 20 : 0

            Process {
                id: powerButtonProc
                command: ["wlogout", "-b 5"]
            }
        }
      }
}
