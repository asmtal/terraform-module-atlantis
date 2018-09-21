resource "github_repository_webhook" "atlantis_github_webhook" {
  configuration {
    url          = "${var.github_repository_webhook_url}"
    content_type = "form"
    insecure_ssl = "${var.github_repository_webhook_insecure_ssl}"
  }

  active = true

  events = "${var.github_repository_webhook_events}"
}

data "github_access_token" {
  description = "Access token so atlantis can talk to Github. Token requires a `repo` scope"
}

resource "atlantis_manifest_deploy_k8s" {
  description = "Resource that deploys atlantis on kubernetes. From: https://www.runatlantis.io/docs/deployment.html#start-atlantis and https://www.runatlantis.io/docs/deployment.html#kubernetes"
}
