FROM wordpress:php8.3-apache

# ---- SYSTEM + WP-CLI ----
RUN apt-get update && apt-get install -y --no-install-recommends \
        less curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# ---- FIX APACHE (แก้ 403 ตัวจริง) ----
RUN a2dismod mpm_event mpm_worker \
    && a2enmod mpm_prefork rewrite \
    && echo "<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" > /etc/apache2/conf-available/wordpress.conf \
    && a2enconf wordpress

# ---- PERMISSION ----
RUN chown -R www-data:www-data /var/www/html

# ---- RUN ----
CMD ["apache2-foreground"]