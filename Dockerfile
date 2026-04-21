FROM wordpress:latest

# ติดตั้ง WP-CLI (เหมือนเดิม)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# --- เพิ่มส่วนนี้เพื่อแก้ปัญหา AH00534 ---
# สั่งปิด Module ที่อาจขัดแย้งกันให้หมด แล้วสั่งเปิดแค่ mpm_prefork (ตัวที่เสถียรที่สุดสำหรับ WordPress)
RUN a2dismod mpm_event mpm_worker mpm_prefork \
    && a2enmod mpm_prefork
# --------------------------------------

RUN chown -R www-data:www-data /var/www/html