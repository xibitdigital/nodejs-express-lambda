module "package_dir_with_npm_install" {
  source = "terraform-aws-modules/lambda/aws"

  create_function = false

  runtime     = "nodejs14.x"
  source_path = {
    path     = "${var.repo_root_path}/app",
    commands = [
      "npm install",
      ":zip"
    ],
    patterns = [
      "!.*/.*\\.txt",    # Skip all txt files recursively
      "node_modules/.+", # Include all node_modules
    ],
  }
}


# module "lambda_function_from_package" {
#   source = "../../"

#   create_package         = false
#   local_existing_package = module.c.local_filename

#   function_name = "${random_pet.this.id}-function-packaged"
#   handler       = "index.lambda_handler"
#   runtime       = "python3.8"

#   layers = [
#     module.lambda_layer.lambda_layer_arn
#   ]
# }