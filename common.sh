log=/tmp/roboshop.log

func_ exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
    else
    echo -e "\e[31m FAILURE \e[0m"
      fi
}
func_appreq() {

  echo -e "\e[36m>>>>>>>>>>> Create ${component} Services <<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>/tmp/roboshop.log
  func_exit_status


  echo -e "\e[36m>>>>>>>>>>> Create Application user  <<<<<<<<<<<<\e[0m"
  add roboshop&>>/tmp/roboshop.log
func_exit_status

  echo -e "\e[36m>>>>>>>>>>> Cleanup Existing Application content <<<<<<<<<<<<\e[0m"
  rm -rf /app&>>/tmp/roboshop.log
 func_exit_status

  echo -e "\e[36m>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<\e[0m"
  mkdir /app&>>/tmp/roboshop.log
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>> Download Application Content <<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip&>>/tmp/roboshop.log
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>> Extract Application Content  <<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip&>>/tmp/roboshop.log
  cd /app
func_exit_status
}
 func_systemd() {
   echo -e "\e[36m>>>>>>>>>>> Start ${component} Services <<<<<<<<<<<<\e[0m"
   systemctl daemon-reload&>>/tmp/roboshop.log
   systemctl enable ${component}&>>/tmp/roboshop.log
   systemctl restart ${component}&>>/tmp/roboshop.log
func_exit_status
 }
 func_schema_setup() {

   if [ "${schema_type}" == "mongodb" ]; then
   echo -e "\e[36m>>>>>>>>>>> Insatll Mongo Client <<<<<<<<<<<<\e[0m"
   yum install mongodb-org-shell -y&>>/tmp/roboshop.log
  func_exit_status

   echo -e "\e[36m>>>>>>>>>>> Load user Schema <<<<<<<<<<<<\e[0m"
   mongo --host mongodb.gudishivadevops.online </app/schema/${component}.js&>>/tmp/roboshop.log
 func_exit_status
 fi


 if [ "${schema_type}" == "mysql" ]; then
   echo -e "\e[36m>>>>>>>>>>> Install MySQL Client <<<<<<<<<<<<\e[0m"
   yum install mysql -y &>>/tmp/roboshop.log

   echo -e "\e[36m>>>>>>>>>>> Load Schema <<<<<<<<<<<<\e[0m"
   mysql -h mysql.gudishivadevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>/tmp/roboshop.log
   fi
    }
func_nodejs() {
  log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Create MongoDB Repo <<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo&>>/tmp/roboshop.log
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Install NodeJS Repo <<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash&>>/tmp/roboshop.log
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Install NodeJS <<<<<<<<<<<<\e[0m"
yum install nodejs -y&>>/tmp/roboshop.log
func_exit_status

func_appreq

echo -e "\e[36m>>>>>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<\e[0m"
npm install&>>/tmp/roboshop.log
func_exit_status

func_schema_setup

func_systemd
}

func_java() {

echo -e "\e[36m>>>>>>>>>>> Install Maven <<<<<<<<<<<<\e[0m"
yum install maven -y &>>/tmp/roboshop.log

func_appreq

echo -e "\e[36m>>>>>>>>>>> Build ${component} Services <<<<<<<<<<<<\e[0m"
mvn clean package &>>/tmp/roboshop.log
mv target/${component}-1.0.jar ${component}.jar &>>/tmp/roboshop.log

func_schema_setup

func_systemd
}

func_python() {
echo -e "\e[36m>>>>>>>>>>> Build ${component} Services <<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

  func_systemd
  echo -e "\e[36m>>>>>>>>>>> Build ${component} Services <<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

  func_systemd
}