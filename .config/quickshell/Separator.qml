import QtQuick

Text {
    property string sepText: ""
    property string fgColor: "#569FBA"
    property string bgColor: "#000000"
    property int fontSize: 21
    text: sepText
    color: fgColor
    font.family: "FiraCode Nerd Font"
    font.pixelSize: fontSize
    Rectangle {
        anchors.fill: parent
        color: bgColor
        z: -1
    }
}
