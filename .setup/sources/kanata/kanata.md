# Kanata - Improve keyboard comfort and usability with advanced customization

source: https://github.com/jtroo/kanata

INFO: You may forcefully exit kanata by pressing lctl+spc+esc at any time

## How to install

```sh
# install Karabiner Virtual HID Device Manager for kanata version 1.6.1:
https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/blob/main/dist/Karabiner-DriverKit-VirtualHIDDevice-3.1.0.pkg

# activate
/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
```

Move plist file

```sh
sudo mv ./com.kanata.daemon.plist /Library/LaunchDaemons/
sudo chmod root:wheel /Library/LaunchDaemons/com.kanata.daemon.plist
```

Register daemon in MacOS
Open Settings / Privacy & Security / Input Monitoring
Add and enable item /opt/kanata/kanata

```sh
sudo launchctl load -w /Library/LaunchDaemons/com.kanata.daemon.plist
sudo launchctl kickstart system/com.kanata.daemon
	# after that, the state will be: spawn scheduled
sudo reboot
```

## How to uninstall

```sh
sudo launchctl unload -w /Library/LaunchDaemons/com.kanata.daemon.plist
sudo reboot
```
