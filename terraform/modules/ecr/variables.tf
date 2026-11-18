
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition = contains(
      ["MUTABLE", "IMMUTABLE"],
      var.image_tag_mutability
    )
    error_message = "Image tag mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
