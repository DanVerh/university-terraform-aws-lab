variable "naming" {}
variable "role_arn" {}
variable "role_name" {}
variable "email" {}

variable "error_function" {
  type = map(string)

  default = {
    filename      = "./functions/error.zip"
    function_name = "error"
  }
}

variable "authors_parent" {
  type = map(string)
}

variable "courses_parent" {
  type = map(object({
    name = string
    arn = string
    method = string
  }))
}

variable "courses_child" {
  type = map(object({
    name = string
    arn = string
    method = string
  }))
}
