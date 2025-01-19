provider "helm" {
    # Proveedor de helm3
}

module "copy_helm_charts" {
  source            = "./modules/copy_helm_charts"
  for_each          = { for chart in var.charts_to_copy : chart.name => chart }
  chart_name        = each.value.name
  chart_version     = each.value.version
  reference_registry = var.reference_registry
  instance_registry  = var.instance_registry
}
