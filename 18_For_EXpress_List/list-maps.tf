locals {
  user_map = {
    for user in var.users : user.username => user.role...
  }
  users_map2 = {
    for username, roles in local.user_map : username => { roles = roles }
  }

  usernames_from_map = [for username, roles in local.user_map : username]
}

output "user_map" {
  value = local.user_map
}

output "users_map2" {
  value = local.users_map2
}
output "users_name" {
  value = local.usernames_from_map
}
output "shah_roles" {
  value = local.users_map2[var.user_to_output].roles
}