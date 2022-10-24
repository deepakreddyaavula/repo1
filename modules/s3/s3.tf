# create a randon string for bucket name
resource "random_id" "random" {
  byte_length = 4
}

# create bucket
resource "aws_s3_bucket" "bucket" {
  bucket = random_id.random.hex

  tags = {
    Name        = "My bucket"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

# ecnrypt s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "ecnrypt" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


# create bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.bucket.arn
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]

    }
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::*"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.bucket.arn
    ]
  }
}
