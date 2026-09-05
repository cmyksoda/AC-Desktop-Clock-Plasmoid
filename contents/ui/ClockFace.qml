import QtQuick

Item {
    id: face

    readonly property int nativeWidth: 145
    readonly property int nativeHeight: 69

    property real pixelScale: 2
    property date now: new Date()
    property bool use24h: false
    property bool blinkColon: true
    property bool animate: true

    signal flipped()

    // Fractional scales look better with linear filtering; integer scales must be nearest.
    readonly property bool smoothing: Math.abs(pixelScale - Math.round(pixelScale)) > 0.01

    width: nativeWidth * pixelScale
    height: nativeHeight * pixelScale

    // ---- derived time fields --------------------------------------------
    readonly property int hour: now.getHours()
    readonly property int minute: now.getMinutes()
    readonly property int month: now.getMonth() + 1
    readonly property int day: now.getDate()
    readonly property int weekday: now.getDay()          // 0 = Sunday, matches the sheet
    readonly property bool pm: hour >= 12

    readonly property int hour12: (hour % 12) === 0 ? 12 : hour % 12
    readonly property int shownHour: use24h ? hour : hour12
    readonly property int hourTens: use24h ? Math.floor(shownHour / 10)
                                           : (shownHour >= 10 ? 1 : -1)   // -1 = blank cell
    readonly property int hourOnes: shownHour % 10
    readonly property int minTens: Math.floor(minute / 10)
    readonly property int minOnes: minute % 10

    // ---- sheet lookups ---------------------------------------------------
    // digit_roll.png: rows 0-9 = 0->1 ... 9->0; then blank->1, 1->blank, 1->0, 2->1, 5->0
    readonly property var digitTransitions: ({
        "0>1": 0, "1>2": 1, "2>3": 2, "3>4": 3, "4>5": 4,
        "5>6": 5, "6>7": 6, "7>8": 7, "8>9": 8, "9>0": 9,
        "-1>1": 10, "1>-1": 11, "1>0": 12, "2>1": 13, "5>0": 14
    })
    // Resting art is col 5 of a row that ends in v.
    function digitRestRow(v) { return v < 0 ? 11 : (v === 0 ? 9 : v - 1) }
    function digitTransition(a, b) {
        const r = digitTransitions[a + ">" + b]
        return r === undefined ? -1 : r
    }

    // date_flip.png: rows 0-29 = 1->2 ... 30->31; 30..33 = 28/29/30/31 -> 1; 34 = 12 -> 1
    function dateRestRow(v) { return v === 1 ? 33 : v - 2 }
    function dateTransition(a, b) {
        if (b === a + 1 && a >= 1 && a <= 30) return a - 1
        if (b === 1) {
            if (a === 28) return 30
            if (a === 29) return 31
            if (a === 30) return 32
            if (a === 31) return 33
            if (a === 12) return 34
        }
        return -1
    }

    // ---- colon blink: one second on, one second off, like the original ---
    property bool colonOn: true
    Timer {
        interval: 1000
        repeat: true
        running: face.blinkColon && face.visible
        onTriggered: face.colonOn = !face.colonOn
        onRunningChanged: if (!running) face.colonOn = true
    }

    // ---- the face, in native pixels --------------------------------------
    Item {
        id: canvas
        width: face.nativeWidth
        height: face.nativeHeight
        scale: face.pixelScale
        transformOrigin: Item.TopLeft

        // Top row
        FlipCell {
            id: monthCell
            x: 20; y: 0
            sheet: Qt.resolvedUrl("../assets/date_flip.png")
            cellW: 41; cellH: 41
            value: face.month
            animate: face.animate
            smoothing: face.smoothing
            restRowFor: face.dateRestRow
            transitionRowFor: face.dateTransition
            onFlipped: face.flipped()
        }

        Image {
            x: 59; y: 25
            source: Qt.resolvedUrl("../assets/dot.png")
            smooth: face.smoothing
        }

        FlipCell {
            id: dayCell
            x: 71; y: 0
            sheet: Qt.resolvedUrl("../assets/date_flip.png")
            cellW: 41; cellH: 41
            value: face.day
            animate: face.animate
            smoothing: face.smoothing
            restRowFor: face.dateRestRow
            transitionRowFor: face.dateTransition
            onFlipped: face.flipped()
        }

        SheetSprite {
            x: 112; y: 7
            sheet: Qt.resolvedUrl("../assets/weekday.png")
            cellW: 33; cellH: 33
            col: face.weekday
            smoothing: face.smoothing
        }

        // Bottom row
        SheetSprite {
            x: 0; y: 41
            sheet: Qt.resolvedUrl("../assets/ampm.png")
            cellW: 27; cellH: 27
            col: face.pm ? 1 : 0
            visible: !face.use24h
            smoothing: face.smoothing
        }

        FlipCell {
            x: 27; y: 40
            sheet: Qt.resolvedUrl("../assets/digit_roll.png")
            value: face.hourTens
            animate: face.animate
            smoothing: face.smoothing
            restRowFor: face.digitRestRow
            transitionRowFor: face.digitTransition
            onFlipped: face.flipped()
        }

        FlipCell {
            x: 54; y: 40
            sheet: Qt.resolvedUrl("../assets/digit_roll.png")
            value: face.hourOnes
            animate: face.animate
            smoothing: face.smoothing
            restRowFor: face.digitRestRow
            transitionRowFor: face.digitTransition
            onFlipped: face.flipped()
        }

        Image {
            x: 82; y: 45
            source: Qt.resolvedUrl("../assets/colon.png")
            visible: face.colonOn
            smooth: face.smoothing
        }

        FlipCell {
            x: 90; y: 40
            sheet: Qt.resolvedUrl("../assets/digit_roll.png")
            value: face.minTens
            animate: face.animate
            smoothing: face.smoothing
            restRowFor: face.digitRestRow
            transitionRowFor: face.digitTransition
            onFlipped: face.flipped()
        }

        FlipCell {
            x: 117; y: 40
            sheet: Qt.resolvedUrl("../assets/digit_roll.png")
            value: face.minOnes
            animate: face.animate
            smoothing: face.smoothing
            restRowFor: face.digitRestRow
            transitionRowFor: face.digitTransition
            onFlipped: face.flipped()
        }
    }
}
