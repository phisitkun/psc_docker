FROM wordpress:php8.3-apache

# 1. ติดตั้ง WP-CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        && rm -rf /var/lib/apt/lists/* \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 2. แก้ปัญหา MPM Loaded (ทำตอน Build เพื่อให้ติดไปกับ Image)
# เราใช้ a2dismod/a2enmod ใน RUN เพื่อให้มันเสร็จสิ้นก่อนเริ่ม Container
RUN a2dismod mpm_event mpm_worker && a2enmod mpm_prefork

# 3. ตั้งค่า Permissions
RUN chown -R www-data:www-data /var/www/html

# สังเกตว่าเราไม่มี CMD แล้ว เพราะเราจะใช้ CMD เดิมของ Image ที่จัดการเรื่อง Copy file ให้เรา