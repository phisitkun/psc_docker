FROM wordpress:latest

# Install WP-CLI for troubleshooting
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Fix for Apache MPM Error (AH00534)
# Disables conflicting modules and enables the stable prefork module
RUN a2dismod mpm_event mpm_worker mpm_prefork \
    && a2enmod mpm_prefork

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Ensure the entrypoint has the correct permissions
RUN chmod +x /usr/local/bin/docker-entrypoint.sh