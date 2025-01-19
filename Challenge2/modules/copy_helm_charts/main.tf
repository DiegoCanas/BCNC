resource "null_resource" "copy_chart" {
  provisioner "local-exec" {
    command = <<EOT
      helm3 pull ${var.reference_registry}/${var.chart_name} --version ${var.chart_version}
      helm3 push ${var.chart_name}-${var.chart_version}.tgz ${var.instance_registry}
    EOT
    interpreter = ["bash", "-c"]
  }

  triggers = {
    chart_name        = var.chart_name
    chart_version     = var.chart_version
    reference_registry = var.reference_registry
    instance_registry  = var.instance_registry
  }
}
