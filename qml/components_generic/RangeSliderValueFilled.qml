import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0
import "qrc:/js/UtilsNumber.js" as UtilsNumber

RangeSlider {
    id: control
    first.value: 0.25
    second.value: 0.75
    snapMode: RangeSlider.SnapAlways

    property string unit: ""
    property string colorBg: Theme.colorComponent
    property string colorFg: Theme.colorPrimary
    property string colorTxt: "white"
    property int hhh: 16

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + (control.availableHeight / 2) - (height / 2)
        implicitWidth: 200
        implicitHeight: hhh
        width: control.availableWidth

        height: hhh
        radius: hhh
        color: colorBg
        opacity: 0.9

        Rectangle {
            x: (control.first.visualPosition * parent.width)
            width: (control.second.visualPosition * parent.width) - x
            height: parent.height
            color: colorFg
            radius: hhh
        }
    }

    first.handle: Rectangle {
        x: control.leftPadding + first.visualPosition * (control.availableWidth - width)
        y: control.topPadding + (control.availableHeight / 2) - (height / 2)
        implicitWidth: hhh
        implicitHeight: hhh
        width: t1.width + 16

        radius: hhh
        color: colorFg
        border.color: colorFg
        opacity: first.pressed ? 0.9 : 1

        Text {
            id: t1
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter

            text: {
                var vvalue = first.value
                if (unit === "°" && settingsManager.tempUnit === "F") vvalue = UtilsNumber.tempCelsiusToFahrenheit(vvalue)
                vvalue = vvalue.toFixed(0)
                return ((first.value > 999) ? vvalue / 1000 : vvalue) + unit
            }
            font.pixelSize: 10
            font.bold: true
            color: colorTxt
        }
    }

    second.handle: Rectangle {
        x: control.leftPadding + second.visualPosition * (control.availableWidth - width)
        y: control.topPadding + (control.availableHeight / 2) - (height / 2)
        implicitWidth: hhh
        implicitHeight: hhh
        width: t2.width + 16

        radius: hhh
        color: colorFg
        border.color: colorFg
        opacity: second.pressed ? 0.9 : 1

        Text {
            id: t2
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter

            text: {
                var vvalue = second.value
                if (unit === "°" && settingsManager.tempUnit === "F") vvalue = UtilsNumber.tempCelsiusToFahrenheit(vvalue)
                vvalue = vvalue.toFixed(0)
                return ((second.value > 999) ? vvalue / 1000 : vvalue) + unit
            }
            font.pixelSize: 10
            font.bold: true
            color: colorTxt
        }
    }
}