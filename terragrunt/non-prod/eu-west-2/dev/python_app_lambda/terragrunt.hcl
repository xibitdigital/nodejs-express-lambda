locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env        = local.environment_vars.locals.environment
  owner      = local.account_vars.locals.owner
  aws_region = local.region_vars.locals.aws_region
}

terraform {
  source = "${get_repo_root()}/terraform/modules//python_app_lambda"
}

include "root" {
  path = find_in_parent_folders()
}

# Set common variables for the environment. This is automatically pulled in the root terragrunt.hcl configuration to
# feed forward to the child modules.
inputs = {
  lambda_repo_root_path   = get_repo_root()
  lambda_function_name    = "test_python_todo"
  lambda_handler          = "src/app/main.handler"
  lambda_prefix           = "xibit_digital_lambdas"
  lambda_runtime          = "python3.10"
  lambda_identity_timeout = "1000"
  # common vars
  aws_region  = local.aws_region
  environment = local.env
}
