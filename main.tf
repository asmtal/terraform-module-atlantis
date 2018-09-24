// Instructions to deploy atlantis from here: https://www.runatlantis.io/guide/getting-started.html


// This webhook sends stuff to atlantis based on Github events
// e.g. PR comments trigger a webhook HTTP call
resource "github_repository_webhook" "atlantis_github_webhook" {
  // TODO: make this into an array so it deploys a webhook for each specified
  // repo
  repository = "${var.github_repository_repo_name}"
  configuration {
    url          = "${var.atlantis_url}"
    content_type = "form"
    insecure_ssl = "${var.github_repository_webhook_insecure_ssl}"
  }

  active = true

  events = "${var.github_repository_webhook_events}"
}

# this token is the atlantis github token. So atlantis messages will
# be posted as this user in Github comments
data "github_access_token" {
  description = "Access token so atlantis can talk to Github. Token requires a `repo` scope"
}

# these are the manifests to deploy atlantis to kubernetes
resource "atlantis_manifest_deploy_k8s" {
  description = "Resource that deploys atlantis on kubernetes. From: https://www.runatlantis.io/docs/deployment.html#start-atlantis and https://www.runatlantis.io/docs/deployment.html#kubernetes"
}

# This is the GCP service account assigned to this user
resource "google_service_account" "atlantis_gcp_svc" {
}
# this is the gcs bucket containing the state files for the child project
# The atlantis gcp service account must be granted roles to access this state
data "gcs_state_bucket" {}

# What else is needed
# - GHE creds to bootstrap atlantis to add webhooks
# - URL to give Github to send webhooks to atlantis from
#    * Could just be a variable
#    * but would be nice for tf to find it automagically hmmm
# - Kubernetes manifests to deploy atlantis on k8s
# - Service Account user in GCP that atlantis uses to access/modify GCP resources
# - Correct level of permission for GCP atlantis account for doing project level stuff
