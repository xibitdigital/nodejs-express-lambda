module "package_dir_poetry_no_docker" {
  source = "terraform-aws-modules/lambda/aws"

  create_function = false

  runtime = var.lambda_runtime

  source_path = [
    {
      path           = local.app_path
      poetry_install = true
    }
  ]

  artifacts_dir = "${path.root}/builds/package_dir_poetry_no_docker/" # this will go local to the .terragrunt-cache folder
}


module "lambda_function_from_package" {
  source = "terraform-aws-modules/lambda/aws"

  create_package         = false
  local_existing_package = module.package_dir_poetry_no_docker.local_filename

  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
}


module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "${var.lambda_function_name}-http-${var.environment}"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  # domain_name                 = "terraform-aws-modules.modules.tf"
  # domain_name_certificate_arn = "arn:aws:acm:eu-west-1:052235179155:certificate/2b3a7ed9-05e1-4f9e-952b-27744ba06da6"

  # Access logs
  default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = data.template_file.open_api_body.rendered

  # {
  #   "POST /" = {
  #     lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
  #     payload_format_version = "2.0"
  #     timeout_milliseconds   = 12000
  #   }

  #   "GET /some-route-with-authorizer" = {
  #     integration_type = "HTTP_PROXY"
  #     integration_uri  = "some url"
  #     authorizer_key   = "azure"
  #   }

  #   "$default" = {
  #     lambda_arn = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
  #   }
  # }

  # authorizers = {
  #   "azure" = {
  #     authorizer_type  = "JWT"
  #     identity_sources = "$request.header.Authorization"
  #     name             = "azure-auth"
  #     audience         = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
  #     issuer           = "https://sts.windows.net/aaee026e-8f37-410e-8869-72d9154873e4/"
  #   }
  # }

  # tags = {
  #   Name = "http-apigateway"
  # }
}


# module "lambda_function" {
#   source = "terraform-aws-modules/lambda/aws"

#   function_name          = var.lambda_function_name
#   description            = "My awesome lambda function"
#   handler                = "dist/index.handle"
#   runtime                = var.lambda_runtime
#   ephemeral_storage_size = 10240
#   architectures          = ["x86_64"]
#   publish                = true

#   source_path = {
#     path = "${var.repo_root_path}/app",
#     commands = [
#       "npm run build",
#       ":zip"
#     ],
#     patterns = [
#       "!.*/.*\\.txt",     # skip all txt files recursively
#       "!node_modules/.+", # exclude all node_modules
#       "dist/*.js"
#     ],
#   }

#   store_on_s3 = true
#   s3_bucket   = module.s3_bucket.s3_bucket_id
#   s3_prefix   = "lambda-builds/"

#   artifacts_dir = "${path.root}/.terraform/lambda-builds/"

#   layers = [
#     module.lambda_layer_s3.lambda_layer_arn,
#   ]

#   environment_variables = {
#     Hello      = "World"
#     Serverless = "Terraform"
#   }

#   role_path   = "/tf-managed/"
#   policy_path = "/tf-managed/"

#   attach_dead_letter_policy = true
#   dead_letter_target_arn    = aws_sqs_queue.dlq.arn

#   allowed_triggers = {
#     Config = {
#       principal        = "config.amazonaws.com"
#       principal_org_id = data.aws_organizations_organization.this.id
#     }
#     # APIGatewayAny = {
#     #   service    = "apigateway"
#     #   source_arn = "arn:aws:execute-api:eu-west-1:${data.aws_caller_identity.current.account_id}:aqnku8akd0/*/*/*"
#     # },
#     # APIGatewayDevPost = {
#     #   service    = "apigateway"
#     #   source_arn = "arn:aws:execute-api:eu-west-1:${data.aws_caller_identity.current.account_id}:aqnku8akd0/dev/POST/*"
#     # },
#     # OneRule = {
#     #   principal  = "events.amazonaws.com"
#     #   source_arn = "arn:aws:events:eu-west-1:${data.aws_caller_identity.current.account_id}:rule/RunDaily"
#     # }
#   }

#   ######################
#   # Lambda Function URL
#   ######################
#   create_lambda_function_url = true
#   authorization_type         = "AWS_IAM"
#   cors = {
#     allow_credentials = true
#     allow_origins     = ["*"]
#     allow_methods     = ["*"]
#     allow_headers     = ["date", "keep-alive"]
#     expose_headers    = ["keep-alive", "date"]
#     max_age           = 86400
#   }
#   invoke_mode = "RESPONSE_STREAM"

#   ######################
#   # Additional policies
#   ######################

#   assume_role_policy_statements = {
#     account_root = {
#       effect  = "Allow",
#       actions = ["sts:AssumeRole"],
#       principals = {
#         account_principal = {
#           type        = "AWS",
#           identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#         }
#       }
#       condition = {
#         stringequals_condition = {
#           test     = "StringEquals"
#           variable = "sts:ExternalId"
#           values   = ["12345"]
#         }
#       }
#     }
#   }

#   attach_policy_json = true
#   policy_json        = <<-EOT
#     {
#         "Version": "2012-10-17",
#         "Statement": [
#             {
#                 "Effect": "Allow",
#                 "Action": [
#                     "xray:GetSamplingStatisticSummaries"
#                 ],
#                 "Resource": ["*"]
#             }
#         ]
#     }
#   EOT

#   attach_policy_jsons = true
#   policy_jsons = [
#     <<-EOT
#       {
#           "Version": "2012-10-17",
#           "Statement": [
#               {
#                   "Effect": "Allow",
#                   "Action": [
#                       "xray:*"
#                   ],
#                   "Resource": ["*"]
#               }
#           ]
#       }
#     EOT
#   ]
#   number_of_policy_jsons = 1

#   attach_policy = true
#   policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

#   attach_policies    = true
#   policies           = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
#   number_of_policies = 1

#   # attach_policy_statements = true
#   # policy_statements = {
#   #   dynamodb = {
#   #     effect    = "Allow",
#   #     actions   = ["dynamodb:BatchWriteItem"],
#   #     resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
#   #   },
#   #   s3_read = {
#   #     effect    = "Deny",
#   #     actions   = ["s3:HeadObject", "s3:GetObject"],
#   #     resources = ["arn:aws:s3:::my-bucket/*"]
#   #   }
#   # }

#   timeouts = {
#     create = "20m"
#     update = "20m"
#     delete = "20m"
#   }

#   tags = {
#     Module = "lambda1"
#   }
# }
