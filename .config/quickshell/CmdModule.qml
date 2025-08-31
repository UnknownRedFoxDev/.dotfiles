import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    property string typeDate: "date"
    property int interval: 60000
    property string fgColor: "#000000"
    property string bgColor: "#FFFFFF"
    property string textPadding: ""
    property int fontSize: 21
    color: bgColor
    implicitWidth: textItem.implicitWidth
    implicitHeight: textItem.implicitHeight

    Text {
        id: textItem
        anchors.centerIn: parent
        font.family: "FiraCode Nerd Font"
        font.pixelSize: fontSize
        color: fgColor
        padding: textPadding // Add padding around text
        Process {
            id: proc
            command: typeDate = "date" ? ["date", "+%a %d %b"] : ["date", "+%H:%M"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: parent.text = textPadding + this.text + textPadding
            }
        }
        Timer {
            interval: parent.interval
            running: true
            repeat: true
            onTriggered: proc.running = true
        }
    }
}
