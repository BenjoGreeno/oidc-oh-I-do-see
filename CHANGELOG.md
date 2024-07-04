# Changelog

### 2024-07-03
- some tidy up
- added versioning to the bucket

### 2024-07-03
**First draft and a bit of a frankenstein of stuff, this is no oil painting and needs a lot of work.**
Terraform instructions for a bunch of stuff create, such as
- S3 bucket and policy, with a method of uploading - encrypted with KMS SSE.
- cloudfront distribution pointing to above s3 as origin OAC enabled, which is permitted with a custom kms key/policy
- network side of things set up - VPC, SG's private & public subnets with their corresponding routes.
- ECS cluster & service - I've not got sorted method of authenticating and uploading to ECR yet.
- Certificates and domains to go in front of the lb and cloudfront distribution.
