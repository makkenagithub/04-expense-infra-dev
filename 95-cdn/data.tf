data "aws_cloudfront_cache_policy" "noCache" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "cacheOptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "https_cert_arn" {

  name  = "/${var.project_name}/${var.env}/https_cert_arn"

}