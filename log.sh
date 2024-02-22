#!/bin/bash

sudo journalctl -u availightd.service -f --no-hostname -o cat
