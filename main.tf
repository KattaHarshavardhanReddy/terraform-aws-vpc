resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = "default"

  tags = merge (
    var.common_tags,
    {
        name = local.resource_name
    }
  )
}


# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id

#   tags = merge (
#     var.common_tags,
#     var.igw_tags,
#     {
#         name = local.resource_name
#     }
#   )
# }