
kubectl create -f deployment.yaml
kubectl get deployment
kubectl describe deployment webapp1

kubectl create -f service.yaml
kubectl get svc
kubectl describe svc webapp1-svc
curl host01:30080

# change to replicas:4
kubectl apply -f deployment.yaml
kubectl get deployment
kubectl get pods
curl host01:30080
