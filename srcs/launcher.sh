service mysql start;

#echo "CREATE DATABASE data;" | mysql -u root --skip-password;

mysql -e  "CREATE DATABASE data;";

mysql -e "GRANT ALL PRIVILEGES ON data. * TO 'root'@'localhost' WITH GRANT OPTION;";

mysql -e  "FLUSH PRIVILEGES;" ;

mysql -e  "update mysql.user set plugin='' where user='root';" ;

service nginx start;

service php7.3-fpm start;

#tail -f
bash