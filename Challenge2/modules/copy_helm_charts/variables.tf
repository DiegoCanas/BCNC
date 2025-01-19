variable "chart_name" {
  type        = string
  description = "Name of the Helm chart to copy"
}

variable "chart_version" {
  type        = string
  description = "Version of the Helm chart to copy"
}

variable "reference_registry" {
  type        = string
  description = "Source registry URL for the Helm chart"
}

variable "instance_registry" {
  type        = string
  description = "Destination registry URL for the Helm chart"
}
