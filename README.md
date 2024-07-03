# This is a mess you can see it under this [PR](https://github.com/BenjoGreeno/oidc-oh-I-do-see/pull/1).

This is regrettably a mess/sub par/a work in progress. I'm messing with terraform and github actions, building a basic front end that is supposed to speak to a back end. The front end is live and with Cloudfront (hurray), however I don't have much experience in calling API's, much to my detriment.


Nothing is laid out gracefully, you can read the PR ([here](https://github.com/BenjoGreeno/oidc-oh-I-do-see/pull/1)) to see my notes on everything that's terrible, 

however you're morbidly curious and want to run this, please continue reading...

As this is just me, I"ve kept the Terraform backend local, so you'll need to have your aws credentials set up as per the 'aws configure' command. I have terraform cloud sert up and authenticated with OIDC (which I'll pipeline with Github Actions).

there are various defaults that you will need to change in variables.tf

- I created an image locally/separately and pushed it up to ECR to test.
- I added my own hosted zone and subdomains as defaults
- I also added some basic details for the global tags, again these are in variables.tf

---------------------------------------


The OK-sh things, security wise -

I've separated Private and Public subnets, nothing spectacular but I'm taking what I can.
I've enabled Origin Access Control (OAC, as ooposed to legacy OAI) with regards to authenticating with the S3 origin. I set the bucket to encrypt everything with KMS-SSE - this needed a custom KMS policy and was more of a faff figuring out than anticipated.
I made sure both the front end and the loadbalancer were covered with tls encryption against the subdomain addresses I'd set up.
the LB was set to only receive traffic from the cloudfront range, custom headers was on my list but not yet.

Once I figure out how the front end back ends talk to one another (probably an sg mishap + CORS) I'd ideally do the following in:

- Observability: get some performance metrics and set up some alarms based on cost and/or traffic
- Sort out building images and updating the task definition with Github actions
- Sort out the checkov vulns/advisories
- Sort out some proper testing in the pipeline.