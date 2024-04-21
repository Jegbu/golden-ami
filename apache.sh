sudo yum update # update server(s)

# Install Apache
sudo yum -y install httpd

sudo systemctl enable httpd

sudo systemctl start httpd

# Add message to created index file in html directory
sudo bash -c 'echo "To err is human, but to really foul things up you need a computer. - Paul R. Ehrlich" >> /var/www/html/index.html'
