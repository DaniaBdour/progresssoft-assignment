#!/bin/bash
set -e

TOMCAT_VER="9.0.115"
TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz"

echo '>>> [1/7] Updating system packages...'
apt-get update -y -q

echo '>>> [2/7] Installing Java 8...'
apt-get install -y openjdk-8-jdk curl wget
JAVA_HOME_PATH=$(readlink -f /usr/bin/java | sed 's|/bin/java||')

echo '>>> [3/7] Downloading Apache Tomcat '$TOMCAT_VER'...'
cd /opt
wget -q -O tomcat.tar.gz "$TOMCAT_URL"

echo '>>> [4/7] Extracting and configuring Tomcat...'
tar -xzf tomcat.tar.gz
mv "apache-tomcat-${TOMCAT_VER}" tomcat9
rm tomcat.tar.gz
chmod +x /opt/tomcat9/bin/*.sh
sed -i 's/port="8080"/port="7070"/' /opt/tomcat9/conf/server.xml

echo '>>> [5/7] Creating Tomcat systemd service...'
cat > /etc/systemd/system/tomcat.service << SVCEOF
[Unit]
Description=Apache Tomcat 9 Web Application Server
After=network.target

[Service]
Type=forking
Environment="JAVA_HOME=${JAVA_HOME_PATH}"
Environment="CATALINA_HOME=/opt/tomcat9"
Environment="CATALINA_BASE=/opt/tomcat9"
ExecStart=/opt/tomcat9/bin/startup.sh
ExecStop=/opt/tomcat9/bin/shutdown.sh
User=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
SVCEOF

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

echo '>>> [6/7] Installing and configuring Nginx...'
apt-get install -y nginx

cat > /etc/nginx/sites-available/tomcat << 'NGINX'
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass       http://localhost:7070;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/tomcat /etc/nginx/sites-enabled/
rm -f  /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx && systemctl enable nginx

echo '>>> [7/7] Verifying...'
ss -tlnp | grep -E '7070|:80'
echo '======================================================'
echo ' DONE! Tomcat on 7070, Nginx on 80'
echo '======================================================'
