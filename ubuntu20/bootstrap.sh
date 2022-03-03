#!/bin/bash
# Bootstrap machine

ensure_netplan_apply() {
    sleep 5
    netplan apply
}

resolve_dns() {
    rm /etc/resolv.conf
    ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
}

install_docker() {
    curl -fsSL https://get.docker.com | sh
    usermod -aG docker vagrant
}

configure_root_login() {
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl reload ssh
    echo "root:password" | chpasswd
}

main() {
    ensure_netplan_apply
    resolve_dns
    install_docker
    configure_root_login
}

main
