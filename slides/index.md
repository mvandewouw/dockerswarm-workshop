<!--
<section data-background="img/tf1.jpg" style="color:black" background-size="1080px">
-->

<section data-background-image="img/tf1.jpg" data-background-size="1080px">
</section>

** Docker Orchestration **

$ whoarewe

Michel van de Wouw | Ron Boortman

Note: Check

---

### From DCA study guide 1/3 ###

* Complete the setup of a swarm mode cluster, with managers and worker nodes
* State the differences between running a container vs running a service
* Demonstrate steps to lock a swarm cluster
* Extend the instructions to run individual containers into running services under swarm
* Interpret the output of "docker inspect" commands

Note:

---

### From DCA study guide 2/3 ###

* Convert an application deployment into a stack file using a YAML compose file with "docker stack deploy"
* Manipulate a running stack of services
* Increase # of replicas
* Add networks, publish ports
* Mount volumes
* Illustrate running a replicated vs global service
* Identify the steps needed to troubleshoot a service not deploying

Note:

---

### From DCA study guide 3/3 ###

* Apply node labels to demonstrate placement of tasks
* Sketch how a Dockerized application communicates with legacy systems
* Paraphrase the importance of quorum in a swarm cluster
* Demonstrate the usage of templates with "docker service create"

Note: tst

---

### Clone repo ###

```
git clone git@github.com:mvandewouw/dockerswarm-workshop.git
```

Note: tst

---

### Presentation from docker ###
Presentatie vannuit een docker image ;) Build & Run it.
```
export DOCKER_BUILDKIT=1
docker build -t mwtf1/dcaorchestration
docker run -d -p 8000:1948 mwtf1/dcaorchestration:latest
```

Note: tst

---

### Omgeving vagrantfile ###

Bestaat uit 4 vm's check Vagrantfile

Note: tst

---

### Setup script ###

```
echo "192.168.56.111 manager1" >> /etc/hosts
echo "192.168.56.112 manager2" >> /etc/hosts
echo "192.168.56.113 worker1" >> /etc/hosts
echo "192.168.56.114 worker2" >> /etc/hosts
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y elinks
curl -fsSL https://get.docker.com/  | awk 'NR==3{print "export DEBIAN_FRONTEND=noninteractive"}1' | sh
usermod -aG docker vagrant
systemctl restart docker
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

Note: tst

---

Thanks!