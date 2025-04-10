resource "kubernetes_storage_class_v1" "aws_csi" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  metadata {
    name = "ebs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    type = "gp3"
    fsType = "ext4"
  }
  allow_volume_expansion = true
  volume_binding_mode = "WaitForFirstConsumer"
}

# resource "kubernetes_storage_class_v1" "gce_csi" {
#   metadata {
#     name = "standard-sc"
#     annotations = {
#       "storageclass.kubernetes.io/is-default-class" = "true"
#     }
#   }
#
#   # Provisioner for GCP Persistent Disks (GCE PD)
#   storage_provisioner = "kubernetes.io/gce-pd"
#
#   reclaim_policy = "Delete"  # Automatically delete volumes when they are no longer used.
#
#   parameters = {
#     type   = "pd-standard"   # This is the default disk type for GCP Persistent Disks.
#     fsType = "ext4"          # Filesystem type for the disk.
#   }
#
#   allow_volume_expansion = true
#
#   # Volume binding mode - control when the volume should be provisioned.
#   volume_binding_mode = "WaitForFirstConsumer"
# }
