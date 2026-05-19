terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "~/.kube/config"
    namespace     = "kube-system"
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
resource "helm_release" "nginx_web" {
  name             = "my-nginx"
  # Указываем путь к локальной папке, которую мы только что скачали
  chart            = "./ingress-nginx"
  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  namespace        = "production"
  create_namespace = true
}
