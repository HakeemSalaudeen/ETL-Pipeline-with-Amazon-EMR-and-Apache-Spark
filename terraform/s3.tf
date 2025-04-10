# resource "aws_s3_bucket" "emr-bucket" {
#   bucket = "emr-bucket"
# }

resource "aws_s3_bucket" "emr-datalake" {
  bucket = "emr-datalake"
}

# Create the input folder
resource "aws_s3_object" "input-folder" {
  bucket = aws_s3_bucket.emr-datalake.bucket
  key    = "input-folder/"
}

# Create the log folder
resource "aws_s3_object" "log-folder" {
  bucket = aws_s3_bucket.emr-datalake.bucket
  key    = "log-folder/"
}

# Create the output folder
resource "aws_s3_object" "output-folder" {
  bucket = aws_s3_bucket.emr-datalake.bucket
  key    = "output-folder/"
}