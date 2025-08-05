import Quickshell
import QtQuick

PanelWindow {
    property var modelData
    screen: modelData

    anchors {
        left: true
        right: true
        bottom: true
    }

    margins {
        left: 40
        right: 40
    }

    implicitHeight: 30
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        topLeftRadius: 10
        topRightRadius: 10
        color: "#121212"
    }
}
