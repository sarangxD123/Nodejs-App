# How to setup alb add on

Download IAM policy

```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
```

Create IAM Policy

```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
```

Determine whether an IAM OIDC provider with your cluster's ID is already in your account.
```
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

 #copy the OIDC provider ID
```
AWS CLI and kubectl to create the IAM role and Kubernetes service account.

```
cat >load-balancer-role-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::593534113946:oidc-provider/oidc.eks.eu-north-1.amazonaws.com/id/6A08623089FA661C097A0A20C965C99B" #OIDC Provider id
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.eu-north-1.amazonaws.com/id/6A08623089FA661C097A0A20C965C99B:aud": "sts.amazonaws.com",
                    "oidc.eks.eu-north-1.amazonaws.com/id/6A08623089FA661C097A0A20C965C99B:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF

```
Create the IAM role.

```
aws iam create-role \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --assume-role-policy-document file://"load-balancer-role-trust-policy.json"
``` 

Attach the IAM role

```
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::593534113946:policy/AWSLoadBalancerControllerIAMPolicy \
  --role-name AmazonEKSLoadBalancerControllerRole
```  

Create the Kubernetes service account on your cluster. The Kubernetes service account named aws-load-balancer-controller is annotated with the IAM role that you created named AmazonEKSLoadBalancerControllerRole.


```
  cat >aws-load-balancer-controller-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::593534113946:role/AmazonEKSLoadBalancerControllerRole
EOF

kubectl apply -f aws-load-balancer-controller-service-account.yaml

```

## Deploy ALB controller

Add helm repo

```
helm repo add eks https://aws.github.io/eks-charts
```

Update the repo

```
helm repo update eks
```

Install

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \            
  -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region> \
  --set vpcId=<your-vpc-id>
```

Verify that the deployments are running.

```
kubectl get deployment -n kube-system aws-load-balancer-controller

```