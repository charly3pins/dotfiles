# dotfiles

## instructions

I use [Stow](https://www.gnu.org/software/stow/manual/stow.html) to manage my dotfiles

## commands

### wifi

nmcli device wifi list

nmcli device wifi connect SSID --ask

### display

autorandr --load docked

autorandr --load undocked

### brightness

brightnessctl set +10%

brightnessctl set 10%-
