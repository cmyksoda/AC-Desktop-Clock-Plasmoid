import QtQuick

Item {
    id: cell

    property url sheet
    property int cellW: 28
    property int cellH: 28
    property int frameMs: 33      // the original's 33 ms timer, confirmed frame-by-frame on video
    property bool animate: true
    property bool smoothing: false

    // Display value. Use -1 for "blank" where the sheet supports it.
    property int value: 0

    // Sheet-specific lookups, provided by the parent.
    property var restRowFor: function (v) { return v }           // any row whose col 5 shows v
    property var transitionRowFor: function (a, b) { return -1 }

    signal flipped()

    property int _shown: -2      // -2 = nothing shown yet
    property int _target: 0

    width: cellW
    height: cellH

    SheetSprite {
        id: sprite
        anchors.fill: parent
        sheet: cell.sheet
        cellW: cell.cellW
        cellH: cell.cellH
        smoothing: cell.smoothing
    }

    Timer {
        id: frameTimer
        interval: cell.frameMs
        repeat: true
        onTriggered: {
            sprite.col += 1
            if (sprite.col >= 5) {
                frameTimer.stop()
                cell._shown = cell._target
            }
        }
    }

    function _snap(v) {
        frameTimer.stop()
        sprite.row = restRowFor(v)
        sprite.col = 5
        _shown = v
    }

    onValueChanged: {
        if (_shown === -2 || !animate) {
            _snap(value)
            return
        }
        if (frameTimer.running) {
            // Interrupted mid-flip: finish instantly, then flip to the new value.
            _snap(_target)
        }
        if (value === _shown) {
            return
        }
        const row = transitionRowFor(_shown, value)
        if (row < 0) {
            _snap(value)
            return
        }
        _target = value
        sprite.row = row
        sprite.col = 0
        frameTimer.start()
        flipped()
    }

    Component.onCompleted: _snap(value)
}
