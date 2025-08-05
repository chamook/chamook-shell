import Quickshell // for PanelWindow
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts

import "../components"
import "../services"
import "../utils"

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
