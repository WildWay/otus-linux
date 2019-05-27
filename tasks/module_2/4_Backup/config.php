<?php

// Show inactive clients (false by default)
$config['show_inactive_clients'] = true;

// Hide empty pools (displayed by default)
$config['hide_empty_pools'] = false;

// Custom datetime format (by default: Y-m-d H:i:s)
// Examples 
// $config['datetime_format'] = 'd/m/Y H:i:s';
// $config['datetime_format'] = 'm-d-Y H:i:s';

// Security
$config['enable_users_auth'] = true;

// Debug mode 
$config['debug'] = false;

// Translations
$config['language'] = 'en_US';

// en_US -> English 
// be_BY -> Belarusian
// ca_ES -> Catalan
// pl_PL -> Polish
// ru_RU -> Russian
// zh_CN -> Chinese
// no_NO -> Norwegian
// ja_JP -> Japanese
// sv_SE -> Swedish
// es_ES -> Spanish
// de_DE -> German
// it_IT -> Italian
// fr_FR -> French
// pt_BR -> Portuguese Brazil
// nl_NL -> Dutch

// Database connection parameters
// Copy/paste and adjust parameters according to your configuration

// For Unix socket connection, use parameters decribed below
// MySQL: use localhost for $config[0]['host']
// postgreSQL: do not define $config[0]['host']

// MySQL bacula catalog
$config[0]['label'] = 'Backup Server';
$config[0]['host'] = 'localhost';
$config[0]['login'] = 'bacula';
$config[0]['password'] = 'bacula_db_password';
$config[0]['db_name'] = 'bacula';
$config[0]['db_type'] = 'mysql';
$config[0]['db_port'] = '3306';

// postgreSQL bacula catalog
// $config[0]['label'] = 'Prod Server';
// $config[0]['host'] = 'db-server.domain.com';
// $config[0]['login'] = 'bacula';
// $config[0]['password'] = 'otherstrongpassword';
// $config[0]['db_name'] = 'bacula';
// $config[0]['db_type'] = 'pgsql';
// $config[0]['db_port'] = '5432'; 

// SQLite bacula catalog
// $config[0]['label'] = 'Dev backup server';
// $config[0]['db_type'] = 'sqlite';
// $config[0]['db_name'] = '/path/to/database/db.sdb';
// Copy the section below only if you have at least two Bacula catalog
// Don't forget to modify options such as label, host, login, password, etc.

// 2nd bacula catalog (MySQL)
// $config[1]['label'] = 'Dev backup server';
// $config[1]['host'] = 'mysql-server.domain.net';
// $config[1]['login'] = 'bacula';
// $config[1]['password'] = 'verystrongpassword';
// $config[1]['db_name'] = 'bacula';
// $config[1]['db_type'] = 'mysql';
// $config[1]['db_port'] = '3306';
