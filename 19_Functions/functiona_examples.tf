locals {
  name = "Ammar Shah"
  age  = 25
  my_object = {
    key1 = "value1"
    key2 = "value2"
  }
}

output "example1" {
  value = startswith(local.name, "am")

}

output "example2" {
  value = pow(local.age, 3)

}

output "example3" {
  value = yamldecode(file("${path.module}/users.yaml")).users[*].name

}

output "example4" {
  value = yamlencode(local.my_object)

}