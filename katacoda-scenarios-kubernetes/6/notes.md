**Cluster IP**
Cluster IP is the default approach when creating a Kubernetes Service. 
The service is allocated an internal IP that other components can use to access the pods.
By having a single IP address it enables the service to be load balanced across multiple Pods.
Services are deployed via `kubectl apply -f clusterip.yaml`.
The definition can be viewed at `cat clusterip.yaml`
This will deploy a web app with two replicas to showcase load balancing along with a service. 
The Pods can be viewed at `kubectl get pods`
It will also deploy a service - `kubectl get svc`
More details on the service configuration and active endpoints 
(Pods) can be viewed via `kubectl describe svc/webapp1-clusterip-svc`
After deploying, the service can be accessed via the ClusterIP allocated.
`export CLUSTER_IP=$(kubectl get services/webapp1-clusterip-svc -o go-template='{{(index .spec.clusterIP)}}')`
`echo CLUSTER_IP=$CLUSTER_IP`
`curl $CLUSTER_IP:80`
Multiple requests will showcase how the service load balancers across multiple Pods based on the common label selector.

**Target Port**
Target ports allows us to separate
- the port the service is available on 
- from the port the application is listening on. 
**TargetPort** is the Port which the application is configured to listen on. 
**Port** is how the application will be accessed from the outside.
Similar to previously, the service and extra pods are deployed via `kubectl apply -f clusterip-target.yaml`
The following commands will create the service.
`cat clusterip-target.yaml`
`kubectl get svc`
`kubectl describe svc/webapp1-clusterip-targetport-svc`
After the service and pods have deployed, 
it can be accessed via the cluster IP as before, 
but this time on the defined port 8080.
`export CLUSTER_IP=$(kubectl get services/webapp1-clusterip-targetport-svc -o go-template='{{(index .spec.clusterIP)}}')`
`echo CLUSTER_IP=$CLUSTER_IP`
`curl $CLUSTER_IP:8080`
The application itself is still configured to listen on port 80. 
Kubernetes Service manages the translation between the two.


**NodePort**
While TargetPort and ClusterIP make it available to inside the cluster, 
the NodePort **exposes the service on each Node’s IP via the defined static port**. 
No matter which Node within the cluster is accessed, the **service will be reachable based on the port number defined**.
`kubectl apply -f nodeport.yaml`
When viewing the service definition, 
notice the additional type and NodePort property defined:
`cat nodeport.yaml`
`kubectl get svc`
`kubectl describe svc/webapp1-nodeport-svc`
The service can now be reached via the Node's IP address on the NodePort defined.
`curl 172.17.0.8:30080`


**External IPs**
Another approach to making a service available outside of the cluster is via External IP addresses.
Update the definition to the current cluster's IP address with: 
`sed -i 's/HOSTIP/172.17.0.20/g' externalip.yaml`
`cat externalip.yaml`
`kubectl apply -f externalip.yaml`
`kubectl get svc`
`kubectl describe svc/webapp1-externalip-svc`
The service is now **bound to the IP address and Port 80 of the master node**.
`curl 172.17.0.20`


**Load Balancer**
When running in the cloud, such as EC2 or Azure, 
it's possible to *configure and assign a Public IP address issued via the cloud provider*. 
This will be issued via a Load Balancer such as **ELB**. 
This allows additional public IP addresses to be allocated to a Kubernetes cluster,
without interacting directly with the cloud provider.
**dynamically allocate IP addresses to LoadBalancer type services:**
This is done by deploying the "Cloud Provider" using 
`kubectl apply -f cloudprovider.yaml`.
When running in a service provided by a Cloud Provider this is not required.
When a service requests a Load Balancer, the provider will allocate one from the 10.10.0.0/26 range defined in the configuration.
`kubectl get pods -n kube-system`
`kubectl apply -f loadbalancer.yaml`
While the IP address is being defined, the service will show *Pending*. 
When allocated, it will appear in the *service* list.
`kubectl get svc`
`kubectl describe svc/webapp1-loadbalancer-svc`
The service can now be accessed via the IP address assigned, 
in this case from the *10.10.0.0/26* range.
`export LoadBalancerIP=$(kubectl get services/webapp1-loadbalancer-svc -o go-template='{{(index .status.loadBalancer.ingress 0).ip}}')`
`echo LoadBalancerIP=$LoadBalancerIP`
`curl $LoadBalancerIP`
