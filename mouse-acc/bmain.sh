#!/bin/bash
# set_mouse_speed.sh

# Set your desired speed here (-1.0 to 1.0)
SPEED=0.7

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # Wayland (GNOME)
    gsettings set org.gnome.desktop.peripherals.mouse speed $SPEED
    echo "Mouse speed set to $SPEED (Wayland)"
    
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    # X11
    MOUSE_ID=$(xinput list | grep -i "mouse\|pointer" | grep -v "Virtual" | head -1 | grep -o 'id=[0-9]*' | cut -d= -f2)
    xinput set-prop $MOUSE_ID "libinput Accel Speed" $SPEED
    echo "Mouse speed set to $SPEED (X11)"
    
else
    echo "Unknown session type"
    exit 1
fi
