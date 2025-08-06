import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts

import "../components"
import "../services"
import "../utils"

Rectangle {
    id: mediaPlayer
    height: 290
    color: "transparent"

    RowLayout {
        anchors.top: parent.top
        anchors.topMargin: 20
        width: parent.width
        spacing: 20

        Image {
            id: albumArt
            source: MprisController.activePlayer?.trackArtUrl || ""
            sourceSize.width: 250
            sourceSize.height: 250
            fillMode: Image.PreserveAspectFit
            Layout.leftMargin: 20
            Layout.alignment: Qt.AlignLeft
        }
        ColumnLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.topMargin: 20

            Text {
                text: MprisController.activePlayer?.trackTitle || ""
                font.family: "IBM Plex Sans"
                color: "white"
                font.bold: true
                font.pixelSize: 24
                Layout.fillWidth: true
            }
            Text {
                text: MprisController.activePlayer?.trackArtist || ""
                font.family: "IBM Plex Sans"
                color: "#dddddd"
                font.pixelSize: 20
                Layout.fillWidth: true
            }
        }
    }
}
