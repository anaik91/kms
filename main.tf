variable "key_path" {
  default = "/tmp"
}

variable "project" {
}

variable "keyring_name" {
}

variable "keyring_location" {
}

variable "keyring_key_name" {
}

variable "keyring_import_job" {
}

resource "google_kms_key_ring" "keyring" {
  project  = var.project
  name     = var.keyring_name
  location = var.keyring_location
}

resource "google_kms_crypto_key" "example-key" {
  name                          = var.keyring_key_name
  key_ring                      = google_kms_key_ring.keyring.id
  skip_initial_version_creation = true
  rotation_period = "7776000s"
  import_only = true
}

resource "google_kms_key_ring_import_job" "import-job" {
  key_ring      = google_kms_key_ring.keyring.id
  import_job_id = var.keyring_import_job

  import_method    = "RSA_OAEP_3072_SHA1_AES_256"
  protection_level = "SOFTWARE"
}

/*
resource "null_resource" "proto_descriptor" {
  provisioner "local-exec" {
    command = <<EOT
    /usr/bin/openssl rand 32 > ${var.key_path}/test.bin
    EOT
  }
}


resource "null_resource" "import" {

  provisioner "local-exec" {
    command = <<EOT
    gcloud kms keys versions import \
      --import-job ${var.keyring_import_job} \
      --location ${var.keyring_location} \
      --keyring ${var.keyring_name} \
      --key ${var.keyring_key_name} \
      --algorithm google-symmetric-encryption \
      --target-key-file ${var.key_path}/test.bin
    EOT
  }
}
*/