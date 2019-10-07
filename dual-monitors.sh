#!/bin/sh

# https://wiki.archlinux.org/index.php/HiDPI#Side_display

# xrandr --output eDP-1 --auto --output HDMI-1 --auto --panning \
#         [C*E]x[D*F]+[A]+0 --scale [E]x[F] --right-of eDP-1
# AxB = laptop monitor, CxD = external monitor, ExF = scale, usually 2x2

A=3840
B=2160
C=1280 # 1680 #  1920
D=720 #  1200
E=$(echo "scale=2;$A / $C" | bc)
F=$(echo "scale=2;$B / $D" | bc)
P1=$(echo "$C * $E" | bc | xargs printf "%d")
P2=$(echo "$D * $F" | bc | xargs printf "%d")

echo "Using scale: $E x $F"
echo "Using p1: $P1 and p2: $P2"

xrandr --output eDP-1 --auto --output HDMI-1 --auto --panning "$P1"x"$P2"+3840+0 \
       --scale ${E}x${F} --right-of eDP-1
