provider "helm" {
  // Configured Helm provider
}

module "copy_charts" {
  source = "./copy_helm_charts"

  charts_to_copy = [
    {
      name    = "chart-1"
      version = "1.2.3"
    },
    {
      name    = "chart-2"
      version = "1.2.3"
    }
  ]
}