FROM wordpress:php8.3-apache

# ---- SYSTEM ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    less curl \
    && rm -rf /var/lib/apt/lists/*

# ---- WP-CLI (optional แต่แนะนำ) ----
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# ---- FIX APACHE (แก้ 403 + เปิด .htaccess) ----
RUN a2dismod mpm_event mpm_worker \
    && a2enmod mpm_prefork rewrite \
    && echo "<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" > /etc/apache2/conf-available/wordpress.conf \
    && a2enconf wordpress

# ---- PERMISSIONS ----
RUN chown -R www-data:www-data /var/www/html

# ---- PORT (Railway ใช้ dynamic แต่ Apache ใช้ 80 ได้เลย) ----
EXPOSE 80

CMD ["apache2-foreground"]