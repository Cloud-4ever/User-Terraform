resource "aws_s3_bucket" "images" {
  bucket = "shopeasy-image-bucket-c4-easyshop-review-image" 
}

resource "aws_s3_bucket" "static_assets" {
  bucket = "shopeasy-static-bucket-c4-easyshop-assets" 
}