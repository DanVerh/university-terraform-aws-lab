variable "role_arn" {}
variable "role_name" {}

variable "error_function" {
  type = map(string)

  default = {
    filename      = "./functions/error.zip"
    function_name = "error"
  }
}