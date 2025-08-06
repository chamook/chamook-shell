import Quickshell // for PanelWindow
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts

import "../components"
import "../services"
import "../utils"

Rectangle {
    id: bigClock
    height: 200
    width: 1000
    color: "transparent"

    Text {
        id: clock
        color: "white"
        font.pixelSize: 50
        font.family: "IBM Plex Sans"
        font.bold: true
        horizontalAlignment: Text.AlignRight
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20

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
        font.pixelSize: 20
        horizontalAlignment: Text.AlignRight
        width: parent.width
        anchors.top: clock.bottom

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
