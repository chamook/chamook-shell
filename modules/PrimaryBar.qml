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
        ColumnLayout {
            id: windowTitleLayout
            Layout.alignment: Qt.AlignCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.centerIn: parent
            spacing: 0

            Text {
                text: FocusedWindowService.focusedWindowTitle || ""
                color: "white"
                Layout.alignment: Qt.AlignCenter
                font.family: "IBM Plex Sans"
                font.bold: true
                font.pixelSize: 16
            }
            Text {
                text: FocusedWindowService.focusedAppName || ""
                color: "#cccccc"
                Layout.alignment: Qt.AlignCenter
                font.family: "IBM Plex Sans"
                font.pixelSize: 16
            }
        }

        // --- system tray ---
        Tray {
            anchors.right: clockLayout.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 30
            Layout.alignment: Qt.AlignRight
        }

        // --- clock ---
        ColumnLayout {
            id: clockLayout
            Layout.alignment: Qt.AlignRight
            anchors.right: powerButton.left
            anchors.margins: 20
            spacing: 0

            Text {
                id: clock
                color: "white"
                maximumLineCount: 1
                font.family: "IBM Plex Sans"
                font.bold: true
          font.pixelSize: 16
          horizontalAlignment: Text.AlignRight
          Layout.alignment: Qt.AlignRight
          Layout.topMargin: 8
          Layout.rightMargin: 10

          Process {
            id: clockProc
            command: ["bash-fuzzy-clock"]
            running: true
            stdout: StdioCollector {
              onStreamFinished: clock.text = this.text
            }
          }

          Timer {
            interval: 10000
            running: true
            repeat: true
            onTriggered: clockProc.running = true
          }
        }
        Text {
            // center the bar in its parent component (the window)
            id: date
            color: "#cccccc"
            font.family: "IBM Plex Sans"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 10

            Process {
                id: dateProc
                command: ["date",  "+%A %d %B %Y"]
                running: true

                stdout: StdioCollector {
                    onStreamFinished: date.text = this.text
                }
            }

            Timer {
                interval: 60000
                running: true
                repeat: true
                onTriggered: dateProc.running = true
            }
        }
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
