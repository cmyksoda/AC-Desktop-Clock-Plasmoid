import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: page

    property alias cfg_use24h: use24h.checked
    property alias cfg_pixelScale: pixelScale.value
    property alias cfg_blinkColon: blinkColon.checked
    property alias cfg_flipAnimation: flipAnimation.checked
    property alias cfg_flipSounds: flipSounds.checked
    property alias cfg_chimeEnabled: chimeEnabled.checked
    property alias cfg_chimeVolume: chimeVolume.value
    property alias cfg_quietHoursEnabled: quietHours.checked
    property alias cfg_quietStart: quietStart.value
    property alias cfg_quietEnd: quietEnd.value

    Kirigami.FormLayout {
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Display")
        }

        QQC2.CheckBox {
            id: use24h
            Kirigami.FormData.label: i18n("Time format:")
            text: i18n("24-hour clock")
        }

        QQC2.SpinBox {
            id: pixelScale
            Kirigami.FormData.label: i18n("Pixel scale (desktop):")
            from: 1
            to: 8
            textFromValue: function (value) { return value + "×" }
        }

        QQC2.CheckBox {
            id: blinkColon
            Kirigami.FormData.label: i18n("Colon:")
            text: i18n("Blink on and off")
        }

        QQC2.CheckBox {
            id: flipAnimation
            Kirigami.FormData.label: i18n("Flip counters:")
            text: i18n("Animate when the time changes")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Sound")
        }

        QQC2.CheckBox {
            id: chimeEnabled
            Kirigami.FormData.label: i18n("Town chime:")
            text: i18n("Play at the top of every hour")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Volume:")
            QQC2.Slider {
                id: chimeVolume
                from: 0
                to: 1
                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
            }
            QQC2.Label {
                text: Math.round(chimeVolume.value * 100) + "%"
            }
        }

        QQC2.CheckBox {
            id: flipSounds
            Kirigami.FormData.label: i18n("Flip sounds:")
            text: i18n("Tick when a counter flips")
        }

        QQC2.CheckBox {
            id: quietHours
            Kirigami.FormData.label: i18n("Quiet hours:")
            text: i18n("Mute the chime between")
        }

        RowLayout {
            enabled: quietHours.checked
            QQC2.SpinBox {
                id: quietStart
                from: 0
                to: 23
                textFromValue: function (value) { return ("0" + value).slice(-2) + ":00" }
            }
            QQC2.Label { text: i18n("and") }
            QQC2.SpinBox {
                id: quietEnd
                from: 0
                to: 23
                textFromValue: function (value) { return ("0" + value).slice(-2) + ":00" }
            }
        }
    }
}
