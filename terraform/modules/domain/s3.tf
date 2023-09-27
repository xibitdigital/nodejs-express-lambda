resource "aws_s3_bucket" "truststore" {
  bucket = "${random_pet.this.id}-truststore"
  #  acl    = "private"
}

resource "aws_s3_object" "truststore" {
  bucket                 = aws_s3_bucket.truststore.bucket
  key                    = "truststore.pem"
  server_side_encryption = "AES256"
  content                = tls_self_signed_cert.example.cert_pem
}
