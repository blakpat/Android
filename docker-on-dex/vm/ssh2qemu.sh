#!/data/data/com.termux/files/usr/bin/bash
ssh -i qemukey -o StrictHostKeyChecking=no -p 2222 root@localhost "$@"
