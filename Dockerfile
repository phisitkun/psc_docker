FROM wordpress:latest
# ติดตั้ง WP-CLI เพื่อจัดการเว็บ
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp