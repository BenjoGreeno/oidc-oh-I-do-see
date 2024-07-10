# data source to generate bucket policy to let OAI get objects:
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.testApp01-bucket.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      values   = ["${aws_cloudfront_distribution.s3_distribution.arn}"]
      variable = "aws:SourceArn"
    }
  }
}
# data source to fetch hosted zone info from domain name:
data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone
  private_zone = false
}

data "aws_availability_zones" "available" {}

# data "aws_route53_zone" "domain_lb" {
#   name         = var.domain_cloudfront
#   private_zone = false
# }