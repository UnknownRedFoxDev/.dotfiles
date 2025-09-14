import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            required property var modelData
            screen: modelData
            anchors { top: true; left: true; right: true }
            property string dimBlack: "#191726"
            property string dimWhite: "#696580"
            property string brightWhite: "#CDCBE0"
            color: dimBlack
            implicitHeight: 25

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: -1

                // ------------------------- CPU -------------------------
                ComponentText {
                    barHeight: parent.height
                    textColor: dimWhite
                    bgColor: dimBlack
                    textDisplay: CpuPercentage.loadText
                }

                Separator {
                    separator: "  "
                    fgColor: dimWhite
                    bgColor: dimBlack
                    fontSize: 21
                }

                // ------------------------- Memory -------------------------
                ComponentText {
                    barHeight: parent.height
                    textColor: dimWhite
                    bgColor: dimBlack
                    textDisplay: Memory.percentage
                }

                Separator {
                    separator: "  "
                    fgColor: "#696580"
                    bgColor: "#191726"
                    fontSize: 21
                }

                // ------------------------- Temperature -------------------------
                ComponentText {
                    barHeight: parent.height
                    textColor: dimWhite
                    bgColor: dimBlack
                    textDisplay: Temperature.degree
                }

                Separator {
                    separator: "  "
                    fgColor: "#696580"
                    bgColor: "#191726"
                    fontSize: 21
                }

                // ------------------------- Battery -------------------------
                ComponentText {
                    barHeight: parent.height
                    textColor: dimWhite
                    bgColor: dimBlack
                    textDisplay: Battery.percentage
                }

                Separator {
                    separator: " "
                    fgColor: "#CDCBE0"
                    bgColor: "#191726"
                    fontSize: 21
                }

                // ------------------------- Time (date) -------------------------
                ComponentText {
                    barHeight: parent.height
                    textColor: dimBlack
                    bgColor: brightWhite
                    textDisplay: Time.timeDate
                }

                Separator {
                    separator: "  "
                    fgColor: "#191726"
                    bgColor: "#CDCBE0"
                    fontSize: 21
                }

                // ------------------------- Time (clock) -------------------------
                ComponentText {
                    barHeight: parent.height
                    textColor: dimBlack
                    bgColor: brightWhite
                    textDisplay: Time.timeClock
                }

                Separator {
                    separator: " "
                    fgColor: "#2B4052"
                    bgColor: "#CDCBE0"
                    fontSize: 21
                }


                // ------------------------- Audio -------------------------
                Rectangle {
                    id: pulseaudio
                    implicitWidth: speakerText.implicitWidth
                    implicitHeight: 25
                    color: "#2B4052"
                    Text {
                        id: speakerText
                        font.family: "CaskaydiaCove Nerd Font"
                        font.pixelSize: 18
                        font.weight: 500
                        color: "#CDCBE0"
                        property list<string> icons: [" 🔇︎", " 🕨", " 🕩", " 🕪"]
                        property string icon: " 🔇︎"
                        property int volume: 0
                        property int stepCount: 1

                    }

                    MouseArea {
                        id: volumeArea
                        anchors.fill: parent
                        onWheel: (wheel) => {
                            let step = speakerText.stepCount;
                            if (wheel.angleDelta.y > 0) {
                                speakerText.volume = Math.min(speakerText.volume + step, 100);
                            } else {
                                speakerText.volume = Math.max(speakerText.volume - step, 0);
                            }
                            setVolumeProc.running = true
                        }
                        onClicked: {
                            openParuControl.running = true
                        }
                    }

                    Process {
                        id: openParuControl
                        command: ["pavucontrol"]
                        running: false
                    }

                    Process {
                        command: ["sh", "-c", "scripts/audio.sh &"]
                        running: true
                    }

                    Process {
                        id: getVolumeProc
                        command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk '{ print $5 } '"]
                        running: true
                        stdout: StdioCollector {
                            onStreamFinished: {
                                var percent = parseInt(this.text)
                                if (percent == 0) speakerText.icon = speakerText.icons[0]
                                else if (percent < 25) speakerText.icon = speakerText.icons[1]
                                else if (percent < 50) speakerText.icon = speakerText.icons[2]
                                else speakerText.icon = speakerText.icons[3]
                                speakerText.volume = parseInt(this.text)
                                speakerText.text = speakerText.icon + " " + this.text.trim().toString().padStart(4, "0")
                            }
                        }
                    }
                    Process {
                        id: setVolumeProc
                        command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ " + speakerText.volume + "%"]
                        running: false
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

                Separator {
                    separator: "  "
                    fgColor: "#CDCBE0"
                    bgColor: "#2B4052"
                    fontSize: 21
                }

                // ------------------------- Backlight -------------------------
                Rectangle {
                    implicitWidth: backlightText.implicitWidth
                    implicitHeight: 25
                    color: "#2B4052"
                    Text {
                        id: backlightText
                        topPadding: 2
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 18
                        font.weight: 500
                        color: "#CDCBE0"
                        property list<string> icons: ["", "", "", "", "", "", "", "", ""]
                        property string icon: " "
                        property int brightnessLevel: Math.floor(getCurrentBrightness.brightness * 100 / getMaxBrightness.brightness)
                        property int stepCount: 1

                    }


                    FileView {
                        id: getCurrentBrightness
                        path: "/sys/class/backlight/intel_backlight/actual_brightness"
                        property int brightness: parseInt(data());

                        watchChanges: true
                        onFileChanged: brightness = parseInt(data());
                    }
                    FileView {
                        id: getMaxBrightness
                        path: "/sys/class/backlight/intel_backlight/max_brightness"
                        property int brightness: parseInt(data());
                    }

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
                        command: ["sh", "-c", "brightnessctl g | grep '%' | awk '{ print $4 }'"]
                        running: true
                        stdout: StdioCollector {
                            onStreamFinished: {
                                if (backlightText.brightnessLevel < 10) backlightText.icon = backlightText.icons[0]
                                else if (backlightText.brightnessLevel < 20) backlightText.icon = backlightText.icons[1]
                                else if (backlightText.brightnessLevel < 30) backlightText.icon = backlightText.icons[2]
                                else if (backlightText.brightnessLevel < 40) backlightText.icon = backlightText.icons[3]
                                else if (backlightText.brightnessLevel < 50) backlightText.icon = backlightText.icons[4]
                                else if (backlightText.brightnessLevel < 60) backlightText.icon = backlightText.icons[5]
                                else if (backlightText.brightnessLevel < 70) backlightText.icon = backlightText.icons[6]
                                else if (backlightText.brightnessLevel < 80) backlightText.icon = backlightText.icons[7]
                                else backlightText.icon = backlightText.icons[8]
                                backlightText.text = backlightText.icon + " " + backlightText.brightnessLevel.toString().padStart(3, "0") + "%"
                            }
                        }
                    }
                    Process {
                        id: setBacklightProc
                        command: ["sh", "-c", "brightnessctl s " + backlightText.brightnessLevel + "%"]
                        running: false
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

                Separator {
                    separator: " "
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

            // ------------------------- LEFT COLUMN -------------------------
            // , 

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: -1

                Separator {
                    separator: " "
                    fgColor: "#569FBA"
                    bgColor: "#191726"
                    fontSize: 21
                }
            }
        }
    }
}
