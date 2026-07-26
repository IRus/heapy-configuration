# sudo nano /boot/firmware/config.txt

```
[all]
dtoverlay=gpio-poweroff,gpiopin=18,active_low=0
dtoverlay=gpio-shutdown,gpio_pin=17,active_low=1,gpio_pull=up
dtoverlay=gpio-fan,gpiopin=14,temp=65000,hyst=5000
```
