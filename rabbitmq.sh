source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is missing"
  exit
fi

print_head "Configuring Erlang YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Configuring RabbitMQ YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Install Erlang & RabbitMQ"
yum install erlang rabbitmq-server -y bash &>>${LOG}
status_check

print_head "Enable RabbitMQ Server"
systemctl enable rabbitmq-server bash &>>${LOG}
status_check

print_head "Start RabbitMQ Server"
systemctl start rabbitmq-server bash &>>${LOG}
status_check

print_head "Add Application User"
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} bash &>>${LOG}
status_check

print_head "Add Tags to Application User"
rabbitmqctl set_user_tags roboshop administrator bash &>>${LOG}
status_check

print_head "Add permission to Application User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" bash &>>${LOG}
status_check


