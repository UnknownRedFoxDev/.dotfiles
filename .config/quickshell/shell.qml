import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "."

PanelWindow {
    anchors { top: true; left: true; right: true }
    color: "#191726"
    implicitHeight: 23

    // Container for right-aligned modules
    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: -1

        // Separator 1 ()
        Separator {
            sepText: ""
            fgColor: "#CDCBE0"
            bgColor: "#191726"
            fontSize: 21
        }

        Rectangle {
            implicitWidth: dateText.implicitWidth
            implicitHeight: 25
            color: "#CDCBE0"
            Text {
                id: dateText
                topPadding: 2
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 18
                font.weight: 500
                color: "#191726"
                Process {
                    id: dateProc
                    command: ["date", "+%a %d %b"]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: dateText.text = " " + this.text
                    }
                }
                Timer {
                    interval: 60000 // Update every minute
                    running: true
                    repeat: true
                    onTriggered: dateProc.running = true
                }
            }
        }

        Separator {
            sepText: "  "
            fgColor: "#191726"
            bgColor: "#CDCBE0"
            fontSize: 21
        }

        Rectangle {
            implicitWidth: timeText.implicitWidth
            implicitHeight: 25
            color: "#CDCBE0"
            Text {
                id: timeText
                topPadding: 2
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 18
                font.weight: 500
                color: "#191726"
                Process {
                    id: timeProc
                    command: ["date", "+%H:%M:%S"]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: timeText.text = this.text
                    }
                }
                Timer {
                    interval: 1000 // Update every second
                    running: true
                    repeat: true
                    onTriggered: timeProc.running = true
                }
            }
        }

        Separator {
            sepText: " "
            fgColor: "#569FBA"
            bgColor: "#CDCBE0"
            fontSize: 21
        }
        Button {
            id: button
            Text {
                id: buttonText
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 18
                anchors.centerIn: parent
                text: ""
                color: "#191726"
            }
            background: Rectangle {
                implicitWidth: 28
                implicitHeight: 25
                color: "#569FBA"
            }
            Process {
                id: buttonEvent
                command: "wlogout"
                running: false
            }
            onClicked: buttonEvent.running = true;
        }
    }
}
