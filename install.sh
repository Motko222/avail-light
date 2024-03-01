#!/bin/bash

id [ ! -f ~/scripts/avail-light/conf ] 
then
   read -p "Id? " id
   echo 'export ID=$id' >~/scripts/avail-light/conf
fi

cd ~
sudo apt install make git nano clang pkg-config libssl-dev build-essential -y
echo 1 | curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update stable
rustup default stable
source ~/.cargo/env
rustc --version
git clone https://github.com/availproject/avail-light.git
cd ~/avail-light
cargo build --release

sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
[Unit]
Description=Avail Light Client
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart=/root/avail-light/target/release/avail-light --network goldberg
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable availightd

echo "Node is not running, run start."
