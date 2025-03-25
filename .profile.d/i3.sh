#!/bin/bash

if [ "${XDG_CURRENT_DESKTOP}" == "i3" ]; then
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    export QT_SCREEN_SCALE_FACTORS=2 
    # export GDK_SCALE=2
    # export GDK_DPI_SCALE=0.5
    # Set theme (GTK4 Workaround)
    export GTK_THEME=WhiteSur-Dark-solid-blue-nord #Flat-Remix-GTK-Blue-Dark-Solid
fi
