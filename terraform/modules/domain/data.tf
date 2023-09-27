data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "this" {}

data "template_file" "open_api_body" {
  template = file("${path.module}/open-api.yml")

  vars = {
    get_lambda_arn          = module.lambda_function_from_package.lambda_function_arn
    aws_region              = var.aws_region
    lambda_identity_timeout = var.lambda_identity_timeout
  }

}
