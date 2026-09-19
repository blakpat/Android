#!/data/data/com.termux/files/usr/bin/bash
echo "Apagando limpiamente la máquina virtual Docker..."
ssh -i /data/data/com.termux/files/home/alpine/qemukey -o StrictHostKeyChecking=no -o ConnectTimeout=5 -p 2222 root@localhost 'poweroff' 2>/dev/null
sleep 3
tmux kill-session -t docker-vm 2>/dev/null
echo "Docker VM apagada."
