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

#variable "courses_child" {
  #type = map(object({
    #name = string
    #arn = string
    #method = string
  #}))
#}
