#!/bin/bash

# Install Google Chrome
if ! command -v google-chrome &> /dev/null; then
    echo "Installing Google Chrome..."
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    apt update
    apt install -y /tmp/chrome.deb
    apt install -y --fix-broken
    rm /tmp/chrome.deb
    echo "Chrome installed successfully!"
else
    echo "Chrome already installed!"
fi

# Fix permissions and update desktop database
chmod +x /home/headless/Desktop/google-chrome.desktop
update-desktop-database /home/headless/Desktop/
update-desktop-database /usr/share/applications/
