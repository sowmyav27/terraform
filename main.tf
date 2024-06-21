terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "4.1.0"
    }
  }
}


provider "rancher2" {
  api_url    = var.rancher_api_url
  access_key = var.rancher_api_access_key
  secret_key = var.rancher_api_secret_key
  insecure = true
}


# ___________________________________________________RKE2ClusterCreation_________________________________________________

resource "rancher2_cloud_credential" "rancher2_cloud_credential" {
  name = "rancher2_cloud_credential"
  description = "linode credentials"
  linode_credential_config {
    token = var.linode_token
  }
}

# Create linode machine config v2
resource "rancher2_machine_config_v2" "rke2-cluster1" {
  generate_name = "sowmya-cluster1"
  linode_config {
    region = var.linode_region
    image = var.linode_image
  }
}



#Create a new rke2 cluster cluster 1 node pools for each role
resource "rancher2_cluster_v2" "rke2-cluster-tf" {
  name = "rke2-cluster-tf"
  kubernetes_version = "v1.28.10+rke2r1"
  enable_network_policy = false
  default_cluster_role_for_project_members = "user"
  rke_config {
    machine_pools {
      name = "pool1"
      cloud_credential_secret_name = rancher2_cloud_credential.rancher2_cloud_credential.id
      control_plane_role = false
      etcd_role = true
      worker_role = false
      quantity = 1
      machine_config {
        kind = rancher2_machine_config_v2.rke2-cluster1.kind
        name = rancher2_machine_config_v2.rke2-cluster1.name
      }
    }
    machine_pools {
      name = "pool2"
      cloud_credential_secret_name = rancher2_cloud_credential.rancher2_cloud_credential.id
      control_plane_role = true
      etcd_role = false
      worker_role = false
      quantity = 1
      machine_config {
        kind = rancher2_machine_config_v2.rke2-cluster1.kind
        name = rancher2_machine_config_v2.rke2-cluster1.name
      }
    }
    machine_pools {
      name = "pool3"
      cloud_credential_secret_name = rancher2_cloud_credential.rancher2_cloud_credential.id
      control_plane_role = false
      etcd_role = false
      worker_role = true
      quantity = 1
      machine_config {
        kind = rancher2_machine_config_v2.rke2-cluster1.kind
        name = rancher2_machine_config_v2.rke2-cluster1.name
      }
    }
  }
}
