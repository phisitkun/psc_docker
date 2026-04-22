FROM wordpress:php8.3-apache

# 1. ติดตั้ง WP-CLI
RUN apt-get update && apt-get install -y --no-install-recommends less && rm -rf /var/lib/apt/lists/* \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 2. แก้ปัญหา AH00534 (ใช้ RUN ไม่ใช่ CMD)
# การทำแบบนี้จะทำให้ Apache พร้อมใช้งานทันทีที่ Container รันขึ้นมา
RUN a2dismod mpm_event mpm_worker && a2enmod mpm_prefork

# 3. เซต ServerName เพื่อแก้ Warning AH00558
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 4. Permissions
RUN chown -R www-data:www-data /var/www/html

# *** สำคัญที่สุด: ห้ามใช้ CMD override entrypoint ***
# เราไม่ต้องใส่ CMD ใดๆ ให้มันใช้ CMD และ ENTRYPOINT ของ image หลักไปเลย