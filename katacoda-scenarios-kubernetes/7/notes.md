**Create Deployment**
To start, deploy an example HTTP server that will be the target of our requests. 
The deployment contains three deployments, 
one called webapp1, webapp2, webapp3 
with a service for each.
`cat deployment.yaml`
Deploy the definitions with 
`kubectl apply -f deployment.yaml`
The status can be viewed with 
`kubectl get deployment`


**Deploy Ingress**
The YAML file `ingress.yaml` defines a Nginx-based Ingress controller together with a service making it *available on Port 80 to external connections using ExternalIPs*. 
If the Kubernetes cluster was running on a cloud provider then it would use a *LoadBalancer service type*.
The **ServiceAccount** defines the account with a set of permissions on how to access the cluster to access the defined Ingress Rules. 
The default server secret is a self-signed certificate for other Nginx example SSL connections and is required by the Nginx Default Example(https://github.com/nginxinc/kubernetes-ingress/tree/master/deployments).
`cat ingress.yaml`
The Ingress controllers are deployed in a familiar fashion to other Kubernetes objects with
`kubectl create -f ingress.yaml`
The status can be identified using 
`kubectl get deployment -n nginx-ingress`


**Deploy Ingress Rules**
Ingress rules are an object type with Kubernetes. 
*The rules can be based on a request host (domain), or the path of the request, or a combination of both.*
An example set of rules are defined within 
`cat ingress-rules.yaml`
The rules apply to requests for the host *my.kubernetes.example*. 
Two rules are defined based on the path request with a single catch all definition. 
**Requests to the path /webapp1 are forwarded onto the service webapp1-svc**. 
Likewise, the requests to /webapp2 are forwarded to webapp2-svc. 
If no rules apply, webapp3-svc will be used.
This demonstrates how an application's URL structure can behave independently from how the applications are deployed:
```~~~
- host: my.kubernetes.example
  http:
    paths:
    - path: /webapp1
      backend:
        serviceName: webapp1-svc
        servicePort: 80
    - path: /webapp2
      backend:
        serviceName: webapp2-svc
        servicePort: 80
    - backend:
        serviceName: webapp3-svc
        servicePort: 80
```~~~
As with all Kubernetes objects, they can be deployed via 
`kubectl create -f ingress-rules.yaml`
Once deployed, the status of all the Ingress rules can be discovered via 
`kubectl get ing`


**Test**
With the Ingress rules applied, the traffic will be routed to the defined place.
The first request will be processed by the webapp1 deployment.
`curl -H "Host: my.kubernetes.example" 172.17.0.12/webapp1`
The second request will be processed by the webapp2 deployment.
`curl -H "Host: my.kubernetes.example" 172.17.0.12/webapp2`
Finally, all other requests will be processed by webapp3 deployment.
`curl -H "Host: my.kubernetes.example" 172.17.0.12`