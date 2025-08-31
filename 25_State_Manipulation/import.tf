/* import via CLI
import via IMPORT block
*/

resource "aws_s3_bucket" "remote_state" {
    bucket = "shah-terraform-state-bucket-aws"
  
}


