data "aws_caller_identity" "current_account" {

}

data "aws_region" "current_region" {
}

output "account_id" {
  value = data.aws_caller_identity.current_account.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current_account.arn
}

output "user_id" {
  value = data.aws_caller_identity.current_account.user_id
}

output "region" {
  value = data.aws_region.current_region.region
}

output "region_endpoint" {
  value = data.aws_region.current_region.endpoint
}
