/*!
 * This file is part of WatchFlower.
 * COPYRIGHT (C) 2019 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \date      2018
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

import QtQuick 2.9
import QtQuick.Controls 2.2

import com.watchflower.theme 1.0
import "UtilsNumber.js" as UtilsNumber

Item {
    id: deviceScreenLimits

    function updateHeader() {
        if (typeof myDevice === "undefined" || !myDevice) return
        //console.log("DeviceScreenLimits // updateHeader() >> " + myDevice)

        // Sensor battery level
        if (myDevice.hasBatteryLevel()) {
            imageBattery.visible = true
            imageBattery.color = Theme.colorIcons

            if (myDevice.deviceBattery > 95) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_full-24px.svg";
            } else if (myDevice.deviceBattery > 85) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_90-24px.svg";
            } else if (myDevice.deviceBattery > 75) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_80-24px.svg";
            } else if (myDevice.deviceBattery > 55) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_60-24px.svg";
            } else if (myDevice.deviceBattery > 45) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_50-24px.svg";
            } else if (myDevice.deviceBattery > 25) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_30-24px.svg";
            } else if (myDevice.deviceBattery > 15) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_20-24px.svg";
            } else if (myDevice.deviceBattery > 1) {
                if (myDevice.deviceBattery <= 10) imageBattery.color = Theme.colorYellow
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_10-24px.svg";
            } else {
                if (myDevice.deviceBattery === 0) imageBattery.color = Theme.colorRed
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_unknown-24px.svg";
            }
        } else {
            imageBattery.source = "qrc:/assets/icons_material/baseline-battery_unknown-24px.svg";
            imageBattery.visible = false
        }

        // Sensor address
        if (myDevice.deviceAddress.charAt(0) !== '{')
            textAddr.text = "[" + myDevice.deviceAddress + "]"

        // Firmware
        textFirmware.text = myDevice.deviceFirmware
        if (!myDevice.deviceFirmwareUpToDate) {
            imageFwUpdate.visible = true
            textFwUpdate.visible = true
        } else {
            imageFwUpdate.visible = false
            textFwUpdate.visible = false
        }
    }

    function updateLimits() {
        if (typeof myDevice === "undefined" || !myDevice) return

        rangeSlider_hygro.second.value = myDevice.limitHygroMax
        rangeSlider_hygro.first.value = myDevice.limitHygroMin
        rangeSlider_temp.second.value = myDevice.limitTempMax
        rangeSlider_temp.first.value = myDevice.limitTempMin
        rangeSlider_lumi.second.value = myDevice.limitLumiMax
        rangeSlider_lumi.first.value = myDevice.limitLumiMin
        rangeSlider_condu.second.value = myDevice.limitConduMax
        rangeSlider_condu.first.value = myDevice.limitConduMin
    }

    function updateLimitsVisibility() {
        if (typeof myDevice === "undefined" || !myDevice) return

        itemTemp.visible = myDevice.hasTemperatureSensor()
        itemHygro.visible = myDevice.hasHumiditySensor() || myDevice.hasSoilMoistureSensor()
        itemLumi.visible = myDevice.hasLuminositySensor()
        itemCondu.visible = myDevice.hasConductivitySensor()
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleHeader
        color: Theme.colorForeground
        height: (Qt.platform.os === "android" || Qt.platform.os === "ios") ? 100 : 140
        z: 5

        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        Column {
            id: devicePanel
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 2
            anchors.right: parent.right
            anchors.left: parent.left

            Text {
                id: textDeviceName
                height: 36
                anchors.left: parent.left
                anchors.leftMargin: 12

                visible: (Qt.platform.os !== "android" && Qt.platform.os !== "ios")

                font.pixelSize: 24
                text: myDevice.deviceName
                verticalAlignment: Text.AlignVCenter
                font.capitalization: Font.AllUppercase
                color: Theme.colorText

                ImageSvg {
                    id: imageBattery
                    width: 32
                    height: 32
                    rotation: 90
                    anchors.verticalCenter: textDeviceName.verticalCenter
                    anchors.left: textDeviceName.right
                    anchors.leftMargin: 16

                    source: "qrc:/assets/icons_material/baseline-battery_unknown-24px.svg"
                    color: Theme.colorIcons
                }
            }

            Item {
                id: address
                height: 28
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: labelAddress
                    width: (Qt.platform.os === "android" || Qt.platform.os === "ios") ? 80 : 96
                    anchors.leftMargin: 12
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Address")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.colorText
                    font.pixelSize: 18
                }

                Text {
                    id: textAddr
                    anchors.left: labelAddress.right
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: myDevice.deviceAddress
                    font.pixelSize: 18
                    color: Theme.colorHighContrast
                }
            }

            Item {
                id: firmware
                height: 28
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: labelFirmware
                    width: (Qt.platform.os === "android" || Qt.platform.os === "ios") ? 80 : 96
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    text: qsTr("Firmware")
                    font.pixelSize: 18
                    horizontalAlignment: Text.AlignRight
                }
                Text {
                    id: textFirmware
                    anchors.left: labelFirmware.right
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Update available!")
                    font.pixelSize: 18
                    color: Theme.colorHighContrast
                }
                ImageSvg {
                    id: imageFwUpdate
                    width: 20
                    height: 20
                    anchors.left: textFirmware.right
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-new_releases-24px.svg"
                    color: Theme.colorIcons

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: textFwUpdate.text = qsTr("Use official app to upgrade")
                        onExited: textFwUpdate.text = qsTr("Update available!")
                    }
                }

                Text {
                    id: textFwUpdate
                    anchors.left: imageFwUpdate.right
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Update available!")
                    font.pixelSize: 14
                    color: Theme.colorHighContrast
                }
            }

            Item {
                id: battery
                height: 28
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: textBattery
                    anchors.left: labelBattery.right
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: myDevice.deviceBattery + "%"
                    font.pixelSize: 18
                    color: Theme.colorHighContrast
                }

                Text {
                    id: labelBattery
                    width: (Qt.platform.os === "android" || Qt.platform.os === "ios") ? 80 : 96
                    horizontalAlignment: Text.AlignRight
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Battery")
                    color: Theme.colorText
                    font.pixelSize: 18
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        anchors.top: rectangleHeader.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        width: parent.width
        contentWidth: parent.width

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        //ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        Column {
            id: deviceLimits
            width: parent.width
            spacing: 8

            Item { //////
                id: itemHygro
                height: 64
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: imageHygro
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/assets/icons_material/baseline-opacity-24px.svg"
                    color: Theme.colorHighContrast
                }
                Text {
                    id: text8
                    width: 32
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: imageHygro.right

                    text: rangeSlider_hygro.first.value.toFixed(0) + "%"
                    font.pixelSize: 14
                    color: Theme.colorText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                RangeSliderThemed {
                    id: rangeSlider_hygro
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: text9.left
                    anchors.left: text8.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0

                    from: 0
                    to: 66
                    stepSize: 1
                    first.onValueChanged: if (myDevice) myDevice.limitHygroMin = first.value.toFixed(0);
                    second.onValueChanged: if (myDevice) myDevice.limitHygroMax = second.value.toFixed(0);
                }
                Text {
                    id: text9
                    width: 32
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 4

                    text: rangeSlider_hygro.second.value.toFixed(0) + "%"
                    color: Theme.colorText
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text {
                id: legendHygro
                anchors.left: parent.left
                anchors.leftMargin: 52
                anchors.right: parent.right
                anchors.rightMargin: 12

                topPadding: -16
                visible: itemHygro.visible

                text: qsTr("Usual soil moisture window is 15 to 50% for indoor plants. Succulent can go as low as 7%. Tropical plants can live with more water. " +
                           "Also, be careful: too much water over long periods of time can be just as lethal as not enough!<br>" +
                           "<b>Tip:</b> Water your plants more frequently during growth period.")
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }

            Item { //////
                id: itemTemp
                height: 64
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                ImageSvg {
                    id: imageTemp
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/assets/icons_material/baseline-ac_unit-24px.svg"
                    color: Theme.colorHighContrast
                }
                Text {
                    id: text3
                    width: 32
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: imageTemp.right

                    text: ((settingsManager.tempUnit === "F") ? UtilsNumber.tempCelsiusToFahrenheit(rangeSlider_temp.first.value).toFixed(0) : rangeSlider_temp.first.value.toFixed(0)) + "°"
                    font.pixelSize: 14
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                RangeSliderThemed {
                    id: rangeSlider_temp
                    height: 40
                    anchors.right: text5.left
                    anchors.rightMargin: 0
                    anchors.left: text3.right
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    from: 0
                    to: 40
                    stepSize: 1
                    first.onValueChanged: if (myDevice) myDevice.limitTempMin = first.value.toFixed(0);
                    second.onValueChanged: if (myDevice) myDevice.limitTempMax = second.value.toFixed(0);
                }
                Text {
                    id: text5
                    width: 32
                    height: 32
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    text: ((settingsManager.tempUnit === "F") ? UtilsNumber.tempCelsiusToFahrenheit(rangeSlider_temp.second.value).toFixed(0) : rangeSlider_temp.second.value.toFixed(0)) + "°"
                    font.pixelSize: 14
                    color: Theme.colorText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text {
                id: legendTemp
                anchors.left: parent.left
                anchors.leftMargin: 52
                anchors.right: parent.right
                anchors.rightMargin: 12

                topPadding: -16
                visible: itemTemp.visible

                text: qsTr("Most indoor plants thrive between 15 and 25°C (59 to 77°F). Not many plants can tolerate -2°C (28°F) and below. Constant temperature is usually more important than the absolute values.<br>" +
                           "<b>Tip:</b> If you have an hygrometer, you can monitor the air humidity so it stays between 40 and 60% (and even above for tropical plants).")
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }

            Item { //////
                id: itemLumi
                height: 64
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: imageLumi
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/assets/icons_material/baseline-wb_sunny-24px.svg"
                    color: Theme.colorHighContrast
                }
                Text {
                    id: text1
                    width: 32
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: imageLumi.right

                    text: rangeSlider_lumi.first.value.toFixed(0) / 1000 + "k"
                    font.pixelSize: 14
                    color: Theme.colorText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                RangeSliderThemed {
                    id: rangeSlider_lumi
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: text2.left
                    anchors.left: text1.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0

                    from: 0
                    to: 10000
                    stepSize: 1000
                    first.onValueChanged: if (myDevice) myDevice.limitLumiMin = first.value.toFixed(0);
                    second.onValueChanged: if (myDevice) myDevice.limitLumiMax = second.value.toFixed(0);

                    Row {
                        id: sections
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 20

                        spacing: 3

                        Rectangle {
                            height: 16
                            width: ((sections.width - 12) / 10) * 1 // 0 to 1k
                            color: Theme.colorGrey
                            Text {
                                text: qsTr("low")
                                font.pixelSize: 12; color: "white";
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Rectangle {
                            height: 16
                            width: ((sections.width - 12) / 10) * 2 // 1k to 3k
                            color: "grey"
                            Text {
                                text: qsTr("indirect")
                                font.pixelSize: 12; color: "white";
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Rectangle {
                            height: 16
                            width: ((sections.width - 12) / 10) * 5 // 3k to 8k
                            color: Theme.colorYellow
                            Text {
                                text: qsTr("direct light (indoor)")
                                font.pixelSize: 12; color: "white";
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Rectangle {
                            height: 16
                            width: ((sections.width - 12) / 10) * 2 // 8k+
                            color: "orange"
                            Text {
                                text: qsTr("sunlight")
                                font.pixelSize: 12; color: "white";
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
                Text {
                    id: text2
                    width: 32
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 4

                    text: rangeSlider_lumi.second.value.toFixed(0) / 1000 + "k"
                    color: Theme.colorText
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text {
                id: legendLumi
                anchors.left: parent.left
                anchors.leftMargin: 52
                anchors.right: parent.right
                anchors.rightMargin: 12

                topPadding: -4
                visible: itemLumi.visible

                text: qsTr("Some plants like direct sun exposition. Some can accommodate it for part of the day. Many indoor plants don't like direct sunlight: place them away from south oriented windows!")
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }

            Item { //////
                id: itemCondu
                height: 64
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: imageCondu
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/assets/icons_material/baseline-flash_on-24px.svg"
                    color: Theme.colorHighContrast
                }
                Text {
                    id: text7
                    width: 32
                    height: 32
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    text: rangeSlider_condu.second.value.toFixed(0)
                    font.pixelSize: 14
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                RangeSliderThemed {
                    id: rangeSlider_condu
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: text7.left
                    anchors.left: text6.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0

                    from: 0
                    to: 500
                    stepSize: 10
                    first.onValueChanged: if (myDevice) myDevice.limitConduMin = first.value.toFixed(0);
                    second.onValueChanged: if (myDevice) myDevice.limitConduMax = second.value.toFixed(0);
                }
                Text {
                    id: text6
                    width: 32
                    height: 32
                    anchors.left: imageCondu.right
                    anchors.verticalCenter: parent.verticalCenter

                    text: rangeSlider_condu.first.value.toFixed(0)
                    font.pixelSize: 14
                    color: Theme.colorText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text {
                id: legendCondu
                anchors.left: parent.left
                anchors.leftMargin: 52
                anchors.right: parent.right
                anchors.rightMargin: 12

                topPadding: -16
                visible: itemCondu.visible

                text: qsTr("Soil fertility is more of an indication than an absolute value to take into account. However, be sure to have the right soil composition for your plant.")
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }

            Item { // spacer
                height: 16
                anchors.right: parent.right
                anchors.left: parent.left
            }
        }
    }
}
