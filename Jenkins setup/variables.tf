variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "vpc_subnet" {
  type = list(string)

}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}