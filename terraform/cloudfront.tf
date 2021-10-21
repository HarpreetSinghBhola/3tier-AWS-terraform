resource "aws_cloudfront_distribution" "web-cdn" {
  origin {
    domain_name = aws_lb.web_servers.dns_name
    origin_id   = "web-cdn"
    custom_origin_config {
      http_port      = "80"
      https_port     = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = false

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "web-cdn"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    compress = true
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags = {
    Name = "web-cdn"
  }
}

output "WEB-CDN" {
  value = aws_cloudfront_distribution.web-cdn.domain_name
}

output "WEB-CDN-ID" {
  value = aws_cloudfront_distribution.web-cdn.id
}