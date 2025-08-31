/* 1. Remove through CLI
remove through Remove block
*/


resource "aws_s3_bucket" "name" {
 bucket = "random-bucket-name-789098877"
}
/* 2. Remove through CLI
remove through Remove block
*/

removed {
  from = aws_s3_bucket.name
  lifecycle {
    destroy = false
  }
}