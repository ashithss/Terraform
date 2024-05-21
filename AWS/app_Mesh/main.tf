module "aws" {
    source = "Young-ook/spinnaker/aws//modules/aws-partitions"  # Using the "aws-partitions" module from the "Young-ook/spinnaker/aws" repository
  }
  
  locals {
    namespace      = lookup(var.helm, "namespace", "appmesh-system")  # Assigning the value of the "namespace" variable from the "helm" variable, defaulting to "appmesh-system" if not provided
    serviceaccount = lookup(var.helm, "serviceaccount", "aws-appmesh-controller")  # Assigning the value of the "serviceaccount" variable from the "helm" variable, defaulting to "aws-appmesh-controller" if not provided
  }
  #to create iam-role-for-serviceaccount
  module "irsa" {
    source         = "../iam-role-for-serviceaccount"  # Using the "iam-role-for-serviceaccount" module from a local path
    name           = join("-", ["irsa", local.name])  # Setting the name of the IRSA (IAM Role for Service Account) by joining "irsa" and the local "name" variable
    namespace      = local.namespace  # Passing the value of the local "namespace" variable to the IRSA module
    serviceaccount = local.serviceaccount  # Passing the value of the local "serviceaccount" variable to the IRSA module
    oidc_url       = var.oidc.url  # Passing the value of the "url" attribute from the "oidc" variable to the IRSA module
    oidc_arn       = var.oidc.arn  # Passing the value of the "arn" attribute from the "oidc" variable to the IRSA module
    policy_arns = [
      format("arn:%s:iam::aws:policy/AWSCloudMapFullAccess", module.aws.partition.partition),  # Setting the ARN for the "AWSCloudMapFullAccess" IAM policy using the "partition" attribute from the "aws" module
      format("arn:%s:iam::aws:policy/AWSAppMeshFullAccess", module.aws.partition.partition),  # Setting the ARN for the "AWSAppMeshFullAccess" IAM policy using the "partition" attribute from the "aws" module
    ]
    tags = var.tags  # Passing the value of the "tags" variable to the IRSA module
  }
  #to create helm
  resource "helm_release" "appmesh" {
    name             = lookup(var.helm, "name", "appmesh-controller")  # Assigning the value of the "name" variable from the "helm" variable, defaulting to "appmesh-controller" if not provided
    chart            = lookup(var.helm, "chart", "appmesh-controller")  # Assigning the value of the "chart" variable from the "helm" variable, defaulting to "appmesh-controller" if not provided
    version          = lookup(var.helm, "version", null)  # Assigning the value of the "version" variable from the "helm" variable, defaulting to null if not provided
    repository       = lookup(var.helm, "repository", "https://aws.github.io/eks-charts")  # Assigning the value of the "repository" variable from the "helm" variable, defaulting to "https://aws.github.io/eks-charts" if not provided
    namespace        = local.namespace  # Assigning the value of the local "namespace" variable to the Helm release resource
    create_namespace = true  # Creating the namespace if it doesn't already exist
    cleanup_on_fail  = lookup(var.helm, "cleanup_on_fail", true)  # Assigning the value of the "cleanup_on_fail" variable from the "helm" variable, defaulting to true if not provided
  
    dynamic "set" {
      for_each = merge({
        "region"                                                    = module.aws.region.name  # Setting the "region" variable to the value of the "name" attribute from the "region" variable in the "aws" module
        "serviceAccount.name"                                       = local.serviceaccount  # Setting the "serviceAccount.name" variable to the value of the local "serviceaccount" variable
        "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa.arn  # Setting the "serviceAccount.annotations.eks.amazonaws.com/role-arn" variable to the value of the "arn" attribute from the "irsa" module
        "tracing.enabled"                                           = true  # Enabling tracing for the Helm release
        "tracing.provider"                                          = "x-ray"  # Setting the tracing provider to "x-ray"
      }, lookup(var.helm, "vars", {}))
      content {
        name  = set.key  # Setting the name of the dynamic block to the key of the current itemvalue = set.value  # Setting the value of the dynamic block to the value of the current item
      }
    }
  }
