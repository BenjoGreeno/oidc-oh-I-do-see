
#Two lots of cert validation as I have to create one in two regions - Cloudfront requires a specific us-region.
# validate cert:
resource "aws_acm_certificate" "wildcard-cloudfront" {
  domain_name               = var.domain_cloudfront
  provider                = aws.cdn
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_cloudfront}"]
  
lifecycle {
create_before_destroy = true
}
}

resource "aws_acm_certificate" "wildcard-backend" {
  domain_name               = var.domain_alb
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_alb}"]
  
lifecycle {
create_before_destroy = true
}
}

resource "aws_route53_record" "cert-validation-cloudfront" {
  for_each = {
    for d in aws_acm_certificate.wildcard-cloudfront.domain_validation_options : d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}
resource "aws_acm_certificate_validation" "cert-validation-cloudfront" {
  provider                = aws.cdn
  certificate_arn         = aws_acm_certificate.wildcard-cloudfront.arn
  validation_record_fqdns = [for r in aws_route53_record.cert-validation-cloudfront : r.fqdn]
}

##################################Load Balancer Cert ########################################

resource "aws_acm_certificate" "wildcard-lb" {
  domain_name               = var.domain_alb
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_alb}"]
  lifecycle {
create_before_destroy = true
}
}

resource "aws_route53_record" "cert-validation-lb" {
  for_each = {
    for d in aws_acm_certificate.wildcard-backend.domain_validation_options : d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}
resource "aws_acm_certificate_validation" "cert-validation-alb" {
  certificate_arn         = aws_acm_certificate.wildcard-lb.arn
  validation_record_fqdns = [for r in aws_route53_record.cert-validation-lb : r.fqdn]
}


# # validate cert:
# resource "aws_route53_record" "cert-validation" {
#   for_each = {
#     for d in aws_acm_certificate.bengreen-cert.domain_validation_options : d.domain_name => {
#       name   = d.resource_record_name
#       record = d.resource_record_value
#       type   = d.resource_record_type
#     }
#   }
#   provider        = aws.cdn
#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.hosted_zone.zone_id

# Point records to their alias endpoints:
resource "aws_route53_record" "cloudfront-domain" {
  name    = var.domain_cloudfront
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb-domain" {
  name    = var.domain_alb
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  type    = "A"
  alias {
    name                   = aws_lb.ecs_lb.dns_name
    zone_id                = aws_lb.ecs_lb.zone_id
    evaluate_target_health = true
  }
}