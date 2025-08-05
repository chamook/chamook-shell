pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

MouseArea {
    id: root

    required property SystemTrayItem modelData

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 10 * 2
    implicitHeight: 10 * 2

    onClicked: event => {
        if (event.button === Qt.LeftButton)
            modelData.activate();
        else if (event.button === Qt.RightButton && modelData.hasMenu)
            menu.open()
        else
            console.log("Not sure how to handle a tray item")
    }

    QsMenuAnchor {
      id: menu
      menu: root.modelData.menu
      anchor.window: root.QsWindow.window
      anchor.rect.x: root.x + root.QsWindow.contentItem?.width
      anchor.rect.y: root.y
      anchor.rect.height: root.height * 3
    }

    IconImage {
        id: icon

        source: {
            let icon = root.modelData.icon;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
        }
        asynchronous: true
        anchors.fill: parent
    }
}
