variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = "vpc-0aa58eaabb536e7d3"
}

variable "ex_role_arn" {
    description = "The arn of execution role"
    type        = string
    default     = "arn:aws:iam::255945442255:role/ecsTaskExecutionRole"
}

variable "sg_id" {
    description = "The security group id"
    type        = string
    default     = "sg-0d27b7c2a485d0c74"
}
