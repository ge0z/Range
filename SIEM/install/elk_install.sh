#!/bin/bash
# geoz
# 16/06/2023

# Déploiement d'une pile ELK docker dans WSL2
# Prérerquis :
#  - docker
#  - docker-compose
#  - git
# ref : https://newtonpaul.com/how-to-install-elastic-siem-and-elastic-edr/

# 1. Téléchargement de docker-elk
git clone https://github.com/deviantony/docker-elk.git

# 2. Installation et lancement de docker-elk
cd docker-elk
docker-compose up setup
docker-compose up

# 3. Installation d'un serveur Fleet
# 3.1 Téléchargement de l'agent
getAgent="curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.8.1-linux-x86_64.tar.gz; tar xzvf elastic-agent-8.8.1-linux-x86_64.tar.gz"
docker exec -it -u 0 docker-elk-elasticsearch-1 $getAgent
# 3.2 Récupération d'un token elasticsearch
request="curl -X POST "localhost:9200/_security/service/elastic/fleet-server/credential/token/token1?pretty" -u elastic:changeme"
token=`$request | grep value | cut -d "\"" -f4`
# 3.3 Installation de l'agent
intsallAgent="elastic-agent-8.8.1-linux-x86_64/elastic-agent install --fleet-server-es=http://elasticsearch:9200 --fleet-server-service-token=$token --fleet-server-policy=fleet-server-policy --fleet-server-port=8220"
docker exec -it -u 0 docker-elk-elasticsearch-1 $installAgent