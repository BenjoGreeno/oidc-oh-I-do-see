# This is a mess.

Edit: I've been making some changes, which you can see as per the changelog doc, or the PR merges, so spme of the below may have changed

This is regrettably a mess/sub par/a work in progress. I'm messing with terraform and github actions, building a basic front end that is supposed to speak to a back end. The front end deploys and with Cloudfront (hurray), however I don't have much experience in calling API's, much to my detriment. He's some detail

- front end with Cloudfront is sorted, but it's not set to call anything in the back end.
- All the networking stuff is deployed- VPC, subnets, SG's etc etc
- I've set up the ECS cluster and service, but my sample app isn't reachable, this is going to be something daft as it's a 504.
- No modules set up, which I was wanting to do to split the account types (Dev, QA, prod)
- I'll crack on with documentation
- No logging / observability
- I've started on the pipeline, but just added checkov as a github actions stage. I've set up OIDC for authentication

### Some steps
if you're morbidly curious and want to run this, please continue reading...

from the infrastructure folder, run the following:

terraform init
terraform plan (if you want to see what it's intention is)
terraform apply (--auto-approve if you feel spicy)

As this is just me, I"ve kept the Terraform backend local, so you'll need to have your aws credentials set up as per the 'aws configure' command. I have terraform cloud set up and authenticated with OIDC (which I'll pipeline with Github Actions).

there are various defaults that you will need to change in variables.tf

- I created an image locally/separately and pushed it up to ECR to test.
- I added my own hosted zone and subdomains as defaults
- I also added some basic details for the global tags, again these are in variables.tf
- i've limited the Cloudfront region to the lowest one, which was UK/US, for money saving and reduction of attack surface whilst testing.

---------------------------------------


### The OK-sh things, security wise -

I've separated Private and Public subnets, nothing spectacular but I'm taking what I can.
I've enabled Origin Access Control (OAC, as ooposed to legacy OAI) with regards to authenticating with the S3 origin. I set the bucket to encrypt everything with KMS-SSE - this needed a custom KMS policy and was more of a faff figuring out than anticipated.
I made sure both the front end and the loadbalancer were covered with tls encryption against the subdomain addresses I'd set up.
the LB was set to only receive traffic from the cloudfront range, custom headers was on my list but not yet.


### To Do
Once I figure out how the front end back ends talk to one another (probably an sg mishap + CORS) I'd ideally do the following in:

- add a WAF
- Add custom headers
- Observability: get some performance metrics and set up some alarms based on cost and/or traffic
- Sort out building images and updating the task definition with Github actions
- Sort out the checkov vulns/advisories
- Sort out some proper testing in the pipeline.

References - I've used a bunch of resources online as I waded through the ask. I definitely feel temporarily pretty defeated, regrettably.

[Nextgeneerz](https://github.com/nexgeneerz/aws-scenario-ecs-ec2/tree/main)
[Dev.tO](https://dev.to/)
[spacelift.io](https://spacelift.io/)

and no doubt many more, but the above were really useful and had a bunch of workable examples I've worked with (besides the terraform site)

