FROM wordpress:php8.3-apache

# 1. ติดตั้ง System Dependencies ที่จำเป็น
RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        && rm -rf /var/lib/apt/lists/* \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 2. แก้ไข MPM (แก้ปัญหา Apache Conflict โดยถาวร)
RUN a2dismod mpm_event mpm_worker && a2enmod mpm_prefork

# 3. ตั้งค่า PHP (อัปโหลดไฟล์ขนาดใหญ่ได้)
# สร้างไฟล์นี้ไว้ข้างๆ Dockerfile ด้วยนะครับ
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# 4. Permissions (จัดการเฉพาะที่จำเป็น)
RUN chown -R www-data:www-data /var/www/html

# สังเกต: เราไม่มี CMD ตรงนี้ เพราะเราจะปล่อยให้ Entrypoint ของ Official Image ทำงานเอง