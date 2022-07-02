variable "stack_name" {
  type = "string"
}

variable "aws_region" {
  type = "string"
}

variable "aws_profile" {
  type = "string"
}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
  version = "~> 1.20"
}

module "lambda" {
  source      = "./modules/lambda"
  stack_name  = "${var.stack_name}"
  aws_profile = "${var.aws_profile}"
  aws_region  = "${var.aws_region}"
  table_arn   = "${module.dynamodb.table_arn}"
  table_name  = "${module.dynamodb.table_name}"
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  stack_name  = "${var.stack_name}"
  aws_profile = "${var.aws_profile}"
  aws_region  = "${var.aws_region}"
}

module "apigateway" {
  source        = "./modules/apigateway"
  stack_name    = "${var.stack_name}"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "${var.aws_region}"
  function_name = "${module.lambda.function_name}"
  function_arn = "${module.lambda.function_arn}"
}
