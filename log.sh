#!/bin/bash

sudo journalctl -u availightd -f --no-hostname -o cat
