terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.12"
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

data "google_service_account" "existing" {
  account_id = "test-account"
}

resource "google_container_cluster" "primary" {
  name     = "vincent-brown-cluster"
  location = var.region
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    service_account = data.google_service_account.existing.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_deployment" "application" {
  metadata {
    name = "application-deployment"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "application"
      }
    }

    template {
      metadata {
        labels = {
          app = "application"
        }
      }

      spec {
        container {
          image = "ealen/echo-server:latest"
          name  = "application"
        }
      }
    }
  }
}

resource "google_project_iam_member" "terraform_compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${data.google_service_account.existing.email}"
}
