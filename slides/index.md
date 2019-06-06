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

#### From DCA study guide 1/3 ####

* Complete the setup of a swarm mode cluster, with managers and worker nodes
* State the differences between running a container vs running a service
* Demonstrate steps to lock a swarm cluster
* Extend the instructions to run individual containers into running services under swarm
* Interpret the output of "docker inspect" commands

Note:

---

#### From DCA study guide 2/3 ####

* Convert an application deployment into a stack file using a YAML compose file with "docker stack deploy"
* Manipulate a running stack of services
* Increase # of replicas
* Add networks, publish ports
* Mount volumes
* Illustrate running a replicated vs global service
* Identify the steps needed to troubleshoot a service not deploying

Note:

---

#### From DCA study guide 3/3 ####

* Apply node labels to demonstrate placement of tasks
* Sketch how a Dockerized application communicates with legacy systems
* Paraphrase the importance of quorum in a swarm cluster
* Demonstrate the usage of templates with "docker service create"

Note: tst

---

#### Clone repo ####

```
git clone git@gitlab.com:wouwm/dca-workshop-orchestration.git
```

Note: tst

---

#### Presentatie vannuit een docker container ####
Presentatie vanuit een docker image ;) Build & Run it.

* Bouw een image
* Run de container. (er draait iets op poort 1948)
* Bonus, bind mount de slides dir naar /slides

Note:
docker run -d -p 1984:1948 mwtf1/dcaorchestration:latest

docker run -d -p 1984:1948 --mount type=bind,source="$(pwd)"/slides,target=/slides mwtf1/dcaorchestration:latest

---

#### Omgeving vagrantfile ####

Bestaat uit 6 vm's check Vagrantfile

Note: tst

---

#### Setup scripts ####

```
$script = <<-SCRIPT
echo "192.168.56.111 manager1" >> /etc/hosts
echo "192.168.56.112 manager2" >> /etc/hosts
echo "192.168.56.113 manager3" >> /etc/hosts
echo "192.168.56.114 worker1" >> /etc/hosts
echo "192.168.56.115 worker2" >> /etc/hosts
echo "192.168.56.116 worker3" >> /etc/hosts
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y elinks
curl -fsSL https://get.docker.com/  | awk 'NR==3{print "export DEBIAN_FRONTEND=noninteractive"}1' | sh
usermod -aG docker vagrant
systemctl restart docker
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
SCRIPT
```

Note: tst

---

#### Overview docker swarm ####

<section data-background-image="img/swarm.jpeg" data-background-size="1080px">
</section>

---

https://docs.docker.com/engine/swarm/key-concepts/

https://docs.docker.com/engine/swarm/

---

#### Complete the setup of a swarm mode cluster, with managers and worker nodes ####
Login op manager1 en check status swarm (vagrant ssh manager1)
```
docker system info
```

Bekijk de aanwezige networks
```
docker network ls
```

---

```
docker swarm init --advertise-addr 192.168.56.111
clear
docker node ls
```

Zoek uit hoe je token kunt achterhalen voor Manager en Worker nodes

Note:

docker swarm join-token manager

docker swarm join-token manager

---

Join de rest van de manager nodes en worker nodes om het cluster compleet te maken

Zie het verschil tussen networks voor swarm creation en na swarm creation

---

```
docker service create --name my-web --publish published=8080,target=80 --replicas 1 nginx
```
Op iedere node kun je volgende uitvoeren:
```
curl localhost:8080
```
Update de service zodat er 10 replica's draaien op je swarm:
```
docker service update --replicas=10 my-web
```

---

Default is een manager node ook een worker node.

Kijk eerst waar alle tasks van de service nu draaien.

Lijst van alle docker services:
```
docker service ls
```
Details van de service:
```
docker service ps my-web
```

---

Zorg ervoor dat manager1 geen worker node meer is, en dus geen tasks meer draait.

Hint: check out docker node update

Kijk daarna weer naar verdeling tasks van service my-web

Note:

docker node update --availability drain manager1

---

* Zorg ervoor dat de manager1 weer tasks kan accepteren Wat gebeurd er nu met de verdeling van tasks?
* Zorg ervoor dat de tasks weer verdeeld zijn.
* Verwijder hierna de service my-web

Note:

docker node update --availability active manager1

docker service update my-web --force

docker service rm my-web

---

Change role van manager1 naar worker.

Change role van worker2 naar manager.

https://docs.docker.com/engine/swarm/manage-nodes/

Note:

docker node demote manager1

of

docker node update --role worker manager1

docker node promote worker2

of

docker node update --role manager worker2


---

Wat is er aan de hand met worker2?

* Go fix...

* Change role terug van worker naar manager voor manager1

* Wie is de leader?

* Verwijder service my-web

Note:
Wat gebeurd er met een demote/promote? Zelfde als --role?

docker node update --availability active node2

fix
docker swarm leave
docker swarm join bla bla
docker service rm my-web
---

[Dockerswarm networking explained](https://neuvector.com/network-security/docker-swarm-container-networking/)

[Use swarm mode routing mesh](https://docs.docker.com/engine/swarm/ingress/)

[Katacoda load balance/service discovery](https://www.katacoda.com/courses/docker-orchestration/load-balance-service-discovery-swarm-mode)

---

#### State the differences between running a container vs running a service ####

[Services tasks and containers](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#services-tasks-and-containers)

[Service create command](https://docs.docker.com/v17.09/engine/reference/commandline/service_create)

---

Containers | Services
--- | --- 
Encapsulate an application or function | Encapsulate an application or function
Run on single host | Run on 1 to n nodes at any time
Require manual steps to expose functionality outside of the host system | Functionality is easily accessed using features like routing mesh outside the worker nodes

---

Containers | Services
--- | --- 
Require more complex configuration to use multiple instances | Multiple instances are set to launch in a single command
Not highly available | Highly availabe clusters are available
Not easily scalable | Easily scalable


Note:


---

#### Demonstrate steps to lock a swarm cluster ####

Waarom zou je een cluster locken?

* Tegenhouden van verkeerde restores swarm ?

Bij het aanmaken van een nieuwe swarm cluster:
```
docker swarm init --autolock
```
Of bij een al aangemaakte cluster:
```
docker swarm update --autolock=true
```

---

* Lock je swarm
* restart een docker daemon op een van de managers
* doe op die manager een docker node ls
* unlock je gereboote manager node
* haal een key terug van een van de andere managers
* Verwijder autolock van je swarm


Key rotation? Hoe kan je dat doen
Note: 

docker swarm update --autolock=true
sudo systemctl restart docker
docker node ls
docker swarm unlock
docker node ls

Key rotate doen met autolock=false

of met: docker swarm unlock-key --rotate

---

#### Extend the instructions to run individual containers into running services under swarm ####

```
docker pull httpd
docker run -d --name test httpd
docker ps
docker container inspect test | grep IPAddr
elinks http://172.17.0.2
docker stop test
docker rm test
probleem is dat dit alleen op private network draait op dit systeem
#docker run -d --name test httpd
docker service create --name test --publish 80:80 httpd (single replica on single node)
elinks http://worker1 ?
elinks http://worker2 ?
elinks http://worker3 ?
check docker service create & docker service update op documentation website
docker service ls
docker service update --replicas 10 --detach=false test (detach is nu default vroeg niet)
CPU limitation: reservation (soft limit) : --limit-cpu=.5 --reserve-cpu=.75 (limit=soft reservation=hard)

docker service create --name testid --publish 3000:3000 adongy/hostname-docker
curl manager1:3000
curl manager1:3000
curl manager1:3000
```
---
* Update service testid naar 10 replicas

Kijk naar verdeling:
```
for i in {1..100}; do curl -s manager1:3000 | awk '{print $2}';done | sort | uniq -c
```
* Verwijder alle services

Note:

docker service update --replicas 10 --detach=false testid

for i in {1..100}; do curl -s manager1:3000 | awk '{print $2}';done | sort | uniq -c

---


https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/

---

#### Interpret the output of "docker inspect" commands ####

Default is json output

```
docker service inspect test --pretty
docker container inspect ... pretty?
docker network inspect ... pretty?
docker node inspect ... pretty :)
```

Je kan greppen op ipadress bvb
```
docker container inspect frfdrf
```
---

Je kunt ook structure bevragen

* Eerste punt top level
* .State (main category)
* Membervalue Paused
```
docker container inspect --format="{{.State.Paused}}" sfsf
docker container inspect --format="{{json .State}}" fsff
```

Check of je ipadress uit je container kan krijgen met --format

---


https://docs.docker.com/engine/reference/commandline/inspect/

https://docs.docker.com/engine/swarm/swarm-tutorial/inspect-service/

---

#### Convert an application deployment into a stack file using a YAML compose file with "docker stack deploy" ####

* docker-compose convert -> docker-stack

```
mkdir Dockerfile

cat <<EOF > Dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install apache2 -y
RUN echo "test" > /var/www/html/index.html

EXPOSE 80

ENTRYPOINT apachectl -DFOREGROUND
EOF
```
---

```
docker images
export DOCKER_BUILDKIT=1
docker build -t mwhttpd:v0.1 .
docker run -d --name testhttpd -p 80:80 mwhttpd:v0.1
docker images
curl localhost
docker rm testhttpd
docker rmi mwhttpd:v0.1
```

---

Maken van appstack, create docker-compose.yml file
```
cat <<EOF > docker-compose.yml
version: '3'
services:
  apiweb1:
    image: mwhttpd:v0.1
    build: .
    ports:
      - "81:80"
  apiweb2:
    image: mwhttpd:v0.1
    ports:
      - "82:80"
  load-balancer:
    image: nginx:latest
    ports:
      - "80:80" 
EOF
```
---

```
docker-compose up -d
docker ps
curl localhost:81
curl localhost:82
curl localhost:80
docker-compose ps
docker-compose down #--volumes
```
---

Nu swarm deploy

```
docker ps -a
docker ps
docker stack deploy --compose-file docker-compose.yml teststack
```
---


```
wget https://raw.githubusercontent.com/dockersamples/example-voting-app/master/docker-stack.yml
docker stack deploy --compose-file docker-stack.yml vote
docker stack ls
docker stack ps vote
```

Note:

for i in {1..100}; do curl -s localhost:5000 |grep Processed | awk '{print $5}' ;done | sort | uniq -c

docker service update --replicas=50 vote_vote

for i in {1..100}; do curl -s localhost:5000 |grep Processed | awk '{print $5}' ;done | sort | uniq -c

---

#### Manipulate a running stack of services ####

```
docker stack deploy
docker stack ls
docker stack ps
docker stack rm
docker stack services
```

Filters:
* id / ID: `--filter id=7be5ei6sqeye`
* label: `--filter label=key=value`
* mode: `--filter mode=replicated`
* name: `--filter name=vote`
* node: `--filter node=manager1`
* service: `--filter service=result`

---

* Verwijder de vote stack

---

#### Increase # of replicas ####

```
#docker service update --replicas=5 test
docker pull nginx
docker service create --name testhttpd --publish 80:80 httpd
docker service ps testhttpd
docker service update --replicas 3 testhttpd
docker service ps testhttpd
docker service create --name testnginx --publish 6000:80 nginx
docker service ls
# update alletwee tegelijk?
docker service update --replicas 5 testweb testnginx
docker service scale testnginx=3
docker service scale testnginx=4 testhttpd=2
docker service rm testnginx
docker service rm testhttpd
```

---

#### Add networks, publish ports ####

```
docker service create --name testhttpd --publish 80:80 httpd
docker service update --publish-add 8080:80 testhttpd
docker service update --publish-rm 80:80 testhttpd

docker network create --driver overlay my-network

docker service create --network my-network --name testnginx nginx
docker service update --network-add my-network testnginx
docker service update --network-rm my-network testnginx
```

* Verwijder extra network my-network

---

#### Mount volumes

```
docker volume create my-vol

docker service create --mount src=my-vol,dst=/var/www/http --name testnginx nginx
```
Bind mount op iedere host
```
docker service create --mount type=bind,src=/vagrant,dst=/var/www/http --name testnginx nginx
```

* scale testnginx naar 6
* is bind mount overal available? (check met inspect en ga in container)

---

#### Illustrate running a replicated vs global service ####

```
docker service create --name testhttpd -p 80:80 httpd
docker service scale testhttpd=6
```
launch service in global mode... application is deployed on ALL the nodes, maar geen replicas meer
```
docker service create --name testnginx -p 6000:80 --mode global nginx
docker service ls
docker service update --replicas=12 testnginx
docker service scale --replicas=12 testnginx
docker service update --mode replicated testnginx
```
service update mode bestaat niet! droppen en weggooien als je wil converten naar replicated mode

---

#### Identify the steps needed to troubleshoot a service not deploying ####

Zijn alle nodes available?
```
docker node ls
```

Draait de service? Is het probleem bij een van de tasks(replica's) 
```
docker service ps [servicenaam]
```
```
docker service inspect [servicenaam]
```
Labels gebruikt? Constraints gebruikt?

SELinux issues?

---

https://github.com/DevOps-Academy-Org/dca-prep-guide

https://asciinema.org/a/jwoYTaAYr4LEqhYBuRkEI9ets

---

#### Apply node labels to demonstrate placement of tasks ####

Met node labels bepaal je hoe en waar docker services draaien in je swarm.

```
docker node inspect (--pretty)
docker node ls
docker node update --label-add mynode=testnode worker1
docker node inspect --pretty worker1
```
---
Met constraints kun je bepalen waar dit gaat draaien.
* node.id
* node.hostname
* node.role
* engine.labels
* node.labels
* node.platform.os (bij hybrid swarm clusters?)

---

```
docker service create --name constraints -p 80:80 --constraint 'node.labels.mynode == testnode' --replicas 6 httpd
docker service ps constraints
docker service create --name normal nginx
docker service ps normal
docker service ls
docker service update --replicas 3 normal
dokcer service ps normal
docker service ps constraints
```

https://docs.docker.com/engine/reference/commandline/service_create/



---

#### Sketch how a Dockerized application communicates with legacy systems ####

Legacy? Of ieder ander systeem... dat zou niet uit moeten maken

---

#### Paraphrase the importance of quorum in a swarm cluster ####

Ieder swarm heeft 1 tot N manager nodes. Het liefst een oneven aantal.

Manager nodes zijn verantwoordelijk voor managing,directing,logging en reporting lifecycle van de swarm.

Raft Consensus Algoritme wordt gebruikt om de swarm state te managen

---

Raft kan (N-1)/2 failures aan.

Heeft meerderheid (quorum) nodig van (N/2)+1 voor nieuwe instructies op swarm cluster

---

Swarmsize | Majority | Fault tolerance
--- | --- | ---
1|1|1
2|2|0
3|2|1
4|3|1
5|3|2
6|4|2
7|4|3
8|5|3
9|5|4

---

Requirements/Considerations

* Vervang "failed" managers zsm
* Distribute manager nodes voor high availability
* Monitor swarm health. 
* Backup/recovery plan voor je swarm

---

Swarm manager nodes | Repartition op HA zones
---|---
3|1-1-1
5|2-2-1
7|3-2-2
9|3-3-3

---

* Run manager only nodes (docker node update --availability drain [node])
* Force rebalance: docker service update --force

---

https://raft.github.io/




---

#### Demonstrate the usage of templates with "docker service create" ####

docker service create --name

```
docker service create --name hosttempl --constraint node.role==manager --hostname="{{.Node.Hostname}}-{{.Node.ID}}-{{.Service.Name}}" busybox top
docker service ps --no-trunc hosttempl
docker inspect --format="{{.Config.Hostname}}" hosttempl.1.c8vum6slt93jcf9tg0rn54q8l
```
of
```
docker service ps hosttempl
docker inspect c8 --format "{{json .Status}}"
docker inspect --format="{{.Config.Hostname}}" 7c
```
```
docker service rm hosttempl
```
---

Thanks!