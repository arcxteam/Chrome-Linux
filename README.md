# Setup Installation Full-control Browser Google Chrome on Linux (Server/VPS)

## By KasmVNC Workspaces only client browser
## By Xfce Linux desktop environments (DE) GUI

<img width="1485" height="745" alt="image" src="https://github.com/user-attachments/assets/554b17d2-23d7-4b51-9e93-6d540f2fc502" />

> [!NOTE]
> KasmVNC is a modern open source VNC server. Enhanced security, higher compression, smoother encoding...
> all in a web-based client. Connect to your Linux server's desktop from any web browser. No client software install required.
> For more information https://kasmweb.com/kasmvnc
> Xfce is a lightweight desktop environment for UNIX-like operating systems. It aims to be fast and low on system resources
> For more information https://www.xfce.org

### For Comparison & List of Desktop Environments, https://eylenburg.github.io/de_comparison.htm

## System Requirements

![VPS](https://img.shields.io/badge/VPS_SERVER-232F3E?style=for-the-badge&logo=digitalocean&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Chrome](https://img.shields.io/badge/Chrome-34A853?style=for-the-badge&logo=google-chrome&logoColor=yellow)

- **OS**: Ubuntu 20 → 24 LTS or Debian 10+
- **RAM/vRAM**: Minimum 1GB → 2GB (good 4GB+)
- **CPU**: 2 → 4+ cores
- **Storage**: Up to free space
- **Network**: Open port 6901 (KasmVNC - access web browser)
- **Network**: Open port 8081 (noVNC - access web browser)
- **Network**: Open port 8080 (noVNC - access apps/mobile)

## System Update & Essential Tools

```bash
sudo apt update && sudo apt upgrade -y \
sudo apt -qy install curl git nano jq lz4 build-essential screen ufw
```

## Install Docker & Compose → <mark>if not yet</mark>

```bash
curl -sSL https://raw.githubusercontent.com/arcxteam/succinct-prover/refs/heads/main/docker.sh | sudo bash
```

## Required Firewall Port

```bash
sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 6901/tcp # KasmVNC
sudo ufw allow 8081/tcp # noVNC
sudo ufw enable
sudo ufw status verbose
```

## Quick Install

### Method 1: EDIT first YOUR_PASSWORD
```bash
curl -s https://raw.githubusercontent.com/arcxteam/Chrome-Linux/refs/heads/main/Setup-Kasmweb-Chrome.sh | bash -s "YOUR_PASSWORD"
```

### Method 2: EDIT first YOUR_PASSWORD
```bash
export KASM_PASSWORD="YOUR_PASSWORD"
curl -s https://raw.githubusercontent.com/arcxteam/Chrome-Linux/refs/heads/main/Setup-Kasmweb-Chrome.sh | bash
```

## Manual Installation

If you prefer to run manually, edit your password <mark>VNC_PW=YOUR_PASSWORD</mark>

```bash
# Create directory
mkdir -p ~/kasm-chrome
cd ~/kasm-chrome

# Create docker-compose.yml
cat > docker-compose.yml << EOF
services:
  chrome:
    image: kasmweb/chrome:1.17.0
    container_name: kasm-chrome
    environment:
      - VNC_PW=YOUR_PASSWORD
    ports:
      - "6901:6901"
    shm_size: 2g # can setup
    restart: unless-stopped
    volumes:
      - ./downloads:/home/kasm-user/Downloads
EOF

# Start service
docker compose up -d
```

## Access Your Browser

After installation completes, you'll see output like:

### Steps to Access:

#### Get → IP Address Server
```bash
curl ifconfig.me && echo
```

1. **Open URL**: Navigate to → <mark>https://YOUR_SERVER_IP:6901</mark>
2. **Accept SSL Certificate**: Click `Advanced` → `Proceed to site`
3. **Login**: 
   - Username: `kasm_user` → <mark>default</mark>
   - Password: `password` → <mark>your custom password</mark>
4. **Bookmark your tab**

---

## Install Desktop Linux GUI

#### Many methode use Linux desktop environments like modern-UI KDE Plasma, Kasm-Workspaces, Cinnamon, GNOME etc.. why I choose Xfce is a lightweight desktop environment for UNIX-like operating systems. It aims to be fast and low on system resources.

If you prefer to run manually, edit your password <mark>VNC_PW=YOUR_PASSWORD</mark>

```bash
# Create directory
mkdir -p ~/desktop
cd ~/desktop

# Create docker-compose.yml
cat > docker-compose.yml << EOF
services:
  xfce-desktop:
    image: accetto/ubuntu-vnc-xfce:latest
    container_name: xfce-desktop
    restart: unless-stopped
    ports:
      - "8080:5901"  # VNC access
      - "8081:6901"  # Web access
    environment:
      - VNC_RESOLUTION=1280x720 # For the best 1920x1080
      - VNC_PW=YOUR_PASSWORD
      - ENABLE_VNC_AUDIO=true
      - ENABLE_VNC_COPY=true
      - ENABLE_VNC_PASTE=true
    volumes:
      - xfce-data:/home/headless
      - ./downloads:/home/headless/Downloads
    shm_size: 2gb
    networks:
      - desktop-network

volumes:
  xfce-data:
    driver: local

networks:
  desktop-network:
    driver: bridge
EOF

# Start service
docker compose up -d
```

### Open container docker
```bash
docker exec -it xfce-desktop bash
```

### In container, download full control chrome:
```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
apt update
apt install -y /tmp/chrome.deb
apt install -y --fix-broken
rm /tmp/chrome.deb
```

### Create google chrome icon and relaunch desktop entry
```bash
cat > ~/Desktop/google-chrome.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Google Chrome
Comment=Access the Internet
Exec=google-chrome --no-sandbox --disable-dev-shm-usage --disable-gpu --test-type
Icon=google-chrome
Categories=Network;WebBrowser;
Terminal=false
EOF
```

### Update & Permission
```
chmod +x ~/Desktop/google-chrome.desktop &&
update-desktop-database
```

### Test Chrome version & exit container
```bash
google-chrome --version &&
exit
```

### Get → IP Address Server
```bash
curl ifconfig.me && echo
```

### 1. Access by Web browser

1. **Open URL**: Navigate to → <mark>http://YOUR_SERVER_IP:8081/vnc.html</mark>
2. **You can see menu dashboard noVNC**
3. **Connect**:
   - Password: `password` → <mark>your custom password</mark>
4. **Bookmark your tab**

### 2. Access by VNC on mobile

1. **Download App VNC viewer support like TigerVNC, Anydesk, TeamViewer or RealVNC**
2. I use RealVNC (recommend) https://www.realvnc.com/en/connect/download/viewer/
3. **Connect**:
   - Address: `ip-address+port` → <mark>YOUR_SERVER_IP:8080</mark>
   - Name: `Anymore you typing`
4. **Browing on your mobile**

## Management Commands

```diff
## Check Status
- docker ps | grep kasm-chrome

## View Logs
- docker logs -f kasm-chrome

## Stop and Run Browser
- cd ~/kasm-chrome
- docker compose down
- docker compose up -d

## View realtime resources
- docker stats
```
