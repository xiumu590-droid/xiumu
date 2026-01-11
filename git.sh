#!/bin/bash
REPO=git@github.com:xiumu590-droid/xiumu.git
BRANCH=main
git config --global user.name "xiumu590-droid"
git config --global user.email "xiumu590@gmail.com"
git add *
git commit -m "上传 $(date +'%m%d-%H%M%S')" || echo "无变动"
git push origin "$BRANCH"