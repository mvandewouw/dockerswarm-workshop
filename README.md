# dockerswarm-workshop

Preperation for DCA exam: Orchestration

## Starting cluster

Clone the repo and startup with vagrant up. This might take while, it are 4 vm's

This is from DCA study guide:

* Complete the setup of a swarm mode cluster, with managers and worker nodes
* State the differences between running a container vs running a service
* Demonstrate steps to lock a swarm cluster
* Extend the instructions to run individual containers into running services under swarm
* Interpret the output of "docker inspect" commands
* Convert an application deployment into a stack file using a YAML compose file with "docker stack deploy"
* Manipulate a running stack of services
* Increase # of replicas
* Add networks, publish ports
* Mount volumes
* Illustrate running a replicated vs global service
* Identify the steps needed to troubleshoot a service not deploying
* Apply node labels to demonstrate placement of tasks
* Sketch how a Dockerized application communicates with legacy systems
* Paraphrase the importance of quorum in a swarm cluster
* Demonstrate the usage of templates with "docker service create"

You can build the presentation yourself:
```
docker build -t mwtf1/dcaorchestration
docker run -d -p 8000:1948 mwtf1/dcaorchestration:latest
```

### Complete the setup of a swarm mode cluster, with managers and worker nodes
```
Install docker on all the nodes and initiate cluster
```

### State the differences between running a container vs running a service

### Demonstrate steps to lock a swarm cluster

### Extend the instructions to run individual containers into running services under swarm

### Interpret the output of "docker inspect" commands

### Convert an application deployment into a stack file using a YAML compose file with "docker stack deploy"

### Manipulate a running stack of services

### Increase # of replicas

### Add networks, publish ports

### Mount volumes

### Illustrate running a replicated vs global service

### Identify the steps needed to troubleshoot a service not deploying

### Apply node labels to demonstrate placement of tasks

### Sketch how a Dockerized application communicates with legacy systems

### Paraphrase the importance of quorum in a swarm cluster

### Demonstrate the usage of templates with "docker service create"