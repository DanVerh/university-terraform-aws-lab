variable "authors" {}
variable "courses" {}

variable "policies" {
  type = map(object({
    path = string
    name = string
  }))

  default = {
    delete-course = {
      path      = "./policies/delete-course-policy.tftpl"
      name = "delete-course-policy"
    }
    get-all-courses = {
      path      = "./policies/get-all-courses-policy.tftpl"
      name = "get-all-courses-policy"
    },
    get-course = {
      path      = "./policies/get-course-policy.tftpl"
      name = "get-course-policy"
    },
    save-course = {
      path      = "./policies/save-course-policy.tftpl"
      name = "save-course-policy"
    }
  }
}