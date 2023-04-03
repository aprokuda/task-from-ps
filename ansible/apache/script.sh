#/bin/bash

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
sudo mkdir -p /opt/html
sudo mkdir -p /opt/html/log
sudo chmod -R 755 /opt/html
sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
sudo echo IncludeOptional sites-enabled/*.conf >> /etc/httpd/conf/httpd.conf 
sudo mv /opt/apache.conf /etc/httpd/sites-available/apache.conf
sudo ln -s /etc/httpd/sites-available/apache.conf /etc/httpd/sites-enabled/apache.conf
sudo setsebool -P httpd_unified 1
sudo chcon -Rv --type=httpd_sys_content_t /opt/html/
