# resource "aws_s3_bucket" "emr-bucket" {
#   bucket = "emr-bucket"
# }

resource "aws_s3_bucket" "emr-datalake" {
  bucket = "emr-datalake"
}