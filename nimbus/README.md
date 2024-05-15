# Smart Home Server

## hostname

```
hostnamectl set-hostname nimbus
sudo nano /etc/hosts (old name -> new name)
```

## ssh

```
nano .ssh/authorized_keys # add key
sudo nano /etc/ssh/sshd_config # disable password login
```

## Packages

```
sudo apt install mc htop jq
repo: docker
binary: lazydocker
binary: cloudflared
binary: argonone (fan control)
binary: rclone
```

### lazydocker

```
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.23.1/lazydocker_0.23.1_Linux_arm64.tar.gz --output-document lazydocker.tar.gz
tar xzvf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/bin/lazydocker
rm lazydocker.tar.gz
```

### cloudflared

```
wget https://github.com/cloudflare/cloudflared/releases/download/2024.4.1/cloudflared-linux-arm64 --output-document cloudflared
sudo mv cloudflared /usr/bin/cloudflared
sudo chmod u+x /usr/bin/cloudflared
```

### argon

```
curl https://download.argon40.com/argon1.sh | bash
argonone-config
```

### rclone

```
wget https://downloads.rclone.org/v1.66.0/rclone-v1.66.0-linux-arm64.zip --output-document rclone.zip
unzip -j rclone.zip rclone-v1.66.0-linux-arm64/rclone
sudo mv rclone /usr/bin/rclone
rclone selfupdate
```

## rpi config

```
sudo raspi-config
```

## rpi update

```
sudo rpi-update
sudo rpi-eeprom-update -a
```

## Services

```
mkdir -p ./home_assistant ./zigbee2mqtt ./mosquitto/config ./mosquitto/log ./mosquitto/data
docker compose up -d
```
