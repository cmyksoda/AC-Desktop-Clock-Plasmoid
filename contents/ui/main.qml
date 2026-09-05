import QtQuick
import QtQuick.Layouts
import QtMultimedia
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    property date now: new Date()
    property int lastMinute: -1
    property int tickToggle: 0

    readonly property bool onPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                                    || Plasmoid.formFactor === PlasmaCore.Types.Vertical

    // The original was a shaped, background-less window; keep it that way by default.
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground | PlasmaCore.Types.ConfigurableBackground

    toolTipMainText: Qt.formatDate(now, "dddd, d MMMM yyyy")
    toolTipSubText: Qt.formatTime(now, Plasmoid.configuration.use24h ? "HH:mm" : "h:mm AP")

    preferredRepresentation: fullRepresentation

    // ---- clock source ----------------------------------------------------
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.tick()
    }

    function tick() {
        const d = new Date()
        root.now = d
        const m = d.getMinutes()
        if (root.lastMinute !== -1 && m === 0 && root.lastMinute !== 0) {
            root.chimeIfAllowed(d.getHours())
        }
        root.lastMinute = m
    }

    function inQuietHours(h) {
        if (!Plasmoid.configuration.quietHoursEnabled) return false
        const s = Plasmoid.configuration.quietStart
        const e = Plasmoid.configuration.quietEnd
        return s <= e ? (h >= s && h < e) : (h >= s || h < e)
    }

    function chimeIfAllowed(h) {
        if (Plasmoid.configuration.chimeEnabled && !inQuietHours(h)) {
            chime.play()
        }
    }

    // ---- sounds ----------------------------------------------------------
    SoundEffect {
        id: chime
        source: Qt.resolvedUrl("../assets/chime_hourly.wav")
        volume: Plasmoid.configuration.chimeVolume
    }
    SoundEffect {
        id: tickA
        source: Qt.resolvedUrl("../assets/sfx_tick_a.wav")
        volume: Plasmoid.configuration.chimeVolume
    }
    SoundEffect {
        id: tickB
        source: Qt.resolvedUrl("../assets/sfx_tick_b.wav")
        volume: Plasmoid.configuration.chimeVolume
    }

    // One tick per rollover, alternating the two samples; several cells flip in the same instant.
    property double lastFlipMs: 0
    function playFlip() {
        if (!Plasmoid.configuration.flipSounds) return
        const t = Date.now()
        if (t - root.lastFlipMs < 200) return
        root.lastFlipMs = t
        root.tickToggle = 1 - root.tickToggle
        if (root.tickToggle === 0) tickA.play(); else tickB.play()
    }

    // ---- right-click menu extras ----------------------------------------
    // "Alarm" is what the 2005 menu called the hourly chime toggle.
    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Alarm")
            icon.name: "notifications"
            checkable: true
            checked: Plasmoid.configuration.chimeEnabled
            onTriggered: checked => { Plasmoid.configuration.chimeEnabled = checked }
        },
        PlasmaCore.Action {
            text: i18n("Play the town chime")
            icon.name: "media-playback-start"
            onTriggered: chime.play()
        }
    ]

    // ---- representation --------------------------------------------------
    fullRepresentation: Item {
        id: full

        // On a panel, fit the panel's thickness; on the desktop, honour the configured integer scale.
        readonly property real fitScale: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
            ? full.height / face.nativeHeight
            : full.width / face.nativeWidth
        readonly property real s: root.onPanel ? fitScale : Plasmoid.configuration.pixelScale

        Layout.preferredWidth: face.nativeWidth * s
        Layout.preferredHeight: face.nativeHeight * s
        Layout.minimumWidth: root.onPanel ? face.nativeWidth * s : face.nativeWidth
        Layout.minimumHeight: root.onPanel ? 0 : face.nativeHeight

        ClockFace {
            id: face
            anchors.centerIn: parent
            pixelScale: full.s
            now: root.now
            use24h: Plasmoid.configuration.use24h
            blinkColon: Plasmoid.configuration.blinkColon
            animate: Plasmoid.configuration.flipAnimation
            onFlipped: root.playFlip()
        }

        PlasmaCore.ToolTipArea {
            anchors.fill: face
            mainText: root.toolTipMainText
            subText: root.toolTipSubText
        }
    }
}
