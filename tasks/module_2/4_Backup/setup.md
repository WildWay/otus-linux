1. sudo yum install -y bacula-director-mysql bacula-storage-mysql bacula-console bacula-client mariadb-server
1. sudo systemctl enable --now mariadb
1. /usr/libexec/bacula/grant_mysql_privileges  
1. /usr/libexec/bacula/create_mysql_database -u root  
1. /usr/libexec/bacula/make_mysql_tables -u bacula
1. sudo mysql_secure_installation
1. mysql -u root -p
    - UPDATE mysql.user SET Password=PASSWORD('bacula_db_password') WHERE User='bacula'; FLUSH PRIVILEGES;
    - exit
1. sudo alternatives --config libbaccats.so
1. sudo mkdir -p /bacula/backup /bacula/restore
1. sudo chown -R bacula:bacula /bacula
    - sudo chmod -R 700 /bacula
1. sudo vim /etc/bacula/bacula-dir.conf
1. 