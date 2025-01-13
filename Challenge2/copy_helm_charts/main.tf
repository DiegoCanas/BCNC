variable "reference_registry" {
  type = string
  default = "reference.gcr.io"
  description = "Reference Artifact Registry URL"
}

variable "instance_registry" {
  type = string
  default = "instance.gcr.io"
  description = "Instance Artifact Registry URL"
}

variable "charts_to_copy" {
  type = list(object({
    name    = string
    version = string
  }))
  description = "List of Helm charts to copy"
}

resource "null_resource" "copy_helm_charts" {
  for_each = toset([for chart in var.charts_to_copy : "${chart.name}-${chart.version}"])

  provisioner "local-exec" {
    command = <<EOT
      helm3 pull ${var.reference_registry}/${element(split("-", each.key), 0)} --version ${element(split("-", each.key), 1)}
      helm3 push ${element(split("-", each.key), 0)}-${element(split("-", each.key), 1)}.tgz ${var.instance_registry}
    EOT
    interpreter = ["bash", "-c"]
  }
}