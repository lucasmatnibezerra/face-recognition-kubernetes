# Face Recognition Kubernetes Deployment

This repository provides an example of how to deploy a face recognition application using TensorFlow.js in a Kubernetes cluster. The application is served by an Nginx container that hosts the web interface, allowing users to interact with the face recognition system.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Kubernetes](https://kubernetes.io/docs/setup/) (recommended to use [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) for local environment)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Setup Instructions

### 1. Clone this Repository

First, clone this repository to your local machine:

```sh
git clone https://github.com/lucasmatnibezerra/face-recognition-kubernetes.git
cd face-recognition-kubernetes
```
### 2. Verify the Docker Image
We are using a public Docker image that has already been built and is available on Docker Hub:

```sh
lucasmatni/face-detection-tensorjs:latest
```

### 3. Create the Deployment in Kubernetes
You will need to create a deployment in Kubernetes that uses the Docker image. The deployment described below creates 3 replicas of the application to ensure high availability.

Create a file named deployment.yaml with the following content:

```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: face-detection-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: face-detection
  template:
    metadata:
      labels:
        app: face-detection
    spec:
      containers:
      - name: face-detection-container
        image: lucasmatni/face-detection-tensorjs:latest
        ports:
        - containerPort: 80
``` 

### 4. Create the Service in Kubernetes
Now, create a service that exposes the application on port 80 and uses NodePort to allow external access.

Create a file named service.yaml with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: face-detection-service
  namespace: default
spec:
  selector:
    app: face-detection
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 32475
  type: NodePort
```

### 5. Apply the Configuration Files
Apply the configuration files to your Kubernetes cluster:

```sh
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 6. Access the Web Interface
Using kubectl port-forward
If you are using a local environment like kind, you can access the application using kubectl port-forward:

```sh
kubectl port-forward pod/<pod-name> 8080:80 -n default
```
Then, open your browser and go to:

```sh
http://localhost:8080
```

### 6. Logs and Debugging
If you encounter any issues, you can check the logs of the pods:

```sh
Copiar código
kubectl logs <pod-name> -n default
```
This will help diagnose any issues that may arise.
