resource "aws_s3_bucket" "s3-bucket-01" {
  bucket = var.code_s3_name
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
   tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-s3-wp-code-ts"
  }
}
resource "aws_s3_bucket" "s3-bucket-02" {
  bucket = var.media_s3_name
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal":"*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::s3-wp-media-ts/*"
         } 
  ]
}
POLICY

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-s3-wp-media-ts"
  }
}


resource "aws_cloudfront_distribution" "s3_distribution" {
//depends_on = [ aws_cloudfront_origin_access_identity.cloudfront_oai_wp_01 ]
  origin {
    domain_name = "${var.media_s3_name}.s3.amazonaws.com"
    origin_id   = var.media_s3_name //local.s3_origin_id
  /*
    s3_origin_config {
      origin_access_identity = "cloudfront_oai_wp_01"
    }*/
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
/*
  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }*/

  //aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.media_s3_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0 
 
 ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.media_s3_name

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.media_s3_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "PL"]
    }
  }

 tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-cloudfront_01"
    Description = "CloudFront Distribution"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn = "arn:aws:acm:us-east-1:890769921003:certificate/1033d907-8cac-43f3-b845-11ee02d43f72"
    ssl_support_method = "sni-only"
  }
}

