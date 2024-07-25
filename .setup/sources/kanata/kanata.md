# Kanata - Improve keyboard comfort and usability with advanced customization

source: https://github.com/jtroo/kanata


## How to install

Move plist file
```sh
sudo mv ./com.kanata.daemon.plist /Library/LaunchDaemons/
sudo chmod root:wheel /Library/LaunchDaemons/com.kanata.daemon.plist
```

Register daemon in MacOS
```sh
sudo launchctl bootstrap system /Library/LaunchDaemons/com.kanata.daemon.plist
sudo launchctl enable system/com.kanata.daemon
sudo reboot
```

## How to uninstall
```sh
sudo launchctl bootout system /Library/LaunchDaemons/com.kanata.daemon.plist
sudo launchctl disable system/com.kanata.daemon
sudo reboot
```
