FROM wordpress:latest

# ติดตั้ง WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# --- ส่วนแก้ไข Apache MPM ที่แข็งแกร่งกว่าเดิม ---
# เราจะลบไฟล์ config ของ MPM ทุกตัวทิ้ง แล้วเปิดเฉพาะ prefork
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load \
    && a2enmod mpm_prefork
# ---------------------------------------------

RUN chown -R www-data:www-data /var/www/html