# NAME USER    NICE SYSTEM IDLE     IOWAIT IRQ    SOFTIRQ
# cpu  1689014 2482 905411 30337964 103660 215572 84366   0 0 0
#
# user: Time spent running user processes (not niced).
# nice: Time spent running niced (low priority) user processes.
# system: Time spent running kernel processes.
# idle: Time spent idle.
# iowait: Time waiting for I/O to complete.
# irq: Time servicing interrupts.
# softirq: Time servicing softirqs.
# steal: Time stolen by virtual CPUs.
# guest: Time running a virtual CPU for guest OS.
# guest_nice: Time running a niced guest virtual CPU.

# awk '/^MemTotal/ { total=$2 } /^MemAvailable/ { avail=$2 } END { printf \"%.d%%\", 100 * (total - avail) / total }' /proc/meminfo

/^cpu / {
    user = $2;
    nice = $3;
    systemtime = $4;
    idle = $5;
    iowait = $6;
    irq = $7;
    softirq = $8;
    total = (user + nice + systemtime + idle + iowait + irq + softirq);
    idleTime = (idle + iowait);
    printf "%d %d\n", total, idleTime
}

