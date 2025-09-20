# Setup Installation Full-control Browser Google Chrome on Linux (Server/VPS)

<img width="1485" height="745" alt="image" src="https://github.com/user-attachments/assets/554b17d2-23d7-4b51-9e93-6d540f2fc502" />

> [!NOTE]
> **KasmVNC** is a modern open source VNC server. Enhanced security, higher compression, smoother encoding...
> all in a web-based client. Connect to your Linux server's desktop from any web browser. No client software install required.
> And for **XFCE** is a lightweight desktop environment for UNIX-like operating systems. It aims to be fast and low on system resources.
> For more information visit https://www.xfce.org & https://kasmweb.com/kasmvnc

> **For Comparison & List of Desktop Environments** https://eylenburg.github.io/de_comparison.htm

> **(1) By KasmVNC Workspaces only client browser**

> **(2) By Xfce Linux desktop environments (DE) GUI**

## System Requirements

![VPS](https://img.shields.io/badge/VPS_SERVER-232F3E?style=for-the-badge&logo=digitalocean&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Chrome](https://img.shields.io/badge/Chrome-34A853?style=for-the-badge&logo=google-chrome&logoColor=white)

| Component       | Minimum                |
| :----------     | :--------------------  |
| **OS**          | Ubuntu 20-24 LTS       |
| **CPU**         | Cores 2-4 vCPU         |
| **RAM/VRAM**    | Min 512MB-4GB          |
| **STORAGE**     | Up to free space       |
| **NETWORK**     | Open port for access   |

| Component             | Kasm-Chrome            | Xfce-Desktop GUI       |
| :----------           | :--------------------  | :--------------------  |
| **Access**            | KasmVNC client         | noVNC client           |
| **Support**           | Web browser            | Web browser & app/mobile |
| **Port/Firewall**     | 6901 (default)         | 8080 (custom) app/mobile |
|                       |                        | 8081 (custom) browser   |

> Note: You can setup up to you for Port/Fiewall in (custom) & for Xfce-desktop, if dont access in app/mobile skipping open port for 8080

## System Update & Essential Tools

```bash
sudo apt update && sudo apt upgrade -y \
sudo apt -qy install curl unzip git nano jq lz4 build-essential screen ufw
```

## Install Docker & Compose → <mark>if not yet</mark>

```bash
curl -sSL https://raw.githubusercontent.com/arcxteam/succinct-prover/refs/heads/main/docker.sh | sudo bash
```

## Required Firewall Port

```bash
sudo ufw allow 6901/tcp # KasmVNC
sudo ufw allow 8081/tcp # noVNC web browser
sudo ufw allow 8080/tcp # RealVNC viewer app/mobile 
sudo ufw enable
sudo ufw status verbose
```

## 1. Kasm Workspaces - Quick Install

#### Auto Install: EDIT first YOUR_PASSWORD
```bash
curl -s https://raw.githubusercontent.com/arcxteam/Chrome-Linux/refs/heads/main/Setup-Kasmweb-Chrome.sh | bash -s "YOUR_PASSWORD"
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
      - VNC_PW=YOUR_PASSWORD # Setup up to u
    ports:
      - "6901:6901"
    shm_size: 1g # Setup up to u
    restart: unless-stopped
    volumes:
      - ./downloads:/home/kasm-user/Downloads
EOF

# Start service
docker compose up -d
```

## Access by Browser

### Steps to Access:

#### Get → IP Address Server
```bash
curl ifconfig.me && echo
```

1. **Open URL** Navigate to → <mark>https://YOUR_SERVER_IP:6901</mark>
2. **Accept SSL Certificate** Click `Advanced` → `Proceed to site`
3. **Login**
   - Username: `kasm_user` → <mark>default</mark>
   - Password: `password` → <mark>your custom password</mark>
4. **Bookmark access tab**

---

## 2. Xfce Desktop GUI - Quick Install

## Manual Installation

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
      - "8080:5901"  # App/mobile access, remove not use
      - "8081:6901"  # Web access
    environment:
      - VNC_RESOLUTION=1280x720 # for the best 1920x1080
      - VNC_PW=YOUR_PASSWORD # up to u
      - ENABLE_VNC_AUDIO=true
      - ENABLE_VNC_COPY=true
      - ENABLE_VNC_PASTE=true
    volumes:
      - xfce-data:/home/headless
      - ./downloads:/home/headless/Downloads
    shm_size: 2gb # up to u
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

### In container, download google chrome:
```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
apt update
apt install -y unzip autocutsel engrampa /tmp/chrome.deb
apt install -y --fix-broken
rm /tmp/chrome.deb
```

### Create google chrome icon and relaunch
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
### Steps to Access:
#### Get → IP Address Server
```bash
curl ifconfig.me && echo
```

### 1. Access by Web browser

1. **Open URL** Navigate to → <mark>http://YOUR_SERVER_IP:8081/vnc.html</mark>
2. **You can see menu dashboard noVNC**
3. **Connect**
   - Credentials: `password` → <mark>your custom password</mark>
4. **Bookmark access tab**

### 2. Access by VNC on app/mobile

1. **Download App VNC viewer** Support like TigerVNC, RealVNC
2. **RealVNC (recommend) iOS/Android** https://www.realvnc.com/en/connect/download/viewer/
3. **Connect**
   - Address: `ip-address+port` → <mark>YOUR_SERVER_IP:8080</mark>
   - Name: `Up to you`
4. **Browsing on app/mobile**

## Management Commands

```diff
## Check Status & realtime resources
- docker ps | grep kasm-chrome
- docker ps | grep xfce-desktop
- docker stats

## View Logs
- docker logs -f kasm-chrome
- docker logs -f xfce-desktop

## Stop and Run Browser
- cd ~/kasm-chrome
- cd ~/desktop
- docker compose down
- docker compose up -d
```
