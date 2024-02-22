#!/bin/bash
 
sudo systemctl restart availightd
sudo journalctl -u availightd.service -f --no-hostname -o cat
