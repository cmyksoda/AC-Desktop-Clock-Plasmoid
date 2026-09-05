import QtQuick

// A button skinned with one of the original 3-state button sheets
// (col 0 = normal, col 1 = hover/pressed, col 2 = disabled).
Item {
    id: button

    property url sheet
    property int cellW: 80
    property int cellH: 24
    property int row: 0          // which button label in the sheet
    property real pixelScale: 2

    signal clicked()

    width: cellW * pixelScale
    height: cellH * pixelScale

    SheetSprite {
        sheet: button.sheet
        cellW: button.cellW
        cellH: button.cellH
        row: button.row
        col: !button.enabled ? 2 : (mouse.containsMouse ? 1 : 0)
        scale: button.pixelScale
        smoothing: Math.abs(button.pixelScale - Math.round(button.pixelScale)) > 0.01
        transformOrigin: Item.TopLeft
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: button.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: if (button.enabled) button.clicked()
    }
}
