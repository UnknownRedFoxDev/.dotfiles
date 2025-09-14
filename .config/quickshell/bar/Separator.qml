import QtQuick

Text {
    required property string separator
    required property string fgColor
    required property string bgColor

    property string fontFamily: "FiraCode Nerd Font"
    property int fontSize: 21

    text: separator
    color: fgColor
    font.family: fontFamily
    font.pixelSize: fontSize
    Rectangle {
        anchors.fill: parent
        color: bgColor
        z: -1
    }
}
