ARG apache_platform
FROM fireflyiii/base:apache-$apache_platform

# See also: https://github.com/JC5/firefly-iii-base-image

ARG version
ARG importer
ENV VERSION=$version
ENV IMPORTER=$importer

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY counter.txt /var/www/counter-main.txt
COPY date.txt /var/www/build-date-main.txt

# install Firefly III Importer and execute finalize-image.
RUN curl -SL https://github.com/firefly-iii/$IMPORTER-importer/archive/$VERSION.tar.gz | tar xzC $FIREFLY_III_PATH --strip-components 1 && \
    chmod -R 775 $FIREFLY_III_PATH/storage && \
    composer install --prefer-dist --no-dev --no-scripts && /usr/local/bin/finalize-image.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
