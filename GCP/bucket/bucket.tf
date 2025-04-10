# data "external" "bucket_check" {
#   program = ["bash", "-c", <<EOT
#     # Ensure consistent JSON output
#     output=$(gsutil ls -b gs://${var.GCP_BUCKET_NAME} 2>&1)
#     status=$?
#
#     if [ $status -eq 0 ]; then
#       echo '{"exists":"true", "message":"Bucket exists"}'
#     elif echo "$output" | grep -q 'No such bucket'; then
#       echo '{"exists":"false", "message":"Bucket not found"}'
#     else
#       echo '{"exists":"error", "message":"'$(echo "$output" | tr -d '\n')'"}'
#       exit 1
#     fi
#   EOT
#   ]
# }
#
# locals {
#   # Handle bucket existence with error checking
#   bucket_exists = try(
#     data.external.bucket_check.result.exists == "true",
#     false
#   )
# }

resource "google_storage_bucket" "bucket" {
  # count = local.bucket_exists ? 0 : 1

  name     = var.GCP_BUCKET_NAME
  location = var.GCP_REGION
}

# Firestore Document for LockID (representing the lock)
# resource "google_firestore_document" "terraform_lock" {
#   # count = local.firestore_exists ? 0 : 1
#
#   project     = var.GCP_PROJECT_ID
#   database    = "(default)"  # Default Firestore database
#   collection  = "terraform-locks"
#   document_id = "LockID"  # Unique lock identifier
#
#   fields = jsonencode({
#     LockID = { string_value = "terraform-lock" }
#   })
#
#   lifecycle {
#     prevent_destroy = true  # Prevent accidental deletion of the lock document
#   }
# }
