#!/bin/sh

# https://wiki.archlinux.org/index.php/HiDPI#Side_display

# xrandr --output eDP-1 --auto --output HDMI-1 --auto --panning \
#         [C*E]x[D*F]+[A]+0 --scale [E]x[F] --right-of eDP-1
# AxB = laptop monitor, CxD = external monitor, ExF = scale, usually 2x2

A=3840
B=2160
C=0
D=0
E=2
F=2

xrandr --output eDP-1 --auto --output HDMI-1 --auto --panning 3840x2400+3840+0 \
       --scale ${E}x${F} --right-of eDP-1
