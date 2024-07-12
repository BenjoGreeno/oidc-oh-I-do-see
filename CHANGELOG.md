# Changelog

### 2024-07-12
I've made a bunch of further changes & tidy up, however some important notes:
- i've changed the provider to be Terraform Cloud (authenticated with OIDC)
- I've added the terraform cloud trigger as a Github actions stage.
- made some SG changes as I think missed a few things
- I had public IP's where there shouldn't have been any


### 2024-07-04
- some tidy up
- added versioning to the bucket
- some work on the SG comms between the lb and ecs.

### 2024-07-03
**First draft and a bit of a frankenstein of stuff, this is no oil painting and needs a lot of work.**
Terraform instructions for a bunch of stuff create, such as
- S3 bucket and policy, with a method of uploading - encrypted with KMS SSE.
- cloudfront distribution pointing to above s3 as origin OAC enabled, which is permitted with a custom kms key/policy
- network side of things set up - VPC, SG's private & public subnets with their corresponding routes.
- ECS cluster & service - I've not got sorted method of authenticating and uploading to ECR yet.
- Certificates and domains to go in front of the lb and cloudfront distribution.

