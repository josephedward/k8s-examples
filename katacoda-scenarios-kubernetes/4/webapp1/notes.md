**deployment.yaml** 
defines how to launch an application called webapp1 using the Docker Image katacoda/docker-http-server that runs on Port 80

**service.yaml**
- The Service selects all applications with the label webapp1. 
- As multiple replicas, or instances, are deployed, they will be automatically load balanced based on this common label. 
- The Service makes the application available via a NodePort.

Update the deployment.yaml file to increase the number of instances running. For example, the file should look like this:
`replicas: 4`...then execute `kubectl apply -f deployment.yaml`

