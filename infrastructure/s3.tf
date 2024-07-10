resource "aws_kms_key" "kms-fors3-encrypt" {
  description             = "Key for SSE "
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_key_policy" "cloudfront-grant" {
  key_id     = aws_kms_key.kms-fors3-encrypt.key_id
  depends_on = [aws_cloudfront_distribution.s3_distribution]
  policy     = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::906273274991:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "AllowCloudFrontServicePrincipalSSE-KMS",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::906273274991:root",
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey*"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
                }
            }
        }
    ]
}
EOF
}
# The bucket name matches the domain we're sticking on the CDN
resource "aws_s3_bucket" "testApp01-bucket" {
  bucket = var.domain_cloudfront
}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.testApp01-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-sse-encrypt" {
  bucket = aws_s3_bucket.testApp01-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms-fors3-encrypt.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.testApp01-bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

#upload website files to s3:
resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.testApp01-bucket.id
  for_each     = fileset("site-content", "*")
  key          = "site-content/${each.value}"
  source       = "site-content/${each.value}"
  etag         = filemd5("site-content/${each.value}")
  content_type = "text/html"
  depends_on = [
    aws_s3_bucket.testApp01-bucket
  ]
}