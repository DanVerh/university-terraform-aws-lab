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

variable "authors_parent" {
  type = map(string)

  default = {
    filename      = "./functions/get-all-authors.zip"
    function_name = "get-all-authors"
    method = "GET"
  }
}

variable "courses_parent" {
  type = map(object({
    filename = string
    function_name = string
    method = string
  }))

  default = {
    get-all-courses = {
      filename      = "./functions/get-all-courses.zip"
      function_name = "get-all-courses"
      method = "GET"
    },
    save-course = {
      filename      = "./functions/save-course.zip"
      function_name = "save-course"
      method = "POST"
    }
  }
}

variable "courses_child" {
  type = map(object({
    filename = string
    function_name = string
    method = string
  }))
  default = {
    delete-course = {
      filename      = "./functions/delete-course.zip"
      function_name = "delete-course"
      method = "DELETE"
    },
    get-course = {
      filename      = "./functions/get-course.zip"
      function_name = "get-course"
      method = "GET"
    },
    update-course = {
      filename      = "./functions/update-course.zip"
      function_name = "update-course"
      method = "PUT"
    }
  }
}