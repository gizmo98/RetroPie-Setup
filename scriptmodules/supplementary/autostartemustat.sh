rp_module_id="autostartemustat"
rp_module_desc="Auto-start EmulationStation"
rp_module_menus="3+"

function configure_autostartemustat() {
    cmd=(dialog --backtitle "$__backtitle" --menu "Choose the desired boot behaviour." 22 76 16)
    options=(1 "Original boot behaviour"
             2 "Start Emulation Station at boot.")
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [ "$choices" != "" ]; then
        case $choices in
            1) rm 
               dialog --backtitle "$__backtitle" --msgbox "Enabled original boot behaviour. ATTENTION: If you still have the custom splash screen enabled (via this script), you need to jump between consoles after booting via Ctrl+Alt+F2 and Ctrl+Alt+F1 to see the login prompt. You can restore the original boot behavior of the RPi by disabling the custom splash screen with this script." 22 76
                            ;;
            2) cat >> /etc/xdg/autostart/emulationstation.desktop << _EOF_
[Desktop Entry]
Name=Emulationstation
Comment=Start Emulationstation
Exec=/usr/bin/emulationstation
Terminal=false
Type=Application
NoDisplay=false
OnlyShowIn=LXDE;OPENBOX;GNOME;
AutostartCondition=GNOME3 unless-session gnome
_EOF_
               dialog --backtitle "$__backtitle" --msgbox "Emulation Station is now starting on boot." 22 76
                            ;;
        esac
    else
        break
    fi
}