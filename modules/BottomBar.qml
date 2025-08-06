import Quickshell
import Quickshell.Wayland
import QtQuick
import "../services"

PanelWindow {
    property var modelData
    screen: modelData
    implicitHeight: NiriWorkspaceService.inOverview ? 0 : 30
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

    Rectangle {
        anchors.fill: parent
        topLeftRadius: 10
        topRightRadius: 10
        color: "#121212"
    }
}
