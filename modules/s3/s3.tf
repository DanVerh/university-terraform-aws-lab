locals {
    server_url = templatefile("./website-templates/serverUrl.js.tftpl", { apiurl = var.api_url })
    website_url = templatefile("./website-templates/package.json.tftpl", { bucket = aws_s3_bucket.website.bucket, region = "us-east-1" })
}

resource "null_resource" "local" {
  triggers = {
    template1 = local.server_url
    template2 = local.website_url
  }

  depends_on = [ aws_s3_bucket.website ]
}

resource "aws_s3_bucket" "website" {
  bucket = "danverh"
}


resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }

  provisioner "local-exec" {
    command = <<EOF
      echo '${local.server_url}' > ./website/src/api/serverUrl.js
      echo '${local.website_url}' > ./website/package.json
      cd website
      npm install
      npm run build
    EOF
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.website.id}/*"
    }
  ]
}
EOF
}

locals {
  content_type_map = {
   "js" = "text/javascript"
   "html" = "text/html"
   "css"  = "text/css"
  }
}

resource "aws_s3_bucket_object" "website" {
  for_each = fileset("./website/build", "**/*")
  acl    = "public-read"
  bucket = aws_s3_bucket.website.id
  #key    = each.key
  key    = each.value
  #source = "./website/build/${each.key}"
  source = "./website/build/${each.value}"

  #content_type = "text/html"
  content_type = lookup(local.content_type_map, split(".", "./website/build/${each.value}")[length(split(".", "./website/build/${each.value}")) - 1], "text/html")

  depends_on = [ aws_s3_bucket_acl.website, aws_s3_bucket_website_configuration.website ]
}
