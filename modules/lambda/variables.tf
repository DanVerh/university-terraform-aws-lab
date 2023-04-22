variable "role" {}

variable "archive_functions" {
  type = map(object({
    source_file = string
    output_path = string
  }))

  default = {
    delete-course = {
      source_file = "./functions/delete-course/index.js"
      output_path = "./functions/delete-course.zip"
    },
    get-all-authors = {
      source_file = "./functions/get-all-authors/index.js"
      output_path = "./functions/get-all-authors.zip"
    },
    get-all-courses = {
      source_file = "./functions/get-all-courses/index.js"
      output_path = "./functions/get-all-courses.zip"
    },
    get-course = {
      source_file = "./functions/get-course/index.js"
      output_path = "./functions/get-course.zip"
    }
    save-course = {
      source_file = "./functions/save-course/index.js"
      output_path = "./functions/save-course.zip"
    },
    update-course = {
      source_file = "./functions/update-course/index.js"
      output_path = "./functions/update-course.zip"
    }
  }
}