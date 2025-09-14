pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string degree
    property list<string> icons: [" ", " "]
    property string icon: " "

    Process {
        id: temperatureProc
        command: ["cat", "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var percent = parseInt(this.text.trim())
                if (percent < 40) root.icon = root.icons[0]
                else if (percent < 70) root.icon = root.icons[1]
                root.degree = root.icon + this.text.trim() / 1000 + "°C"
            }
        }
    }
    FileView {
        id: temperatureWatcher
        path: "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input"
        watchChanges: true
        onFileChanged: {
            temperatureProc.running = true
        }
    }
}
