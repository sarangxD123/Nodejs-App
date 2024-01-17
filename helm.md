1. Check Helm Version

helm version
version.BuildInfo{Version:"v3.13.0", GitCommit:"825e86f6a7a38cef1112bfa606e4127a706749b1", GitTreeState:"clean", GoVersion:"go1.21.1"}

I am using above version

2. Create Helm Charts

helm create myntra-app

3. Modify the helm chart files

In values.yaml, update the repository value:

image:
  repository: sarangxd001/myntra
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: latest


and port value and type value:

service:
  type: LoadBalancer 
  port: 3000
  targetPort: 3000

In templates/service.yaml, update type and ports value

spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
      protocol: TCP

In templates/deployment.yaml, update container port value

ports:
  - containerPort: 3000


4. Install the helm chart

Run the helm command below:

helm install myntra-basic myntra-app/

5. Check k8s pod and service status

$ kubectl get svc
NAME       TYPE      CLUSTER-IP EXTERNAL-IP PORT(S) AGE
kubernetes ClusterIP 172.20.0.1 <none>     443/TCP  24d
myprog LoadBalancer 172.20.242.168 a492a18.us-east-1.elb.amazonaws.com 4002:31599/TCP 15s

and

$ kubectl get pod
NAME                    READY STATUS   RESTARTS AGE
myprog-694c58864d-qmrms 1/1   Running  0    43s

$ kubectl get deployment