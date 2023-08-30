echo ">>>>>>>>>>> Create Catalogue Service <<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>>>>>>> Create MongoDB Repo <<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>>>>>>> Install NodeJS Repo <<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>>>>>>> Install NodeJS <<<<<<<<<<<<"
yum install nodejs -y

echo ">>>>>>>>>>> Create Application User <<<<<<<<<<<<"
useradd roboshop

echo ">>>>>>>>>>> Create Application Directory <<<<<<<<<<<<"
mkdir /app

echo ">>>>>>>>>>> Download Application Content <<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>>>>>>> Extract Application Content  <<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<"
npm install

echo ">>>>>>>>>>> Insatll Mongo Client <<<<<<<<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>>>>>>> Load Catalogue Schema <<<<<<<<<<<<"
mongo --host mongodb.gudishivadevops.online </app/schema/catalogue.js

echo ">>>>>>>>>>> Start Catalogue Services <<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
