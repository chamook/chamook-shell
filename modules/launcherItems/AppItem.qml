import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    required property DesktopEntry modelData

    id: root
    spacing: 20
    height: 70

    IconImage {
        id: icon
        source: Quickshell.iconPath(root.modelData.icon, true)
        implicitHeight: 30
        implicitWidth: 30
        Layout.leftMargin: 10
    }
    ColumnLayout {
        spacing: 0
        Layout.preferredWidth: 1050
        Text {
            color: root.ListView.isCurrentItem ? "black" : "white"
            text: root.modelData.name
            font.family: "IBM Plex Sans"
            font.pixelSize: 28
            font.bold: false
        }
        Text {
            text: root.modelData.comment
            color: root.ListView.isCurrentItem ? "#555555" : "#cccccc"
            font.family: "IBM Plex Sans"
            font.pixelSize: 16
        }
    }
}
