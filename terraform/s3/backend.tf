terraform {
  backend "s3" {
    bucket       = "terraform-lockstate-frankfurt"
    key          = "terraform/cloud-resume/s3"
    region       = "eu-central-1"
    use_lockfile = true

  }
}
