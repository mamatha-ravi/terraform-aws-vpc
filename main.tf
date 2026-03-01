# 1. Create a VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = local.vpc_final_tags
}

# 2. Create an Internet Gateway (IGW)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id #vpc association
  tags = local.igw_final_tags
}

# 3. Create a Public Subnet
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.az_names[count.index] # Specify an Availability Zone
  map_public_ip_on_launch = true         # Automatically assign public IPs to instances launched in this subnet

  tags = merge (
    local.common_tags,
    #roboshop-public-us-east-1a
  {
    Name = "${var.project}-public-${local.az_names[count.index]}"
  },
  var.public_subnet_tags
  )
}

