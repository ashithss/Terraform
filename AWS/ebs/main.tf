resource "aws_ebs_volume" "ebs" {
    availability_zone = var.availability_zone
    encrypted = var.encrypted
    iops = var.iops
    size = var.size
    snapshot_id = var.snapshot_id
    type = var.volume_type

    kms_key_id = var.kms_key_id
    tags = var.tags
}
provider "aws" {
  region     = "var.aws_region"
# access_key = ""
#  secret_key = ""
}


# Configure the AWS Provider
provider "aws" {
region = "ap-south-1"
#access_key = ""
#secret_key = ""
}

##################Running#################################
#step 1
# create a resource for ec2 instance 
resource "aws_instance" "TFuser1_os1" {
ami = "ami-010aff33ed5991201"
instance_type ="t2.micro"
tags = {
  Name = "NEW OS"
 } 
}

#optional print the detail of OS1
output "EC2Output"{
value = aws_instance.TFuser1_os1
}

#step 2
#create a resource from EBS volume in same AZ as os1
resource "aws_ebs_volume" "TFebs1"{
 availability_zone = aws_instance.TFuser1_os1.availability_zone 
 size = 1
 tags = {
  Name = "Extra_EBS"
 }
}

#optional
#print the ebs volume details
output "EBSOutput"{
value = aws_ebs_volume.TFebs1
}

#step 3 
#attach volume
resource "aws_volume_attachment" "attach_ebs_1"{
device_name = "/dev/sdh"
volume_id = aws_ebs_volume.TFebs1.id
instance_id =aws_instance.TFuser1_os1.id
}

#access_key = ""
#  secret_key = ""