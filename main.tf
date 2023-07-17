terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.73.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

locals {
  machine_type = "e2-medium"
  image = "debian-cloud/debian-11"
}
resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = local.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
    network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
  
}

resource "google_storage_bucket" "auto-expire" {
  name          = "${var.project_id}-bucket"
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}