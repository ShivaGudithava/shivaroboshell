 source common.sh

echo -e "\e[36m>>>>>>>>>>> Install Nginx <<<<<<<<<<<<\e[0m"
yum install nginx -y &>>/tmp/roboshop.log
 func_exit_status


 echo -e "\e[36m>>>>>>>>>>> Copy Roboshop Configuration <<<<<<<<<<<<\e[0m"
 cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/roboshop.log
  func_exit_status

echo -e "\e[36m>>>>>>>>>>> Clean Old Content <<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
  func_exit_status

echo -e "\e[36m>>>>>>>>>>> Download Application Content <<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log
  func_exit_status

  cd /usr/share/nginx/html

echo -e "\e[36m>>>>>>>>>>> Extract Application Content <<<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip &>>/tmp/roboshop.log
  func_exit_status

echo -e "\e[36m>>>>>>>>>>> Start Nginx Service  <<<<<<<<<<<<\e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log
 func_exit_status
