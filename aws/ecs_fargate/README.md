# Datadog Private Location Hosting in AWS ECS Fargate



## Introduction

Datadog allows for running synthetic API and browser automation tests within your internal, private network using a feature called [Private Locations](https://docs.datadoghq.com/synthetics/private_locations?tab=docker). In this Terraform project, I deploy the official `datadog/synthetics-private-location-worker` Docker image to AWS ECS Fargate, enabling Private Locations within my AWS VPC environment. 

## Implementation

### Step 1: Create an IAM account and named profile

I created a new IAM account for this project and saved the access key ID and secret access key to the `~/.aws/credentials` file as a new named profile. You will use the named profile in the Terraform configuration file later.

### Step 2: Create key pair and PEM file

Go to the [EC2 Key Pairs](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:) configuration in the AWS Console. Create a new key pair, specifying the file format as *PEM*. In this example, I named my new key pair `datadog-private-locations-key-pair` and saved the key pair to my computer at `~/.ssh/datadog-private-locations-key-pair.pem`.

### Step 1: Create terraform.tfvars file

Create the `terraform.tfvars` file in root project directory with the following contents:

```properties
aws_region        = "" # Set the AWS region you want to use.
aws_named_profile = "" # Set the named profile for the IAM user to use.
aws_shared_credentials_file = "~/.aws/credentials"

app_name = "datadog-private-locations"
app_environment = "dev"

aws_key_pair_name = "datadog-private-locations-key-pair"
aws_key_pair_file = "~/.ssh/datadog-private-locations-key-pair.pem"

# Application access
app_sources_cidr_list   = ["0.0.0.0/0"]  # Specify a list of IPv4 IPs/CIDRs which can access app load balancers
admin_sources_cidr_list = ["0.0.0.0/0"]    # Specify a list of IPv4 IPs/CIDRs which can admin instances

container_name = "datadog-private-locations-container"
ecs_fargate_service_name_prefix = "dpl"

task_fargate_cpu = 512
task_fargate_memory = 1024
```



## Conclusions


