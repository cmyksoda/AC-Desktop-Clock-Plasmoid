import QtQuick

// One cell of a sprite sheet, selected by (col, row). Named to avoid QtQuick's own Sprite type.
// Uses clipping rather than Image.sourceClipRect so frame changes never
// trigger an image reload — important for the 6-frame flip animation.
Item {
    id: sprite

    property url sheet
    property int cellW: 28
    property int cellH: 28
    property int col: 0
    property int row: 0
    property bool smoothing: false

    width: cellW
    height: cellH
    clip: true

    Image {
        x: -sprite.col * sprite.cellW
        y: -sprite.row * sprite.cellH
        source: sprite.sheet
        fillMode: Image.Pad
        smooth: sprite.smoothing
        mipmap: false
        asynchronous: false
        cache: true
    }
}
