import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Particles
import QtQuick.Shapes

import "../components"
import "../services"
import "../utils"

Rectangle {
    id: mediaPlayer
    color: "transparent"


    RowLayout {
        anchors.top: parent.top
        anchors.topMargin: 20
        width: parent.width
        spacing: 20

        Rectangle {
            width: albumArt.width || 250
            height: albumArt.height || 250
            Layout.leftMargin: 20
            Layout.alignment: Qt.AlignLeft

            Image {
                id: albumArt
                source: MprisController.activePlayer?.trackArtUrl || ""
                sourceSize.width: 250
                sourceSize.height: 250
                fillMode: Image.PreserveAspectFit
            }

        }

        ColumnLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.topMargin: 10

            Text {
                text: MprisController.activePlayer?.trackTitle || ""
                font.family: "IBM Plex Sans"
                color: "white"
                font.bold: true
                font.pixelSize: 50
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


    Shape {
        id: playIndicator
        visible: MprisController.activePlayer?.isPlaying || false
        opacity: 0.2
        width: albumArt.width + 40
        height: albumArt.height + 40
        // multisample, decide based on your scene settings
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            fillColor: "black"
            strokeWidth: 0

            PathAngleArc {
                id: path
                centerX: albumArt.x + (albumArt.width / 2) + 20
                centerY: albumArt.y + (albumArt.height / 2) + 20
                radiusX: (albumArt.width / 2) + 10
                radiusY: (albumArt.height / 2) + 10
                startAngle: -180
                sweepAngle: 360
            }
        }

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            ScaleAnimator {
                target: playIndicator
                from: 0.5
                to: 1.1
                duration: 2000
            }
            ScaleAnimator {
                target: playIndicator
                from: 1.1
                to: 0.5
                duration: 2000
            }
        }
    }
}
