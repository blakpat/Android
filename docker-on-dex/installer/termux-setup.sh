#!/data/data/com.termux/files/usr/bin/bash
set -e

export REPO_URL=https://github.com/blakpat/Android.git
export BRANCH=main

pkg update -y
pkg install -y git

git clone "${REPO_URL}" ~/docker-android
cd ~/docker-android
git checkout "${BRANCH}"

cd docker-on-dex && ./setup.sh
