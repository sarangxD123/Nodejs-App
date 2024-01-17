1. Check Helm Version

```
helm version

version.BuildInfo{Version:"v3.13.0", GitCommit:"825e86f6a7a38cef1112bfa606e4127a706749b1", GitTreeState:"clean", GoVersion:"go1.21.1"}

```

I am using above version

2. Create Helm Charts

```
helm create helm-myntra 

```

3. Install the helm chart

Run the helm command below:
```
helm install myntra-basic helm-myntra/

```

4. Check k8s pod and service status
```
$ kubectl get svc

$ kubectl get pod

$ kubectl get deployment

```

5. To uninstall

```
helm uninstall myntra-basic 

```