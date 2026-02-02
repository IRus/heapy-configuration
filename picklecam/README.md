# Smart Home Server

## ssh

```
nano .ssh/authorized_keys # add key
sudo nano /etc/ssh/sshd_config # disable password login
```

## Packages

```
sudo apt install nano mc git htop
repo: docker
binary: lazydocker
binary: cloudflared
```

### lazydocker

```
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.24.4/lazydocker_0.24.4_Linux_x86_64.tar.gz --output-document lazydocker.tar.gz
tar xzvf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/bin/lazydocker
rm lazydocker.tar.gz
```

### cloudflared

```
wget https://github.com/cloudflare/cloudflared/releases/download/2024.4.1/cloudflared-linux-amd64
sudo mv cloudflared-linux-amd64 /usr/bin/cloudflared
sudo chmod u+x /usr/bin/cloudflared
```

### docker

```
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```