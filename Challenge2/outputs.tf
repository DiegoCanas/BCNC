output "copied_charts" {
  value = [for chart in var.charts_to_copy : chart.name]
  description = "List of copied Helm charts"
}
