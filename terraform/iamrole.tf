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
    sid    = "CreateInNetwork"
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:RunInstances",
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ManageSecurityGroups"
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CreateDefaultSecurityGroupInVPC"
    effect = "Allow"

    actions = [
      "ec2:CreateSecurityGroup",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ManageEMRInstances"
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteNetworkInterface",
      "ec2:ModifyInstanceAttribute",
      "ec2:TerminateInstances",
      "ec2:DeleteVolume",
      "ec2:DescribeVolumeStatus",
      "ec2:DetachVolume",
      "ec2:CancelSpotInstanceRequests",
      "ec2:DescribeImages",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSpotPriceHistory",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ListAndDescribeEC2Resources"
    effect = "Allow"

    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePrefixLists",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcEndpointServices",
      "ec2:DescribeVpcs",
      "ec2:DescribeVolumes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribePlacementGroups",
      "ec2:DescribeLaunchTemplates",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "PlacementGroupOperations"
    effect = "Allow"

    actions = [
      "ec2:CreatePlacementGroup",
      "ec2:DeletePlacementGroup",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AutoScalingOperations"
    effect = "Allow"

    actions = [
      "application-autoscaling:DeleteScalingPolicy",
      "application-autoscaling:DeregisterScalableTarget",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:DescribeScalingPolicies",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:RegisterScalableTarget",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CloudWatchOperations"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "VPCEndpointOperations"
    effect = "Allow"

    actions = [
      "ec2:CreateVpcEndpoint",
      "ec2:ModifyVpcEndpoint",
      "ec2:DeleteVpcEndpoints",
      "ec2:DescribeVpcEndpoints",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ResourceGroupsForCapacityReservations"
    effect = "Allow"

    actions = [
      "resource-groups:ListGroupResources",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "IAMRolePermissions"
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListInstanceProfiles",
      "iam:ListRolePolicies",
      "iam:PassRole",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "S3Operations"
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:CreateBucket",
      "s3:DeleteObject",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
      "s3:ListMultipartUploadParts",
      "s3:PutBucketVersioning",
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]

    resources = ["arn:aws:s3:::*"]
  }

  statement {
    sid    = "ElasticMapReduceOperations"
    effect = "Allow"

    actions = [
      "elasticmapreduce:Describe*",
      "elasticmapreduce:List*",
    ]

    resources = ["*"]
  }
}

# EMR service policy
resource "aws_iam_policy" "emr-service-policy" {
  name        = "emr-service-policy"
  description = "Policy for EMR to assume role"
  policy      = data.aws_iam_policy_document.iam_emr_service_policy.json
}

# EMR service policy attachment
resource "aws_iam_role_policy_attachment" "emr-service-attach" {
  role       = aws_iam_role.iam_emr_service_role.name
  policy_arn = aws_iam_policy.emr-service-policy.arn
}



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
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:CreateBucket",
      "s3:DeleteObject",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
      "s3:ListMultipartUploadParts",
      "s3:PutBucketVersioning",
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]

    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_role_policy" "iam_emr_profile_policy" {
  name   = "iam_emr_profile_policy"
  role   = aws_iam_role.iam_emr_profile_role.id
  policy = data.aws_iam_policy_document.iam_emr_profile_policy.json
}

# IAM Role for autoscaling
data "aws_iam_policy_document" "auto_scaling_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
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
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "elasticmapreduce:ListInstanceGroups",
      "elasticmapreduce:ModifyInstanceGroups",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "iam_auto_scaling_policy" {
  name   = "iam_auto_scaling_policy"
  role   = aws_iam_role.iam_auto_scaling_role.id
  policy = data.aws_iam_policy_document.iam_auto_scaling_policy.json
}

# Service linked role for Spot instances
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
      "ec2:TerminateInstances",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "iam_emr_service_linked_role_policy" {
  name   = "iam_emr_service_linked_role_policy"
  role   = aws_iam_role.iam_emr_service_linked_role.id
  policy = data.aws_iam_policy_document.iam_emr_service_linked_role_policy.json
}