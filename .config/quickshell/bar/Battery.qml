pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string percentage
    property list<string> icons: [" ", " ", " ", " ", " "]
    property string icon: " "

    Process {
        id: batteryProc
        command: ["cat", "/sys/class/power_supply/BAT1/capacity",]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var percent = parseInt(this.text.trim())
                if (percent < 20) root.icon = root.icons[0]
                else if (percent < 40) root.icon = root.icons[1]
                else if (percent < 60) root.icon = root.icons[2]
                else if (percent < 80) root.icon = root.icons[3]
                else root.icon = root.icons[4]
                root.percentage = root.icon + this.text.trim() + "%"
            }
        }
    }
    FileView {
        id: batteryWatcher
        path: "/sys/class/power_supply/BAT1/capacity"
        watchChanges: true
        onFileChanged: {
            batteryProc.running = true
        }
    }
}
