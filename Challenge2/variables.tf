variable "reference_registry" {
  type        = string
  default     = "reference.gcr.io"
  description = "Reference Artifact Registry URL"
}

variable "instance_registry" {
  type        = string
  default     = "instance.gcr.io"
  description = "Instance Artifact Registry URL"
}

variable "charts_to_copy" {
  type = list(object({
    name    = string
    version = string
  }))
  description = "List of Helm charts to copy"
}
