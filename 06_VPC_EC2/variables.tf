variable "shah_vpc_ip_addr" {
  default = "10.0.0.0"

}
variable "shah_public_subnet_ip_addr" {
  default = "10.0.1.0"

}
variable "shah_private_subnet_ip_addr" {
  default = "10.0.2.0"

}
variable "shah_rt_ip_addr" {
  default = "0.0.0.0"

}
variable "instance_type" {
  default = "t3.micro"

}
variable "http" {
  default = "80"

}
variable "https" {
  default = "443"

}
variable "ssh" {
  default = "22"

}