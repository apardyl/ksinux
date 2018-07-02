#!/bin/sh

panic () {
    echo "ERROR!!!"
    echo "Dropping to shell"
    setsid cttyhack sh
}

die () {
    echo "Power off in 5s"
    sleep 5
    # Kill power
    echo o > /proc/sysrq-trigger
}
