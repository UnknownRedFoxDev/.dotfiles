pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string loadText
    property string icon: " "

    Process {
        id: cpuProc
        command: ["sh", "-c", "~/.config/quickshell/bar/scripts/cpu.sh"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.loadText = root.icon + this.text.trim() + "%"
            }
        }
    }
    Timer {
        interval: 9000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }
}
