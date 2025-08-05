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

    Rectangle {
        id: playerAnimation
        width: 50
        height: 60
        anchors.verticalCenter: parent.verticalCenter
        visible: MprisController.activePlayer?.isPlaying || false
        radius: 10
        opacity: 0.5
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "white" }
            GradientStop { position: 0.9; color: "#121212" }
        }

        SequentialAnimation {
            id: playerNumberAnimation
            loops: Animation.Infinite
            running: MprisController.activePlayer?.isPlaying || false

            NumberAnimation {
                target: playerAnimation
                properties: "width"
                from: mediaPlayer.childrenRect.width / 3
                to: mediaPlayer.childrenRect.width
                duration: 2000
            }

            NumberAnimation {
                target: playerAnimation
                properties: "width"
                to: mediaPlayer.childrenRect.width / 3
                from: mediaPlayer.childrenRect.width
                duration: 2000
            }
        }
    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        x: 20

        Image {
            id: albumArt
            source: MprisController.activePlayer?.trackArtUrl || ""
            sourceSize.width: 40
            sourceSize.height: 40
            fillMode: Image.PreserveAspectFit
        }
        ColumnLayout {
            spacing: 0

            Text {
                text: MprisController.activePlayer?.trackTitle || ""
                font.family: "IBM Plex Sans"
                color: "white"
                font.bold: true
                font.pixelSize: 16
            }
            Text {
                text: MprisController.activePlayer?.trackArtist || ""
                font.family: "IBM Plex Sans"
                color: "#cccccc"
                font.pixelSize: 16
            }
        }
    }
}
