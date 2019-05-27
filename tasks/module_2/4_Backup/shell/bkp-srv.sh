#!/usr/bin/env bash
mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

yum install -y bacula-director-mysql bacula-storage-mysql bacula-console mariadb-server
systemctl enable --now mariadb

/usr/libexec/bacula/grant_mysql_privileges
/usr/libexec/bacula/create_mysql_database -u root
/usr/libexec/bacula/make_mysql_tables -u bacula

# Установить пароль пользователя Bacula
mysql -e "UPDATE mysql.user SET Password=PASSWORD('bacula_db_password') WHERE User='bacula';"
# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('123qwe4r5t') WHERE User = 'root'"
# Disallow remote login for root
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
mysql -e "DROP DATABASE test"
# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"
# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param

# Установить mysql в качестве БД
echo 1 | alternatives --config libbaccats.so

mkdir -p /bacula/backup /bacula/restore
chown -R bacula:bacula /bacula
chmod -R 700 /bacula

/bin/cp -f /vagrant/{bacula-dir.conf,bacula-sd.conf,bconsole.conf} /etc/bacula/

#bacula-dir -tc /etc/bacula/bacula-dir.conf
#echo $? # if 0 = OK, if !0 = Failure

#bacula-dir -tc /etc/bacula/bacula-sd.conf
#echo $? # if 0 = OK, if !0 = Failure

systemctl enable --now {bacula-dir,bacula-sd}


yum install -y httpd yum-utils wget
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php55
yum install -y php php-gd php-gettext php-mysql php-pdo php-posix

#cd /var/www/html
wget http://www.bacula-web.org/files/bacula-web.org/downloads/bacula-web-latest.tgz
tar -xzf bacula-web-latest.tgz -C /var/www/html/
/bin/cp -f /vagrant/config.php /var/www/html/bacula-web/application/config/
/bin/cp -f /vagrant/application.db /var/www/html/bacula-web/application/assets/protected/
chown -R apache: /var/www/html/bacula-web
chcon -R -t httpd_sys_rw_content_t /var/www/html/bacula-web/application/views/cache
cp /vagrant/bacula-web.conf /etc/httpd/conf.d/
systemctl enable --now httpd

echo "============================================"
echo "Имя хоста - `hostname`"
echo "IP адрес для подключения - `hostname -I | cut -d ' ' -f 2`"
echo "============================================"