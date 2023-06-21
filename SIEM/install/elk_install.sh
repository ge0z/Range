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
echo "[+] Téléchargment du dépot docker-elk"
git clone https://github.com/ge0z/docker-elk.git

# 2. Installation et lancement de docker-elk
echo "[+] Installation de la pile ELK"
cd docker-elk
docker-compose up setup
docker-compose up -d
# 3. Installation d'un serveur Fleet
echo "[+] Installation d'un serveur fleet"
docker-compose -f docker-compose.yml -f extensions/fleet/fleet-compose.yml up -d

