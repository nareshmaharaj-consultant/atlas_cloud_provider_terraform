terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.9.1"
    }
  }
}

provider "mongodbatlas" {
  # Configuration options
  public_key  = var.mongodb_atlas_api_pub_key
  private_key = var.mongodb_atlas_api_pri_key
}

resource "mongodbatlas_cloud_provider_access" "test_role" {
  project_id    = "${var.mongodb_atlas_project_id}"
  provider_name = "AWS"
}

data "aws_iam_policy_document" "atlas-assume-role-policy" {
  statement {
    sid     = "rolepolicy"
    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${mongodbatlas_cloud_provider_access.test_role.atlas_assumed_role_external_id}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.atlas_aws_root_account_id}:root"]
    }

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "atlas-cmk-access-role" {
  name               = "${var.account_name}-atlas-cmk-${var.atlas_project_name}-role"
  tags               = merge({ "Name" = "${var.account_name}-atlas-cmk-role" }, var.tags)
  assume_role_policy = data.aws_iam_policy_document.atlas-assume-role-policy.json
}

resource "mongodbatlas_cloud_provider_access_authorization" "auth_role" {
   project_id =  mongodbatlas_cloud_provider_access.test_role.project_id
   role_id    =  mongodbatlas_cloud_provider_access.test_role.role_id

   aws = {
      iam_assumed_role_arn = "arn:aws:iam::${var.aws_root_account_id}:role/${var.account_name}-atlas-cmk-${var.atlas_project_name}-role"
   }
}


output "atlas_assumed_role_external_id" {
  value = mongodbatlas_cloud_provider_access.test_role.atlas_assumed_role_external_id
}
