# Use the official WordPress image as the base image
FROM wordpress:5.7.1-php7.4-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the custom theme to the container
COPY  wordpress-code/test.php /var/www/html/

# Copy the custom plugins to the container
#COPY my-custom-plugins /var/www/html/wp-content/plugins/

# Copy the custom configuration files to the container
#COPY my-custom-config /var/www/html/

# Set the WordPress uploads directory to a volume
#VOLUME /var/www/html/wp-content/uploads

# Install the required PHP extensions
RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libzip-dev \
    ; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install gd mysqli opcache zip; \
    pecl install apcu; \
    docker-php-ext-enable apcu; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;

# Enable mod_rewrite for WordPress permalinks
RUN a2enmod rewrite

# Increase PHP memory limit and max upload size
RUN echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/memory-limit.ini
RUN echo "upload_max_filesize = 64M" > /usr/local/etc/php/conf.d/upload-max-filesize.ini
RUN echo "post_max_size = 64M" > /usr/local/etc/php/conf.d/post-max-size.ini

# Increase Apache timeout and keepalive settings
RUN echo "Timeout 300" >> /etc/apache2/apache2.conf
RUN echo "KeepAlive On" >> /etc/apache2/apache2.conf
RUN echo "MaxKeepAliveRequests 100" >> /etc/apache2/apache2.conf
RUN echo "KeepAliveTimeout 5" >> /etc/apache2/apache2.conf
