#!/bin/bash
SSH_wenjian=(
cd $HOME/.ssh
cat > id_ed25519 << 'EOF'
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBma5oVEaDqAZzJlvMM8Ymuw+Cy4UhD5BQHaOeR3GW9IAAAAJhofm4BaH5u
AQAAAAtzc2gtZWQyNTUxOQAAACBma5oVEaDqAZzJlvMM8Ymuw+Cy4UhD5BQHaOeR3GW9IA
AAAEAjEar+N+nLX7T4L8TAp7C+wLSY+1503rR3Z2QTEAgE1mZrmhURoOoBnMmW8wzxia7D
4LLhSEPkFAdo55HcZb0gAAAAEmdpdEB4aXVtdS5nZ2ZmLm5ldAECAw==
-----END OPENSSH PRIVATE KEY-----

EOF

cat > id_ed25519.pub << 'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZrmhURoOoBnMmW8wzxia7D4LLhSEPkFAdo55HcZb0g git@xiumu.ggff.net

EOF

cat > known_hosts << 'EOF'
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=

EOF

cat > known_hosts.old << 'EOF'
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl

EOF
)


SSH_DIR="$HOME/.ssh"

if [[ -d $SSH_DIR ]]; then
    echo ".ssh 目录已存在，继续执行..."
    chmod -R 700 "$SSH_DIR"
    $SSH_wenjian
else
    echo ".ssh 目录不存在，正在创建..."
    mkdir -p "$SSH_DIR"
    chmod -R 700 "$SSH_DIR"
    echo ".ssh 目录已创建并设置权限 700"
    $SSH_wenjian
fi

# ===== 下面放你自己的后续命令 =====
# 例如生成密钥、拷贝文件等

mv cs $HOME/ && cd $HOME/ && chmod -R 777 cs
mv ad /data/data/com.termux/files/usr/bin && cd /data/data/com.termux/files/usr/bin chmod -R 777 ad