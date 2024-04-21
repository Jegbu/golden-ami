# This is for ubuntu servers
sudo apt-get update # update server(s)

# Install Apache
sudo apt-get -f install

sudo apt-get install -y apache2 apache2-bin media-types

sudo systemctl enable apache2

sudo systemctl start apache2

# Add message to created index file in html directory
sudo bash -c 'echo \"To err is human, but to really foul things up you need a computer. - Paul R. Ehrlich\" >> /var/www/html/index.html'

