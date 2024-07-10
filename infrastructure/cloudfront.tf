
resource "aws_cloudfront_origin_access_control" "testApp01" {
  name                              = var.app-stack
  description                       = "Access KMS encrypted S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "${var.app-stack}-s3origin"
}

resource "random_password" "custom_header" {
  length      = 13
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on          = [aws_cloudfront_origin_access_control.testApp01]
  default_root_object = "index.html"
  origin {
    domain_name              = aws_s3_bucket.testApp01-bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_path              = "/site-content"
    origin_access_control_id = aws_cloudfront_origin_access_control.testApp01.id
  }

  aliases = ["${var.domain_cloudfront}", "www.${var.domain_cloudfront}"]

  enabled = true
  comment = "${var.app-stack} CDN"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.testApp01-bucket
    prefix          = cloufront-logs
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.wildcard-cloudfront.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }
}