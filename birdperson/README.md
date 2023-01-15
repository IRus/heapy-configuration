# Smart Home Server

## hostname

```
hostnamectl set-hostname birdperson
```

## ssh

```
nano .ssh/authorized_keys # add key
sudo nano /etc/ssh/sshd_config # disable password login
```

## Packages

```
sudo apt install mc htop
package: docker
binary: docker compose
binary: lazydocker
binary: cloudflared
binary: argonone (fan control)
```

### lazydocker

```
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.20.0/lazydocker_0.20.0_Linux_armv7.tar.gz --output-document lazydocker.tar.gz
tar xzvf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/bin/lazydocker
rm lazydocker.tar.gz
```

### docker compose

```
wget https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-armv7
sudo mv docker-compose-linux-armv7 /usr/local/lib/docker/cli-plugins/docker-compose
chmod u+x /usr/local/lib/docker/cli-plugins/docker-compose
```

### cloudflared

```
wget https://github.com/cloudflare/cloudflared/releases/download/2022.12.1/cloudflared-linux-armhf
sudo mv cloudflared-linux-armhf /usr/bin/cloudflared
sudo chmod u+x /usr/bin/cloudflared
```

### argon

```
curl https://download.argon40.com/argon1.sh | bash
argonone-config
```

### rpi

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
