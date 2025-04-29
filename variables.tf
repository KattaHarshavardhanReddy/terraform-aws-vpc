variable "project_name" {

}

variable "env" {

}

variable "vpc_cidr" {

}

variable "enable_dns_hostnames" {
    default = true
}

variable "common_tags"{
    type = map
#default = {}
}

variable "igw_tags" {
    default = {}
}

variable "public_subnet_cidr" {
    type = list 
    validation {
    condition     = length(var.public_subnet_cidr) == 2 
    error_message = "please add 2 subnet id"
  }

}

variable "public_subnet_tags" {
    default = {}
}

variable "private_subnet_cidr" {
    type = list 
    validation {
    condition     = length(var.private_subnet_cidr) == 2 
    error_message = "please add 2 subnet id"
  }

}

variable "private_subnet_tags" {
    default = {}
}

variable "nat_tags" {
    default = {}
}

variable "route_table_public" {
    default = {}
}

variable "route_table_private" {
    default = {}
}