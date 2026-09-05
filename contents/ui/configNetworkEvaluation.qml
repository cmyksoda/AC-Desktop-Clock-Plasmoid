import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: page

    // 0 welcome, 1 survey, 2 firewall notice, 3 evaluating, 4 cancelled
    property int stage: 0
    property bool surveyNag: false

    function restart() {
        stage = 0
        surveyNag = false
    }

    ColumnLayout {
        spacing: Kirigami.Units.largeSpacing

        // ---- the dialog, at the original's ~400x260 geometry ----------------
        Item {
            id: dialog

            // 1:1 with the 2005 dialog; the text uses the system font and the panel grows to fit it.
            readonly property real s: 1
            readonly property color frameColor: "#602018"
            readonly property color panelColor: "#F7E080"
            readonly property color inkColor: "#1a1a1a"
            readonly property Item current: [welcome, survey, firewall, evaluating, cancelled][page.stage]
            readonly property real panelHeight: Math.max(225 * s, current.implicitHeight + 24 * s)

            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 400 * s
            implicitHeight: panelHeight + 35 * s

            Rectangle {
                anchors.fill: parent
                radius: 12 * dialog.s
                color: dialog.frameColor
            }

            Rectangle {
                id: panel
                x: 5 * dialog.s
                y: 5 * dialog.s
                width: 390 * dialog.s
                height: dialog.panelHeight
                radius: 11 * dialog.s
                color: dialog.panelColor

                Item {
                    id: stages
                    anchors.fill: parent
                    anchors.margins: 12 * dialog.s

                    component DialogText: QQC2.Label {
                        width: stages.width
                        wrapMode: Text.WordWrap
                        color: dialog.inkColor
                        linkColor: "#0000ee"
                    }

                    // -- 0: welcome ----------------------------------------------
                    DialogText {
                        id: welcome
                        visible: page.stage === 0
                        textFormat: Text.StyledText
                        text: "Nintendo Wi-Fi Connection Network Test<br><br><br>"
                              + "Thank you very much for participating in our Wi-Fi Network Test.<br><br>"
                              + "The purpose of this test is to evaluate the connection between your home network and Nintendo. During this evaluation we will be testing your home networking setup and internet connection.<br><br>"
                              + "When the evaluation is complete, you will be able to view the results before sending them to Nintendo. No personally identifiable information is collected or transmitted to Nintendo by this program. This program does not retain any information that could be used to track the information you submit back to you or your computer.<br><br>"
                              + "It will take about 10 minutes for this program to complete its test.If you would like to know more information about this test, please <a href=\"gone\">click here</a>."
                    }

                    // -- 1: survey -----------------------------------------------
                    ColumnLayout {
                        id: survey
                        visible: page.stage === 1
                        width: stages.width
                        spacing: 6 * dialog.s

                        DialogText {
                            Layout.fillWidth: true
                            text: "Before we start the evaluation, please tell us about the networking equipment that is connected to this PC. You must provide answers to the items with (*) before proceeding to the next screen. Please select \"Unknown\" for items you don't know."
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: 6 * dialog.s
                            rowSpacing: 6 * dialog.s

                            DialogText {
                                width: undefined
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                text: "How do you connect to the Internet? (*) :"
                            }
                            QQC2.ComboBox {
                                id: internetBox
                                Layout.preferredWidth: 150 * dialog.s
                                model: ["----", "DSL", "Cable Modem", "FTTH(optical fiber)", "(unknown)"]
                            }

                            DialogText {
                                width: undefined
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                text: "How is your PC connected to your router\nor modem? (*) :"
                            }
                            QQC2.ComboBox {
                                id: linkBox
                                Layout.preferredWidth: 150 * dialog.s
                                model: ["----", "Wired", "Wireless", "(unknown)"]
                            }

                            DialogText {
                                width: undefined
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                text: "What is the brand of your router? (*) :"
                            }
                            QQC2.ComboBox {
                                id: brandBox
                                Layout.preferredWidth: 150 * dialog.s
                                model: ["----", "(Other)", "(Unknown)", "3Com", "ACCTON", "Actiontec", "Airlink", "Apple",
                                        "Belkin", "Buffalo", "D-Link", "Linksys", "Microsoft", "Motorola", "NEC",
                                        "Netgear", "SMC", "U.S.Robotics", "YAMAHA"]
                            }
                        }

                        DialogText {
                            Layout.fillWidth: true
                            Layout.leftMargin: 12 * dialog.s
                            text: "What is your router or modem model number (If you don't know, enter any words and numbers written on the front of the device, and any other information such as shape and color) :"
                        }
                        QQC2.ComboBox {
                            Layout.fillWidth: true
                            Layout.leftMargin: 12 * dialog.s
                            editable: true
                            model: ["----"]
                        }

                        DialogText {
                            Layout.fillWidth: true
                            visible: page.surveyNag
                            color: "#a00000"
                            text: "Please answer the items marked (*)."
                        }
                    }

                    // -- 2: firewall notice --------------------------------------
                    DialogText {
                        id: firewall
                        visible: page.stage === 2
                        text: "Firewall Users Please Note:\n\n"
                              + "If you are using a personal firewall, it may display a warning notice.\n"
                              + "The Animal Crossing Desktop Clock application requires access to the internet in order to communicate with Nintendo's server.\n"
                              + "If you are receiving an alert from your firewall, please click the appropriate button (\"Unlock\",\"Allow\",\"Approve\",etc.) to allow this application to use your internet connection.\n\n\n"
                              + "Please click the Start button below to begin the test."
                    }

                    // -- 3: evaluating (forever: the server is gone) -------------
                    Item {
                        id: evaluating
                        visible: page.stage === 3
                        width: stages.width
                        implicitHeight: 190 * dialog.s

                        DialogText {
                            text: "We are now evaluating your network environment.\n\nPlease wait.\n\nYou may use other programs while you are waiting."
                        }

                        // 36 unlit segments, as the original showed while it waited for a reply
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 128 * dialog.s
                            spacing: 1 * dialog.s
                            Repeater {
                                model: 36
                                Rectangle {
                                    width: 3 * dialog.s
                                    height: 12 * dialog.s
                                    radius: 1 * dialog.s
                                    color: "#cfc7a2"
                                }
                            }
                        }
                    }

                    // -- 4: cancelled --------------------------------------------
                    DialogText {
                        id: cancelled
                        visible: page.stage === 4
                        text: "You cancelled the test before it was complete.\n\n"
                              + "After pressing the OK button below, if you would like to start the test again, right click on the clock and select Network Evaluation from the menu."
                    }
                }
            }

            // ---- button band (the real 2005 sprites) ----------------------------
            Item {
                id: band
                x: 0
                y: panel.y + panel.height
                width: dialog.width
                height: 30 * dialog.s

                SpriteButton {
                    x: 16 * dialog.s; y: 3 * dialog.s
                    pixelScale: dialog.s
                    sheet: Qt.resolvedUrl("../assets/btn_quit.png")
                    cellW: 112
                    visible: page.stage <= 2
                    onClicked: page.restart()
                }
                SpriteButton {
                    x: 16 * dialog.s; y: 3 * dialog.s
                    pixelScale: dialog.s
                    sheet: Qt.resolvedUrl("../assets/btn_sheet.png")
                    row: 1                                   // Abort
                    visible: page.stage === 3
                    onClicked: page.stage = 4
                }
                SpriteButton {
                    x: 216 * dialog.s; y: 3 * dialog.s
                    pixelScale: dialog.s
                    sheet: Qt.resolvedUrl("../assets/btn_sheet.png")
                    row: 4                                   // < Back
                    visible: page.stage === 1 || page.stage === 2
                    onClicked: { page.surveyNag = false; page.stage -= 1 }
                }
                SpriteButton {
                    x: 304 * dialog.s; y: 3 * dialog.s
                    pixelScale: dialog.s
                    sheet: Qt.resolvedUrl("../assets/btn_sheet.png")
                    row: 3                                   // Next >
                    visible: page.stage === 0 || page.stage === 1 || page.stage === 3
                    enabled: page.stage !== 3
                    onClicked: {
                        if (page.stage === 1) {
                            page.surveyNag = internetBox.currentIndex === 0 || linkBox.currentIndex === 0
                                             || brandBox.currentIndex === 0
                            if (page.surveyNag) return
                        }
                        page.stage += 1
                    }
                }
                SpriteButton {
                    x: 304 * dialog.s; y: 3 * dialog.s
                    pixelScale: dialog.s
                    sheet: Qt.resolvedUrl("../assets/btn_sheet.png")
                    row: 0                                   // Start
                    visible: page.stage === 2
                    onClicked: page.stage = 3
                }
                SpriteButton {
                    x: 336 * dialog.s; y: 3 * dialog.s
                    pixelScale: dialog.s
                    sheet: Qt.resolvedUrl("../assets/btn_ok.png")
                    cellW: 48
                    visible: page.stage === 4
                    onClicked: page.restart()
                }
            }
        }

        QQC2.Label {
            Layout.fillWidth: true
            Layout.maximumWidth: dialog.width
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            opacity: 0.8
            font: Kirigami.Theme.smallFont
            text: i18n("In the summer of 2005, Nintendo of America distributed this desktop widget as an incentive for participating in a ten-minute connectivity test ahead of the Nintendo Wi-Fi Connection launch. The dialog above is a replica rebuilt from footage of the original. Its test server was retired long ago, so the evaluation never completes and nothing is sent anywhere; Abort returns you to the start, just as it did then.")
        }

        Kirigami.Separator {
            Layout.fillWidth: true
            Layout.maximumWidth: dialog.width
            Layout.alignment: Qt.AlignHCenter
        }

        // ---- the About box, same chrome, for the banner art -------------------
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 240 * dialog.s
            implicitHeight: 205 * dialog.s
            radius: 12 * dialog.s
            color: dialog.frameColor

            Rectangle {
                x: 5 * dialog.s; y: 5 * dialog.s
                width: 230 * dialog.s
                height: 195 * dialog.s
                radius: 11 * dialog.s
                color: dialog.panelColor

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 16 * dialog.s
                    source: Qt.resolvedUrl("../assets/logo.png")
                    width: 191 * dialog.s
                    height: 137 * dialog.s
                    smooth: Math.abs(dialog.s - Math.round(dialog.s)) > 0.01
                }
                QQC2.Label {
                    x: 20 * dialog.s; y: 172 * dialog.s
                    color: dialog.inkColor
                    text: "(C)2005 Nintendo"
                }
                QQC2.Label {
                    anchors.right: parent.right; anchors.rightMargin: 20 * dialog.s
                    y: 166 * dialog.s
                    color: dialog.inkColor
                    text: "ver. 1.1"
                }
            }
        }
    }
}
