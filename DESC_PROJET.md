AStA IT Operations & Recovery Lab
Il utilisera uniquement ce que tu possèdes déjà et demandera approximativement 5 à 8 Go supplémentaires, avec une limite stricte d’espace disque.
Architecture compacte
┌──────────────────── Portable Windows 11 ────────────────────┐
│                                                             │
│  PowerShell                    Ubuntu sous WSL 2             │
│  ├── inventaire système       ├── utilisateurs/groupes     │
│  ├── services                 ├── permissions              │
│  ├── réseau                   ├── Bash                     │
│  └── rapport automatique      ├── systemd/logs             │
│                               └── Ansible                   │
│                                                             │
│  Docker Desktop                                             │
│  └── réseau asta-lab                                       │
│      ├── Nginx                                              │
│      ├── Uptime Kuma                                        │
│      └── petit service de test                              │
└───────────────────────────┬─────────────────────────────────┘
                            │ réseau local
                 ┌──────────▼──────────┐
                 │ PC Windows 10       │
                 │ client de test      │
                 └─────────────────────┘

                 Clé USB 8 Go
                 └── backups chiffrés de données de TEST
WSL permet d’utiliser de vrais outils Linux et Bash sans créer une VM traditionnelle lourde. Les versions récentes prennent également en charge systemd, ce qui permet de travailler avec des services Linux. Documentation WSL, prise en charge de systemd
Docker Desktop utilise déjà WSL 2 et alloue dynamiquement ses ressources. Nous limiterons volontairement le nombre et la taille des images. Architecture Docker Desktop avec WSL 2
Ce que tu réaliseras réellement
1. Administration Windows
Tu créeras un script PowerShell produisant un rapport professionnel :
- nom de la machine ;
- version Windows ;
- processeur, mémoire et stockage ;
- configuration IP ;
- état de Defender et du pare-feu ;
- services importants ;
- connexions réseau.
2. Administration Linux dans WSL
Dans Ubuntu WSL, tu pratiqueras réellement :
- utilisateurs et groupes de test ;
- sudo ;
- permissions, chmod et chown ;
- processus ;
- paquets ;
- arborescence Linux ;
- services systemd ;
- logs avec journalctl ;
- Bash et diagnostics réseau.
Limite honnête : WSL ne remplace pas complètement un serveur indépendant. Nous ne prétendrons donc pas avoir administré un vrai DHCP, un routeur ou un pare-feu Linux de production.
3. Petit service Docker
Tu déploieras avec Docker Compose :
- une page Nginx « Mini-AStA IT Status » ;
- Uptime Kuma ;
- un réseau Docker isolé ;
- des volumes persistants ;
- des health checks ;
- une limite de mémoire ;
- une politique de redémarrage.
4. Monitoring et incident
Tu provoqueras des incidents contrôlés :
- container arrêté ;
- mauvais port ;
- erreur de configuration Nginx ;
- fichier avec une permission incorrecte ;
- test HTTP défaillant.
Pour chaque incident, tu produiras un ticket en allemand :
Symptom
Auswirkung
Diagnoseschritte
Ursache
Lösung
Validierung
Präventionsmaßnahme
C’est particulièrement intéressant pour le poste : tu montreras ta manière de diagnostiquer, pas seulement un service qui fonctionne.
5. Backup et restauration obligatoire
Nous sauvegarderons uniquement un petit jeu de données fictives et les configurations du projet sur ta clé USB.
Avec Restic, tu pourras démontrer :
- sauvegarde chiffrée ;
- snapshots ;
- contrôle d’intégrité ;
- suppression volontaire d’un fichier de test ;
- restauration ;
- comparaison du fichier restauré.
Restic prend en charge les dépôts chiffrés, la restauration et la vérification d’intégrité. Documentation Restic
6. Infrastructure as Code
Ansible fonctionnera depuis Ubuntu WSL. Le premier playbook configurera progressivement l’environnement Linux local ou une cible jetable :
- groupe et utilisateur de test ;
- répertoires ;
- permissions ;
- paquets ;
- fichiers de configuration ;
- service contrôlé.
Nous exécuterons le playbook deux fois : la seconde exécution devra idéalement afficher changed=0. Cette idempotence est précisément l’un des principes d’Ansible. Documentation Ansible
7. Documentation et GitHub
Le dépôt pourrait s’appeler :
asta-it-operations-lab/
├── README.md
├── docs/
│   ├── architektur.md
│   ├── sicherheitskonzept.md
│   ├── backup-restore-test.md
│   ├── onboarding.md
│   ├── offboarding.md
│   └── stoerungsprotokolle/
├── powershell/
│   └── system-report.ps1
├── bash/
│   └── health-check.sh
├── docker/
│   ├── compose.yaml
│   └── nginx/
├── ansible/
│   ├── inventory.ini
│   └── playbook.yml
└── screenshots/
La documentation professionnelle sera en allemand afin de démontrer ta capacité à travailler dans la langue du poste. Je continuerai à t’expliquer les concepts en français.
Ce qui te démarquera
À la fin, tu pourras faire une démonstration de cinq minutes :
1. présenter l’architecture ;
2. générer le rapport PowerShell ;
3. afficher les services Docker ;
4. provoquer l’arrêt du service web ;
5. diagnostiquer la panne avec les logs ;
6. remettre le service en fonctionnement ;
7. restaurer un fichier supprimé ;
8. montrer un second lancement Ansible sans changement.
C’est beaucoup plus convaincant qu’une liste de technologies dans un CV.
Tu pourras honnêtement écrire que tu as pratiqué :
- administration Linux sous WSL ;
- diagnostic Windows avec PowerShell ;
- Docker Compose et monitoring ;
- sauvegarde chiffrée et restauration testée ;
- automatisation Ansible ;
- documentation d’incidents et procédures ;
- Git avec contrôle des secrets.