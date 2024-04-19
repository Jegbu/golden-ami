sudo yum update # update server(s)

# Install Apache
sudo yum -y install httpd

sudo systemctl enable httpd

sudo yum systemctl start httpd

# Add message to created index file in html directory
echo "Yeah I did that!!" >> /var/www/html/index.html
