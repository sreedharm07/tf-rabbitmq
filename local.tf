locals {
  name_pre = "${var.env}-rabbitmq"
  tags= merge(var.tags,{tf-module="rabbitmq"},{env=var.env})

}