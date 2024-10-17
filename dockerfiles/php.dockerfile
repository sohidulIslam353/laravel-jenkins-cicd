FROM php:8.2-fpm-alpine3.18

ARG UID=1000   # Default UID
ARG GID=1000   # Default GID
ARG USER=hunter  # Default user name

ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}

# Create a new group and user with specified UID and GID
RUN addgroup -g ${GID} --system ${USER} \
    && adduser -G ${USER} --system -D -s /bin/sh -u ${UID} ${USER}

# Create application directory and set ownership
RUN mkdir -p /var/www/html \
    && chown -R ${USER}:${USER} /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Update PHP-FPM configuration
RUN sed -i "s/user = www-data/user = ${USER}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/group = www-data/group = ${USER}/g" /usr/local/etc/php-fpm.d/www.conf \
    && echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Install necessary libraries for GD extension
RUN apk add --no-cache libpng libpng-dev jpeg-dev

# Configure and install GD extension
RUN docker-php-ext-configure gd --enable-gd --with-jpeg \
    && docker-php-ext-install gd

# Install EXIF extension
RUN docker-php-ext-install exif

# Install ZIP extension
RUN apk add --no-cache zip libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

# Install PDO and PDO MySQL extensions
RUN docker-php-ext-install pdo pdo_mysql

# Install Redis extension from source
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# Change to the non-root user
USER ${USER}

# Start PHP-FPM
CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
