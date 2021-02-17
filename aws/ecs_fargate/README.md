# Datadog Private Location Hosting in AWS ECS Fargate

## Introduction

Datadog allows for running synthetic API and browser automation tests within your internal, private network using a feature called [Private Locations](https://docs.datadoghq.com/synthetics/private_locations?tab=docker). In this Terraform project, I deploy the official `datadog/synthetics-private-location-worker` Docker image to AWS ECS Fargate, enabling Private Locations within my AWS VPC environment. I used [this repository](https://github.com/guillermo-musumeci/terraform-ecs-fargate) for inspiration.

## Implementation

### Step 1: Create an IAM account and named profile

I created a new IAM account for this project and saved the access key ID and secret access key to the `~/.aws/credentials` file as a new named profile. You will use the named profile in the Terraform configuration file later.

### Step 2: Create key pair and PEM file

Go to the [EC2 Key Pairs](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:) configuration in the AWS Console. Create a new key pair, specifying the file format as *PEM*. In this example, I named my new key pair `datadog-private-locations-key-pair` and saved the key pair to my computer at `~/.ssh/datadog-private-locations-key-pair.pem`.

### Step 3: Create terraform.tfvars file

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


### Step 4: Obtain the Datadog Private Locations configuration

Go to the [Datadog Private Locations](https://app.datadoghq.com/synthetics/settings/private-locations) configuration page and add a new private location. Save the configuration to your computer. You will need this for the next step.

### Step 5: Create the container_definitions.json file

Go to `modules/ecs-fargate-service` directory and create a new `container_definitions.json` file. Use the `template_container_definitions.json` file as the initial file contents. Replace the `command` entries content with the values that you obtained in the previous step when creating a new private location in Datadog. 

### Step 6: Initialize and run Terraform

```shell
terraform init

terraform plan

terraform apply
```

### Debugging issues


#### List the stopped tasks from the AWS CLI

```shell
aws ecs list-tasks --cluster datadog-private-locations --desired-status STOPPED --region us-east-1 --profile MyNamedProile
```

#### Show details on a specific task from the AWS CLI

```shell
aws ecs describe-tasks --cluster datadog-private-locations --tasks arn:aws:ecs:us-east-1:999999999999:task/datadog-private-locations/xxxxxxxxxxxxxxxxxxx --region us-east-1 --profile MyNamedProile
```




