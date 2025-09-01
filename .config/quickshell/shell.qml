import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "."

// color lightBlue   : #569FBA
// color darkBlue    : #2B4052
// color lightRed    : #EB6F92
// color darkRed     : #583146
// color lightGreen  : #A3BE8C
// color darkGreen   : #424945
// color lightPurple : #C4A7E7
// color darkPurple  : #4C4260
// color lightGray   : #CDCBE0
// color darkGray    : #696580
// color background  : #191726
// powerline no.1 : 
// powerline no.2 : 
// Workspaces:
//     "urgent": " ",
//     "active": " ",
//     "default": " "
// CPU:
//     icon : 
// Memory:
//     icon : 
// Power:
//     icon : " "
//     icons: " ", " ", " ", " ", " "
// Internet:
//     icon : 
//     icon : 󰈀
//     icon : 󰤯
// Backlight:
//     icons: ["", "", "", "", "", "", "", "", ""]
// Temperature:
//     icon: 
//     icon: 
// Audio:
//     icons: [" ", "", " ", " "]

PanelWindow {
    anchors { top: true; left: true; right: true }
    color: "#191726"
    implicitHeight: 25

    // Container for right-aligned modules
    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: -1

        Rectangle {
            implicitWidth: backlightText.implicitWidth
            implicitHeight: 25
            color: "#191726"
            Text {
                id: backlightText
                topPadding: 2
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 18
                font.weight: 500
                color: "#696580"
                property list<string> icons: ["", "", "", "", "", "", "", "", ""]
                property string icon: " "
                property int brightnessLevel: 50
                property int stepCount: 1

                MouseArea {
                    id: brightnessArea
                    anchors.fill: parent
                    onWheel: (wheel) => {
                        let step = backlightText.stepCount;
                        if (wheel.angleDelta.y > 0) {
                            backlightText.brightnessLevel = Math.min(backlightText.brightnessLevel + step, 100);
                            setBacklightProc.running = true
                        } else {
                            backlightText.brightnessLevel = Math.max(backlightText.brightnessLevel - step, 1);
                            setBacklightProc.running = true
                        }
                    }

                }

                Process {
                    id: getBacklightProc
                    command: ["sh", "-c", "brightnessctl | grep '%' | awk '{print $4}'"]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: {
                            var percent = parseInt(backlightText.brightnessLevel)
                            if (percent < 10) backlightText.icon = backlightText.icons[0]
                            else if (percent < 20) backlightText.icon = backlightText.icons[1]
                            else if (percent < 30) backlightText.icon = backlightText.icons[2]
                            else if (percent < 40) backlightText.icon = backlightText.icons[3]
                            else if (percent < 50) backlightText.icon = backlightText.icons[4]
                            else if (percent < 60) backlightText.icon = backlightText.icons[5]
                            else if (percent < 70) backlightText.icon = backlightText.icons[6]
                            else if (percent < 80) backlightText.icon = backlightText.icons[7]
                            else backlightText.icon = backlightText.icons[8]
                            // backlightText.text = backlightText.icon + "  " + this.text.trim().toString().padStart(3, "0")
                            backlightText.text = backlightText.icon + "  " + backlightText.brightnessLevel.toString().padStart(3, "0") + "%"
                        }
                    }
                }
                Process {
                    id: setBacklightProc
                    command: ["sh", "-c", "brightnessctl s " + backlightText.brightnessLevel + "%"]
                    running: true
                }

                FileView {
                    id: backLightWatcher
                    path: "/sys/class/backlight/intel_backlight/actual_brightness"
                    watchChanges: true
                    onFileChanged: {
                        getBacklightProc.running = true
                    }
                }
            }
        }

        Separator {
            sepText: " "
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
                    command: ["date", "+%H:%M"]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: timeText.text = this.text
                    }
                }
                Timer {
                    interval: 60000
                    running: true
                    repeat: true
                    onTriggered: timeProc.running = true
                }
            }
        }

        Separator {
            sepText: " "
            fgColor: "#2B4052"
            bgColor: "#CDCBE0"
            fontSize: 21
        }


        Rectangle {
            id: pulseaudio
            implicitWidth: speakerText.implicitWidth
            implicitHeight: 25
            color: "#2B4052"
            Text {
                id: speakerText
                topPadding: 2
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 18
                font.weight: 500
                color: "#CDCBE0"
                property list<string> icons: [" ", " ", " "]
                property string icon: " "
                property int volume: 0
                property int stepCount: 1

                MouseArea {
                    id: volumeArea
                    anchors.fill: parent
                    onWheel: (wheel) => {
                        let step = speakerText.stepCount;
                        if (wheel.angleDelta.y > 0) {
                            speakerText.volume = Math.min(speakerText.volume + step, 100);
                            setVolumeProc.running = true
                        } else {
                            speakerText.volume = Math.max(speakerText.volume - step, 0);
                            setVolumeProc.running = true
                        }
                    }
                }

                Process {
                    id: getVolumeProc
                    command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk '{ print $5 } '"]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: {
                            var percent = parseInt(speakerText.volume)
                            if (percent < 33) speakerText.icon = speakerText.icons[0]
                            else if (percent < 66) speakerText.icon = speakerText.icons[1]
                            else speakerText.icon = speakerText.icons[2]
                            speakerText.text = speakerText.icon + "  " + speakerText.volume.toString().padStart(3, "0") + "%"
                        }
                    }
                }
                Process {
                    id: setVolumeProc
                    command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ " + speakerText.volume + "%"]
                    running: true
                }

                FileView {
                    id: pulseWatcher
                    path: "/tmp/custom_pulseaudio_event"
                    watchChanges: true
                    onFileChanged: {
                        getVolumeProc.running = true
                    }
                }
            }
        }
        Separator {
            sepText: "  "
            fgColor: "#CDCBE0"
            bgColor: "#2B4052"
            fontSize: 21
        }

        Rectangle {
            implicitWidth: bat1Text.implicitWidth
            implicitHeight: 25
            color: "#2B4052"
            Text {
                id: bat1Text
                topPadding: 2
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 18
                font.weight: 500
                color: "#CDCBE0"
                property list<string> icons: [" ", " ", " ", " ", " "]
                property string icon: " "

                Process {
                    id: batteryProc
                    command: ["cat", "/sys/class/power_supply/BAT1/capacity",]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: {
                            var percent = parseInt(this.text.trim())
                            if (percent < 20) bat1Text.icon = icons[0]
                            else if (percent < 40) bat1Text.icon = bat1Text.icons[1]
                            else if (percent < 60) bat1Text.icon = bat1Text.icons[2]
                            else if (percent < 80) bat1Text.icon = bat1Text.icons[3]
                            else bat1Text.icon = bat1Text.icons[4]
                            bat1Text.text = bat1Text.icon + this.text.trim() + "%"
                        }
                    }
                }
                Timer {
                    interval: 30000
                    running: true
                    repeat: true
                    onTriggered: batteryProc.running = true
                }
            }
        }

        Separator {
            sepText: " "
            fgColor: "#569FBA"
            bgColor: "#2B4052"
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
