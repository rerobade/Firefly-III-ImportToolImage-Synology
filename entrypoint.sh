#!/bin/bash

echo "Now in entrypoint.sh (v1.3) for the Firefly III CSV importer."
echo "Please wait for the container to start..."

# set docker var.
export IS_DOCKER=true

if [ -z $APACHE_RUN_USER ]
then
      APACHE_RUN_USER='www-data'
fi

if [ -z $APACHE_RUN_GROUP ]
then
      APACHE_RUN_GROUP='www-data'
fi


# remove any lingering files that may break upgrades:
rm -f $FIREFLY_III_PATH/storage/framework/cache/data/*
rm -f $FIREFLY_III_PATH/storage/logs/*.log
rm -f $FIREFLY_III_PATH/storage/logs/laravel.log

chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP $FIREFLY_III_PATH/storage
chmod -R 775 $FIREFLY_III_PATH/storage

composer dump-autoload > /dev/null 2>&1
php artisan package:discover > /dev/null 2>&1
php artisan cache:clear > /dev/null 2>&1
php artisan config:cache > /dev/null 2>&1
php artisan importer:version

if [ "$WEB_SERVER" == "false" ]; then
	echo "Will launch auto import on /import directory."
	php artisan importer:auto-import /import
else
	echo "Will now run Apache web server:"
	exec apache2-foreground
fi
