#!/usr/bin/env bash
mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

useradd testadmin
echo -e "testadmin\ntestadmin" | passwd testadmin
usermod -aG wheel testadmin

yum install -y ansible

cp -R /vagrant/ansible_2_2/ ~/ansible
cd ~/ansible
ansible-playbook -i inventory.yml mod2_2.yml

echo "============================================"
for ip in $(hostname -I); do echo "IP адрес для подключения - $ip"; done
echo "В случае успешного подключения Вы увидите сообщение о фильтрации модулем."
echo "Пользователь vagrant находится в группе admin и может войти в любое время."
echo "Пользователь root не может заходить в выходные и праздничные дни."
echo "======="
echo "Пользователь с правами администратора - testadmin."
echo "Пароль - testadmin."
echo "Получение привелегий через sudo."
echo "============================================"