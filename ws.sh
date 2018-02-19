#!/bin/bash

while getopts 'rh' OPTION ; do
    case $OPTION in
        r )
            rm /tmp/window-shortcuts.list
            cat ~/.xbindkeysrc > /tmp/window-shortcuts.tmp
            xbindkeys -f ~/.xbindkeysrc -p
            exit 0
            ;;
        h )
            echo "Usage:"
            echo "  <empty>: keybinding"
            echo "       -h: show this help"
            echo "       -r: remove shortcuts"
            exit 0
            ;;
    esac
done

num=1
declare -a windows
while read -r line ; do
    winid=$(echo $line | awk '{print $1}')
    wintitle=$(echo $line | cut -d ' ' -f 4-)
    echo "${num}: $wintitle"
    windows[$num]="$winid"
    num=$((num + 1))
done < <(wmctrl -l)
echo ''
read -p 'Select window number: ' selected
selectedid=${windows[$selected]}

echo "Input shortcut in the popped window"
binding="$(xbindkeys -k 2>/dev/null | tail -n 1)"

if [ "${binding:0:1}" == " " ]; then
    echo "\"wmctrl -i -a $selectedid\"" >> /tmp/window-shortcuts.list
    echo "$binding" >> /tmp/window-shortcuts.list
    cat ~/.xbindkeysrc > /tmp/window-shortcuts.tmp
    cat /tmp/window-shortcuts.list >> /tmp/window-shortcuts.tmp
    xbindkeys -f /tmp/window-shortcuts.tmp -p
else
    echo "abort"
fi

