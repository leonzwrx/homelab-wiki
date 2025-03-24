```sh
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

# OpenRGB & ckb-next - Debian Bookworm

_UPDATED JULY 2024_

_This guide shows how to install and configure my instance of OpenRGB to control RGB-enabled peripherals connected to ASUS motherboard as well as ckb-next application to control RGB on Corsair mouse/keyboard_
 
***
- General install guide: https://gitlab.com/CalcProgrammer1/OpenRGB#linux
- Youtube tutorial: [![IMAGE_ALT](https://img.youtube.com/vi/uJofwpZl6y4/0.jpg)](https://www.youtube.com/watch?v=uJofwpZl6y4)
***
### General Steps for OPEN RGP on ASUS Motherboard (Intel):
- Create a Timeshift snapshot
```bash
sudo apt install openrgb_0.9_amd64_bookworm_b5f46e3.deb  #install deb
sudo apt install i2c-tools #install i2c tools
sudo modprobe i2c-dev #load intel kernel module
```

- Verify modules are loaded, if not load them manually using modprobe. The .deb package should install the udev rules automatically, which is needed to detect certain devices and run things without root
```bash
lsmod | grep i2c
i2c_algo_bit           12288  2 amdgpu,nouveau
i2c_dev                28672  0
i2c_i801               36864  0
i2c_smbus              16384  1 i2c_i801
```
- If you get a warning that i2c-i801 module isn't loaded, load them manually
- Run OpenRGB and it should ask to configure resizable zones sinze OpenRGB isn't smart enough to know the number of LEDs in each individual elements (for now I just set zone 1 to 50 LEDs)
- Set appropriate profile settings and save
	+ Download the install OpenRGB Effects Plugin from https://openrgb.org/plugins.html
- Verify all settings work correctly, setup, configure profiles, then set up autostart via sway or another startup method (I could not get systemd service to work on startup):
	```
	  /usr/bin/openrgb --server -p ASUS_only --config /home/leo/.config/OpenRGB
	```

### General Steps for ckb-next
- Install ckb-next application 
```bash
sudo apt install ckb-next
```
- Verify `ckb-next-daemon.service` starts and GUI comes online
- Verify `ckb-next.config` dotfile has correct configuration - otherwise, configure keyboard, mouse animation and hardware settings manually
- In order for ckb-next GUI to run, the `ckb-next-daemon.service` needs to always run
- Set up autostart via sway or another startup method but use -b flat to run silently in the systray
```bash
/usr/bin/ckb-next -b
```
