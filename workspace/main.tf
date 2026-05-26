resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_name = "${var.project_name}-${var.region}-${random_id.suffix.hex}"
  tags = merge({
    managed_by = "terraform"
  }, var.tags)
}

resource "aws_s3_bucket" "website" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags          = local.tags
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  content_type = "text/html; charset=utf-8"
  content      = <<-HTML
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8" />
        <title>Demo Static Website</title>
      </head>
      <body>
        <h1>It works.</h1>
        <p>This page was deployed by Terraform.</p>
      </body>
    </html>
  HTML
}

data "aws_iam_policy_document" "website_public_read" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.website.arn}/*",
    ]
  }
}

resource "time_sleep" "public_access_propagation" {
  depends_on      = [aws_s3_bucket_public_access_block.website]
  create_duration = "10s"
}

resource "aws_s3_bucket_policy" "website_public_read" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website_public_read.json

  depends_on = [time_sleep.public_access_propagation]
}
