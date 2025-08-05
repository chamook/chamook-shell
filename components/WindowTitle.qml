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
    id: windowTitleLayout
    Layout.alignment: Qt.AlignCenter
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
