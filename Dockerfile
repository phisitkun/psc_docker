FROM wordpress:php8.3-apache

# ---- SYSTEM ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    less curl \
    && rm -rf /var/lib/apt/lists/*

# ---- WP-CLI ----
ENV WP_CLI_VERSION=2.10.0
RUN curl -fsSL -o /usr/local/bin/wp https://github.com/wp-cli/builds/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar \
    && chmod +x /usr/local/bin/wp

# ---- FIX APACHE (สำคัญมาก) ----
RUN a2dismod mpm_event mpm_worker \
    && a2enmod mpm_prefork rewrite \
    && echo "<Directory /var/www/html>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" > /etc/apache2/conf-available/wordpress.conf \
    && a2enconf wordpress

# ---- PERMISSION ----
RUN chown -R www-data:www-data /var/www/html

# ---- ENTRYPOINT ----
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]