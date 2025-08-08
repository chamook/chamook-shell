import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

import "../data"

Rectangle {
    required property PowerOption modelData

    readonly property var process: Process {
		    command: ["sh", "-c", modelData.command]
	  }

    Button {
        width: 60
        height: 60
        icon.width: 60
        icon.height: 60
        icon.source: `../assets/${modelData.name}.svg`
        icon.cache: false
        flat: true
        onClicked: {
            process.startDetached()
            Quickshell.execDetached(["sh", "-c", "qs ipc call power menu"])
        }
    }
}
