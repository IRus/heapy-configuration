### imager setup

- disable wifi
- set user password
- create a new ssh key
- add the ssh key to imager
- update ssh config

## Packages

```
sudo apt install nano mc git htop
binary: lazydocker
binary: cloudflared
repo: docker
```

### lazydocker

```
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.24.1/lazydocker_0.24.1_Linux_arm64.tar.gz --output-document lazydocker.tar.gz
tar xzvf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/bin/lazydocker
rm lazydocker.tar.gz
```

### cloudflared

```
wget https://github.com/cloudflare/cloudflared/releases/download/2025.8.1/cloudflared-linux-arm64
sudo mv cloudflared-linux-arm64 /usr/bin/cloudflared
sudo chmod u+x /usr/bin/cloudflared
```

### docker

```
https://docs.docker.com/engine/install/debian/#install-using-the-repository
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

## Setup fan control

```
sudo nano /boot/firmware/config.txt

[all]
dtoverlay=gpio-fan,gpiopin=14,temp=65000,hyst=5000
```