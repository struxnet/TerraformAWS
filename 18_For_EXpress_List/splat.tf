locals {
  firstnames_from_splat = var.objects_list[*].firstname
  roles_from_splat = values(local.users_map2)[*].roles
}

output "firstname_from_splat" {
  value = local.firstnames_from_splat

}