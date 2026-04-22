FROM wordpress:php8.3-apache

# 1. ติดตั้ง WP-CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        && rm -rf /var/lib/apt/lists/* \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 2. แก้ปัญหา MPM (ทำตอน Build เลย)
RUN a2dismod mpm_event mpm_worker && a2enmod mpm_prefork

# 3. แก้ปัญหา AH00558 (ServerName) โดยสร้างไฟล์ config ใหม่
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 4. ตั้งค่า Permissions
RUN chown -R www-data:www-data /var/www/html

# --- สังเกตว่าเราไม่ใช้ CMD แล้ว! ให้ใช้ Default Entrypoint ของ Image ---