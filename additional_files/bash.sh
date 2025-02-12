#!/bin/bash

export HOME=/home/ubuntu

# Update and install required packages
sudo apt update
sudo apt install -y nginx curl

# Install NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Explicitly source the NVM scripts to make NVM, npm, and Node.js available in the non-interactive shell
export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install the desired Node.js version
nvm install 20.11.0

cd /var/www/
sudo mkdir -p todo

# Change directory to the frontend app
cd todo/ && git clone https://github.com/Developer9844/frontend-todo.git

cd frontend-todo

# Install npm dependencies
npm i

# Install pm2 globally and start the app with it
npm install -g pm2
pm2 start ecosystem.config.js --update-env

# Fix permissions for PM2 socket files
sudo chown -R ubuntu:ubuntu /home/ubuntu/.pm2

# Create an Nginx configuration file
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    root /var/www/todo/frontend-todo;
    
    index index.html index.htm index.nginx-debian.html;
    
    server_name _;

    client_max_body_size 550M;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_connect_timeout 600s;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Restart Nginx to apply changes
sudo systemctl restart nginx
sudo systemctl enable nginx