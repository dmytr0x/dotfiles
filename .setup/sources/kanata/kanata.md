# Kanata - Improve keyboard comfort and usability with advanced customization

source: https://github.com/jtroo/kanata

INFO: You may forcefully exit kanata by pressing lctl+spc+esc at any time

## How to install

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
