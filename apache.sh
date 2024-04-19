sudo yum update # update server(s)

# Install Apache
sudo yum -y install httpd

sudo systemctl enable httpd

sudo systemctl start httpd

# Add message to created index file in html directory
sudo bash -c 'echo "Yeah I Justin did that!!!!!" >> /var/www/html/index.html'
