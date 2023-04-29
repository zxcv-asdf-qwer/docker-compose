# a_initial_mysql_multi_databases.sh

if [ -n "$MYSQL_MULTIPLE_DATABASES" ]; then

  for dbname in $(echo $MYSQL_MULTIPLE_DATABASES | tr ',' ' '); do
	  mysql -u root -p$MYSQL_ROOT_PASSWORD <<-EOSQL
	    CREATE DATABASE $dbname;
      GRANT ALL PRIVILEGES ON $dbname.* TO '$MYSQL_USER'@'%';
EOSQL
  done
fi

