FROM wordpress:php8.3-apache

# ---- SYSTEM SETUP ----
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        less \
        curl \
    ; \
    rm -rf /var/lib/apt/lists/*

# ---- INSTALL WP-CLI (PIN VERSION) ----
ENV WP_CLI_VERSION=2.10.0

RUN curl -fsSL -o /usr/local/bin/wp https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar \
    && chmod +x /usr/local/bin/wp

# ---- APACHE CONFIG ----
RUN a2dismod mpm_event mpm_worker \
    && a2enmod mpm_prefork rewrite headers expires

# Fix ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# ---- WORDPRESS PERMISSIONS ----
RUN chown -R www-data:www-data /var/www/html

# ---- OPTIONAL: PHP TUNING ----
RUN { \
    echo "upload_max_filesize=64M"; \
    echo "post_max_size=64M"; \
    echo "memory_limit=256M"; \
    echo "max_execution_time=120"; \
} > /usr/local/etc/php/conf.d/custom.ini

# ---- HEALTHCHECK (สำคัญสำหรับ Railway) ----
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
  CMD curl -f http://localhost/ || exit 1

# ❗ ไม่ต้อง override CMD / ENTRYPOINT