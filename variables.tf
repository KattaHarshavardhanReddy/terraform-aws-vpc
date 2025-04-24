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

# variable "igw_tags" {
#     default = {}
# }