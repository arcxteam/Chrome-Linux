# Setup Full-Control a Browser Google Chrome on Linux (VPS Server) with KasmVNC Workspaces

> [!NOTE]
> KasmVNC is a modern open source VNC server. Enhanced security, higher compression, smoother encoding...
> all in a web-based client. Connect to your Linux server's desktop from any web browser. No client software install required.
> For more information features https://kasmweb.com/kasmvnc

## System Requirements

![VPS](https://img.shields.io/badge/VPS_SERVER-232F3E?style=for-the-badge&logo=digitalocean&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Chrome](https://img.shields.io/badge/Chrome-34A853?style=for-the-badge&logo=google-chrome&logoColor=yellow)

- **OS**: Ubuntu 20→24 LTS or Debian 10+
- **RAM**: Minimum 1→2GB (good 4GB+)
- **CPU**: 2→4+ cores
- **Storage**: 2→5GB free space
- **Network**: Open port 6901 (access web browser)

## System Update & Essential Tools

```bash
sudo apt update && sudo apt upgrade -y \
sudo apt -qy install curl git nano jq lz4 build-essential screen ufw
```

## Install Docker & Docker Compose → "<mark>if not yet</mark>"

```bash
curl -sSL https://raw.githubusercontent.com/arcxteam/succinct-prover/refs/heads/main/docker.sh | sudo bash
```

## Required Firewall Port

```bash
sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 6901/tcp
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

If you prefer to run manually:

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
      - VNC_PW=your_password
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

```

✔ Chrome browser is running!

🌐 Access your browser at:
   https://YOUR_SERVER_IP:6901

🔐 Login credentials:
   User: kasm_user
   Password: your_password
```

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
