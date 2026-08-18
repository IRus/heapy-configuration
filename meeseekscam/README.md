# Frigate Server (Kolodishchi)

## ssh

```
nano .ssh/authorized_keys # add key

# disable password login
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf > /dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin prohibit-password
PubkeyAuthentication yes
EOF

sudo sshd -t && sudo systemctl reload ssh
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
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.25.2/lazydocker_0.25.2_Linux_x86_64.tar.gz --output-document lazydocker.tar.gz
tar xzvf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/bin/lazydocker
rm lazydocker.tar.gz
```

### cloudflared

```
wget https://github.com/cloudflare/cloudflared/releases/download/2026.8.2/cloudflared-linux-amd64
sudo mv cloudflared-linux-amd64 /usr/bin/cloudflared
sudo chmod u+x /usr/bin/cloudflared
```

### docker

```
https://docs.docker.com/engine/install/debian/#install-using-the-repository
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```
