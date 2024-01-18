Use Following Commands to Create EKS Cluster Using Terraform:

```
terraform init -- to initialize a working directory containing Terraform configuration files and download plugins

terraform validate -- to validate the configuration

terraform plan -- to check the configuration

terraform apply -- to apply the configuration

```


After creating this Cluster Use this command with your region and cluster name to update kube-config

```
aws eks update-kubeconfig --region region-code --name my-cluster

```

#aws eks update-kubeconfig --region eu-north-1 --name EKS_CLOUD


To check if you can access your cluster use the following command

```
kubectl cluster-info

kubectl get nodes -A 

```