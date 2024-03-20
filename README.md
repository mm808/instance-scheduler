# Instance Scheduler Terraform      
This project implements the AWS instance scheduler tool stacks using a Terraform wrapper. It configures the main stack in a 'services' account and configures a secondary stack that adds a custom schedule and period in the DynamoDB table as a demonstration of how we can programmatically create custom schedules along side the default configuration. 
It looks like each new schedule needs a different stack file. Editing within an existing schedule works Ok but when I tried to add another schedule in the same stack file I get the error   

    update: failed to update CloudFormation stack (UPDATE_ROLLBACK_COMPLETE): ["Received response status [FAILED]  
    from custom resource. Message returned:  (RequestId: fbb4929e-a782-4de2-a9d4-8a84d442bf69)"]
    │ 
    │   with aws_cloudformation_stack.custom_instance_schedules,
    │   on main.tf line 18, in resource "aws_cloudformation_stack" "custom_instance_schedules":
    │   18: resource "aws_cloudformation_stack" "custom_instance_schedules" { 


# stack to create custom schedule2
resource "aws_cloudformation_stack" "custom_instance_schedule2" {
  name          = "Custom-Instance-Schedule2"
  template_body = file("cf_templates/custom_instance_schedule2.template")

  parameters = {
    ServiceInstanceScheduleServiceTokenARN = data.aws_cloudformation_stack.hub_instance_scheduler_stack.outputs["ServiceInstanceScheduleServiceToken"]
  }
  capabilities = ["CAPABILITY_IAM"]
}