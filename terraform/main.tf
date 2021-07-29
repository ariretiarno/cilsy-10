terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "aws-ari"
  region  = "us-east-2"
}

##Spot Instance
resource "aws_spot_instance_request" "spot_ari" {
  ami           = "ami-00399ec92321828f5"
  spot_price    = "0.025"
  instance_type = "t3a.large"
  key_name = "ari-key"

  tags = {
    Name = "spotAri"
  }
}

###Instance Biasa
#resource "aws_instance" "app_server" {
#  ami           = "ami-00399ec92321828f5"
#  instance_type = "t2.micro"
#  key_name = "ari-key"
#
#  tags = {
#    Name = "terraform"
#  }
#}

resource "aws_key_pair" "app_server" {
  key_name   = "ari-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuik0J20fsMcd6xutqU6lh+Qht9GOBRuLbJ9cEY3QRDlXCFwU4ITAxdk6ckYwfgENx/8/J57RdRS+YTSImZf/h0x284GLZli2fTv0xCqZ1wi2I86jsxWSijnCCmqncxh9tA8vtluN/Wx4lwUqngFyoPXsWqt6SfqdxE/Kq64jiu9u8XIDZLO9XbPbtJtjAc/xPCOaDEojNp5MKmsJaODMq2T99nXeINRMLrT/G/N4vmYGWeV578viIMEktJAxTTdeGTXiITbbsKxfNh3Ak+T5SrO/1tOc1rR00PttEklQHC4z4tw+3byooAsqX46SunWOc32hEM8jRcy3reeNXySCp retiarno@retiarno-hp"
}