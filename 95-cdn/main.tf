

resource "aws_cloudfront_distribution" "expense_cdn" {
  origin {
    domain_name              = "expense-dev.daws81s.online"
    origin_id                = "expense-dev.daws81s.online"
    custom_origin_config {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols = ["TLSv1.2"]
    }

  }

  enabled = true

  aliases = ["expense-cdn.daws81s.online"]

  # dynamic content evaluated at last no cache
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "expense-dev.daws81s.online"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

     cache_policy_id = data.aws_cloudfront_cache_policy.noCache.id

  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "expense-dev.daws81s.online"


    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id = data.cacheOptimized.cacheOptimized.id
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/video/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "expense-dev.daws81s.online"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
     cache_policy_id = data.cacheOptimized.cacheOptimized.id
  }

    # we can restrict the url to open in certain countries
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "IN"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn = local.https_cert_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = "daws81s.online"

  records = [
    {
      name    = "expense-cdn"
      type    = "A"
      allow_overwrite= true
      alias   = {
        name    = aws_cloudfront_distribution.expense_cdn.domain_name
        zone_id = aws_cloudfront_distribution.expense_cdn.hosted_zone_id
        # it is CDN internal hosted zone id

      }
    }

  ]

}