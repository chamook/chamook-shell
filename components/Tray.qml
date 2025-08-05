import Quickshell.Services.SystemTray
import QtQuick

Item {
    id: root

    readonly property Repeater items: items

    clip: true
    visible: width > 0 && height > 0 // To avoid warnings about being visible with no size

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    Row {
        id: layout

        spacing: 7

        add: Transition {
            NumberAnimation {
                properties: "scale"
                from: 0
                to: 1
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0, 0, 0, 1, 1, 1]
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "scale"
                to: 1
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0, 0, 0, 1, 1, 1]
            }
            NumberAnimation {
                properties: "x,y"
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
            }
        }

        Repeater {
            id: items

            model: SystemTray.items

            TrayItem {}
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 400
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 400
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        }
    }
}
