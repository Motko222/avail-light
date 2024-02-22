#!/bin/bash
 
sudo systemctl restart availightd

echo "Service started (CTRL-C to close logs)"
sudo journalctl -u availightd.service -f --no-hostname -o cat
