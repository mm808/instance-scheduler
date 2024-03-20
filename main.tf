# main.tf
provider "aws" {
  region = "us-east-1"
}

# main stack that deploys the scheduler tool
resource "aws_cloudformation_stack" "hub_instance_scheduler_stack" {
  name          = "Hub-Instance-Scheduler"
  template_body = file("cf_templates/hub_instance_scheduler.json")
  capabilities  = ["CAPABILITY_IAM"]
}

data "aws_cloudformation_stack" "hub_instance_scheduler_stack" {
  name = aws_cloudformation_stack.hub_instance_scheduler_stack.name
}

# stack to create custom schedule1
resource "aws_cloudformation_stack" "custom_instance_schedule1" {
  name          = "Custom-Instance-Schedule1"
  template_body = file("cf_templates/custom_instance_schedule1.template")

  parameters = {
    ServiceInstanceScheduleServiceTokenARN = data.aws_cloudformation_stack.hub_instance_scheduler_stack.outputs["ServiceInstanceScheduleServiceToken"]
  }
  capabilities = ["CAPABILITY_IAM"]
}
