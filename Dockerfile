FROM wordpress:php8.3-apache

# ติดตั้ง WP-CLI (คงเดิม)
RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        && rm -rf /var/lib/apt/lists/* \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# ตั้งค่า Permissions (คงเดิม)
RUN chown -R www-data:www-data /var/www/html

# --- ส่วนนี้คือจุดสำคัญ: สั่งรันคำสั่งแก้ไข MPM ทันทีที่ Container เริ่มทำงาน ---
# เราจะ Discard ค่าเดิม และเปิด mpm_prefork ก่อนที่จะรัน apache2-foreground (ตัวเริ่มเว็บ)
CMD ["bash", "-c", "a2dismod mpm_event mpm_worker && a2enmod mpm_prefork && apache2-foreground"]