## Set up DNS service i.e AWS route 53

## look up created hosted zone on aws
data "aws_route53_zone" "dns" {
  name = var.domain_name
}

# create SSL certificate 
resource "aws_acm_certificate" "ssl" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

## create DNS record for ACM certificate
resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.ssl.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.ssl.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.dns.id
  ttl             = 60
}

## Validates ACM certificate
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.ssl.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

## Creates standard route53 record poiinting to alb

# create A record for subdomain
resource "aws_route53_record" "terraform_test_domain" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "terraform-test.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.project_load_balancer.dns_name
    zone_id                = aws_lb.project_load_balancer.zone_id
    evaluate_target_health = true
  }
}

# create A record for domain
resource "aws_route53_record" "my_domain" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.project_load_balancer.dns_name
    zone_id                = aws_lb.project_load_balancer.zone_id
    evaluate_target_health = true
  }
}
