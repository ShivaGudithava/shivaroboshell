nodejs() {
  log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Create ${component} Service <<<<<<<<<<<<\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Create MongoDB Repo <<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Install NodeJS Repo <<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Install NodeJS <<<<<<<<<<<<\e[0m"
yum install nodejs -y&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Create Application  <<<<<<<<<<<<\e[0m"
add roboshop&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<\e[0m"
rm -rf /app&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<\e[0m"
mkdir /app&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Download Application Content <<<<<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Extract Application Content  <<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/${component}.zip&>>/tmp/roboshop.log
cd /app

echo -e "\e[36m>>>>>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<\e[0m"
npm install&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Insatll Mongo Client <<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Load user Schema <<<<<<<<<<<<\e[0m"
mongo --host mongodb.gudishivadevops.online </app/schema/${component}.js&>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Start user Services <<<<<<<<<<<<\e[0m"
systemctl daemon-reload&>>/tmp/roboshop.log
systemctl enable ${component}&>>/tmp/roboshop.log
systemctl restart ${component}&>>/tmp/roboshop.log
}