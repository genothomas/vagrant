#!/bin/bash
# Bootstrap machine

install_docker() {
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker.service
    systemctl enable --now containerd.service
    usermod -aG docker vagrant
}

install_pip_ansible() {
    curl -sSL https://bootstrap.pypa.io/pip/2.7/get-pip.py | python
    pip install ansible
}

configure_root_login() {
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl reload sshd
    echo "root:password" | chpasswd
}

pkg_install() {
    yum install -y epel-release
}

main() {
    install_docker
    install_pip_ansible
    configure_root_login
    pkg_install

}

main
