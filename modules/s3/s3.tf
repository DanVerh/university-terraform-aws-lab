locals {
    server_url = templatefile("serverUrl.js.tftpl", { apiurl = var.api_url })
}

resource "null_resource" "local" {
  triggers = {
    template = local.server_url
  }

  provisioner "local-exec" {
    command = format(
      "cat <<\"EOF\" > \"%s\"\n%s\nEOF",
      "./website/src/api/serverUrl.js",
      local.server_url
    )
  }
}

resource "aws_s3_bucket" "website_s3" {
  bucket = "danverh"

  provisioner "local-exec" {
    command = <<EOF
      cd website
      npm install
      npm run build
    EOF
  }
}

resource "aws_s3_bucket_website_configuration" "website_s3_config" {
  bucket = aws_s3_bucket.website_s3.bucket
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_s3.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.website_s3.id}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset("./website/build", "**/*")
  acl    = "public-read"
  bucket = aws_s3_bucket.website_s3.id
  key    = each.key

  source = "./website/build/${each.key}"

  depends_on = [ aws_s3_bucket_policy.website_policy ]
}