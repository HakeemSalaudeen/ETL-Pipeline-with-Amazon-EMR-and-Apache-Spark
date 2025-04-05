# IAM Role setups
# IAM role for EMR Service

resource "aws_iam_role" "iam_emr_service_role" {
  name               = "iam_emr_service_role"
  assume_role_policy = data.aws_iam_policy_document.emr_assume_role.json
}

data "aws_iam_policy_document" "emr_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "iam_emr_service_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CancelSpotInstanceRequests",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteTags",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePrefixLists",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcEndpointServices",
      "ec2:DescribeVpcs",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:RequestSpotInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:DeleteVolume",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:DescribeSubnets",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListInstanceProfiles",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "s3:CreateBucket",
      "s3:Get*",
      "s3:List*",
    ]

    resources = ["*"]
  }
}

#emr service policy
resource "aws_iam_policy" "emr-service-policy" {
  name        = "emr-service-policy"
  description = "policy for emr to assume role"
  policy      = data.aws_iam_policy_document.iam_emr_service_policy.json
}

#emr service policy attachment
resource "aws_iam_role_policy_attachment" "emr-service-attach" {
  role       = aws_iam_role.iam_emr_service_role.name
  policy_arn = aws_iam_policy.emr-service-policy.arn
}

###--------------------------------------------- EC2
# IAM Role for EC2 Instance Profile
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_emr_profile_role" {
  name               = "iam_emr_profile_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "emr_profile" {
  name = "emr-profile"
  role = aws_iam_role.iam_emr_profile_role.name
}

data "aws_iam_policy_document" "iam_emr_profile_policy" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "ec2:Describe*",
      "elasticmapreduce:Describe*",
      "elasticmapreduce:ListBootstrapActions",
      "elasticmapreduce:ListClusters",
      "elasticmapreduce:ListInstanceGroups",
      "elasticmapreduce:ListInstances",
      "elasticmapreduce:ListSteps",
      "s3:*"
    ]

    resources = ["*"]
  }
}

## combination of aws_iam_policy + aws_iam_role_policy_attachment
resource "aws_iam_role_policy" "iam_emr_profile_policy" {
  name   = "iam_emr_profile_policy"
  role   = aws_iam_role.iam_emr_profile_role.id
  policy = data.aws_iam_policy_document.iam_emr_profile_policy.json
}


###------------------ auto-scaling
# IAM Role for autoscaling
data "aws_iam_policy_document" "auto_scaling_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_auto_scaling_role" {
  name               = "iam_auto_scaling_role"
  assume_role_policy = data.aws_iam_policy_document.auto_scaling_assume_role.json
}

data "aws_iam_policy_document" "iam_auto_scaling_policy" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "ec2:Describe*",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:UpdateAutoScalingGroup"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "iam_auto_scaling_policy" {
  name   = "iam_auto_scaling_policy"
  role   = aws_iam_role.iam_auto_scaling_role.id
  policy = data.aws_iam_policy_document.iam_auto_scaling_policy.json
}


#----------------------  service linked role
data "aws_iam_policy_document" "emr_service_linked_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["spot.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_emr_service_linked_role" {
  name               = "iam_emr_service_linked_role"
  assume_role_policy = data.aws_iam_policy_document.emr_service_linked_role.json
}

data "aws_iam_policy_document" "iam_emr_service_linked_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:RequestSpotInstances",
      "ec2:CancelSpotInstanceRequests",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeInstances",
      "ec2:TerminateInstances"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "iam_emr_service_linked_role_policy" {
  name   = "iam_emr_service_linked_role_policy"
  role   = aws_iam_role.iam_emr_service_linked_role.id
  policy = data.aws_iam_policy_document.iam_emr_service_linked_role_policy.json
}
































































# resource "aws_iam_role_policy" "iam_emr_service_policy" {
#   name   = "iam_emr_service_policy"
#   role   = aws_iam_role.iam_emr_service_role.id
#   policy = data.aws_iam_policy_document.iam_emr_service_policy.json
# }

# resource "aws_iam_role_policy_attachment" "emr_service_role_spot_permission" {
#   role       = aws_iam_role.iam_emr_service_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2SpotServiceRolePolicy"
# }



# resource "aws_iam_role_policy" "emr_service_linked_role_policy" {
#   name   = "emr_service_linked_role_policy"
#   role   = aws_iam_role.iam_emr_service_role.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = "iam:CreateServiceLinkedRole",
#         Resource = "arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/*",
#         Condition = {
#           StringLike = {
#             "iam:AWSServiceName": "spot.amazonaws.com"
#           }
#         }
#       }
#     ]
#   })
# }



# ## autoscaling role policy 
# resource "aws_iam_role" "emr_autoscaling_role" {
#   name = "emr-autoscaling-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "elasticmapreduce.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "emr_autoscaling_policy" {
#   role       = aws_iam_role.emr_autoscaling_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonElasticMapReduceforAutoScalingRole"
# }