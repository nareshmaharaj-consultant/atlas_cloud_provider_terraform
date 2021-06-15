# user key projectID
# qvesfrig "09386271-6e34-4e93-9250-55c25dab8083" 60ab6ed5fb4a1f43c4950e71

variable "mongodb_atlas_api_pub_key" {
 default = "qvesfrig"
}

variable "mongodb_atlas_api_pri_key" {
 default = "enter your private key"
}

variable "mongodb_atlas_project_id" {
 default = "60ab6ed5fb4a1f43c4950e71"
}

variable "atlas_project_name" {
  type        = string
  description = "Name of the Atlas project the role is associated with"
  default     = "my-atlas"
}

variable "account_name" {
  type        = string
  description = "Name of the AWS account.  Used as a name prefix"
  default     =  "naresh.maharaj"
}

variable "tags" {
  type        = map(string)
  description = "Key/value pairs of additional information attached to resources"
  default     = {}
}

variable "atlas_aws_root_account_id" {
  type        = number
  description = "Atlas AWS root account ARN IAM account id"
  default     = "536727724300"
}

variable "aws_root_account_id" {
  type        = number
  description = "Atlas AWS root account ARN IAM account id"
  default     = "521195893806"
}

variable "atlas_external_ids" {
  type        = list(any)
  description = "List of unique external IDs (per-Atlas project)"
  default     = [1, 2]
}

