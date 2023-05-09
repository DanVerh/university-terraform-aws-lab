resource "aws_s3_bucket" "website_s3" {
  bucket = "danverh"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }

  provisioner "local-exec" {
    command = <<EOF
      echo "Running templatefile"
      templatefile("./website/src/api/serverUrl.tftpl", {
        apiurl = "${var.api_url}"
      })

      echo "Running local commands"
      cd website
      npm install
      npm run build
    EOF
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

  bucket = aws_s3_bucket.website_s3.id
  key    = each.key

  source = "/website/build/${each.key}"
}