FROM wordpress:php8.3-apache

# ---- SYSTEM SETUP ----
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        less \
        curl \
    ; \
    rm -rf /var/lib/apt/lists/*

# ---- INSTALL WP-CLI ----
ENV WP_CLI_VERSION=2.10.0

RUN curl -fsSL -o /usr/local/bin/wp \
    https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar \
    && chmod +x /usr/local/bin/wp

# ---- FIX APACHE MPM (IMPORTANT) ----
RUN set -eux; \
    rm -f /etc/apache2/mods-enabled/mpm_*.load; \
    rm -f /etc/apache2/mods-enabled/mpm_*.conf; \
    a2enmod mpm_prefork; \
    a2enmod rewrite headers expires

# ---- FIX APACHE WARNING ----
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

# ---- PHP TUNING ----
RUN { \
    echo "upload_max_filesize=64M"; \
    echo "post_max_size=64M"; \
    echo "memory_limit=256M"; \
    echo "max_execution_time=120"; \
    echo "max_input_vars=3000"; \
} > /usr/local/etc/php/conf.d/custom.ini

# ---- WORDPRESS PERMISSIONS ----
RUN chown -R www-data:www-data /var/www/html

# ---- HEALTHCHECK ----
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
  CMD curl -f http://localhost/ || exit 1