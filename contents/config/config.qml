import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "preferences-desktop-color"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: i18n("Network Evaluation")
        icon: "network-wireless"
        source: "configNetworkEvaluation.qml"
    }
}
