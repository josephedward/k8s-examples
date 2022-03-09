The helper script will launch the API, Master, a Proxy and DNS discovery(*default?*). 
The Web App uses **DNS Discovery** to find the Redis slave to store data.


**Redis Master Controller**
A Kubernetes service deployment has, at least, two parts. **A replication controller and a service.**
The replication controller *defines how many instances should be running, the Docker Image to use, and a name to identify the service*. Additional options can be utilized for configuration and discovery. Use the editor above to view the YAML definition.

**Create Replication Controller**
In this example, the YAML defines a redis server called redis-master using the official redis running port `6379`.

**Redis Master Service**
A Kubernetes service is a **named load balancer that proxies traffic to one or more containers**. 
The proxy works even if the containers are on different nodes.
Services proxy communicate within the cluster and rarely expose ports to an outside interface.
**When you launch a service it looks like you cannot connect using curl or netcat unless you start it as part of Kubernetes.**
The recommended approach is to have a *LoadBalancer service* to handle external communications.

**Create Service**
The YAML defines the name of the replication controller, redis-master, and the ports which should be proxied.

**Replication Slave Pods**
As previously described, the controller defines how the service runs. 
In this example we need to determine how the service discovers the other pods. 
The YAML represents the `GET_HOSTS_FROM` property as `DNS`. 
You can change it to use Environment variables in the yaml but this introduces *creation-order dependencies* as the service needs to be running for the environment variable to be defined.

**Start Redis Slave Controller**
In this case, we'll be launching two instances of the pod using the image: 
`kubernetes/redis-slave:v2` 
It will link to redis-master via DNS.

**Redis Slave Service**
As before we need to make our slaves accessible to incoming requests. This is done by starting a service which knows how to communicate with redis-slave.Because we have two replicated pods the service will also provide load balancing between the two nodes.

**Frontend Replicated Pods**
With the data services started we can now deploy the web application. 

**Launch Frontend**
The YAML defines a service called frontend that uses the image 
`_gcr.io/googlesamples/gb-frontend:v3`
The replication controller will ensure that three pods will always exist.

**Guestbook Frontend Service**
To make the frontend accessible we need to start a service to configure the proxy.

**Start Proxy**
The YAML defines the service as a NodePort. NodePort allows you to set well-known ports that are shared across your entire cluster. This is like -p 80:80 in Docker.

In this case, we define our web app is running on port 80 but we'll expose the service on 30080.


**Access Guestbook Frontend**
With all controllers and services defined,
Kubernetes will start launching them as Pods. 
A pod can have different states depending on what's happening. 

If the Docker Image is still being downloaded 
then the Pod will have a pending state as it's not able to launch. 
Once ready the status will change to running.


**Find NodePort**
If you didn't assign a well-known NodePort then Kubernetes will assign an available port randomly. 
**You can find the assigned NodePort using kubectl**.

View UI
Once the Pod is in running state you will be able to view the UI via port 30080. Use the URL to view the page https://2886795294-30080-ollie09.environments.katacoda.com

Under the covers the **PHP service is discovering the Redis instances via DNS**. 
