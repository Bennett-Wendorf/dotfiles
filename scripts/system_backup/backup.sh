#!/bin/bash

proxmox-backup-client backup root.pxar:/ --exclude=/home/bennett/files --exclude=/home/bennett/.cache --exclude=/swapfile --repository 'bwarch@pbs!bwarchtoken@10.66.1.25:local' --ns misc

