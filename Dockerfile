FROM wordpress:latest

# ติดตั้ง WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# --- เพิ่มคำสั่งนี้เพื่อแก้ปัญหา MPM Conflict ---
RUN a2dismod mpm_event && a2enmod mpm_prefork
# ---------------------------------------------

RUN chown -R www-data:www-data /var/www/html