# 1. ใช้ Version แบบระบุเลข (Pin version) แทน latest เพื่อความเสถียร
FROM wordpress:php8.3-apache

# 2. รวมคำสั่ง RUN เพื่อลดจำนวน Layer (ช่วยให้ Build เร็วขึ้นและขนาดภาพเล็กลง)
RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        && rm -rf /var/lib/apt/lists/*

# 3. ติดตั้ง WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 4. แก้ไข MPM (ใช้วิธีที่ถูกต้องตามมาตรฐาน Debian/Ubuntu)
# แทนที่จะลบไฟล์โดยตรง เราใช้คำสั่ง a2dismod เพื่อปิดตัวที่ไม่ต้องการให้สะอาด
RUN a2dismod mpm_event mpm_worker && a2enmod mpm_prefork

# 5. ตั้งค่า Permissions
# เราทำในขั้นตอนสุดท้ายเพื่อให้แน่ใจว่าไฟล์ทั้งหมดถูกต้อง
RUN chown -R www-data:www-data /var/www/html