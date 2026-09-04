# Architektur

## Zweck

Das „AStA IT Operations & Recovery Lab“ ist ein privates Lernprojekt. Es bildet ausgewählte Aufgaben der IT-Systemadministration mit vorhandener Hardware und geringem Speicherverbrauch nach.

Es handelt sich nicht um eine produktive Infrastruktur des AStA.

## Geplante Architektur

```text
Windows-11-Laptop
├── PowerShell
│   └── System- und Netzwerkdiagnose
├── Ubuntu unter WSL 2
│   ├── Linux-Administration
│   ├── Bash
│   └── Ansible
└── Docker Desktop
    └── asta-lab Netzwerk
        ├── Nginx
        ├── Uptime Kuma
        └── Testdienst

Lokales Netzwerk
└── Windows-10-PC
    └── Externer Testclient

USB-Speicher
└── Verschlüsselte Backups von Testdaten
```

## Komponenten

### Windows 11

Der Laptop dient als Administrationsarbeitsplatz. PowerShell wird für Inventarisierung, Dienstprüfung und Netzwerkdiagnose verwendet.

### Ubuntu unter WSL 2

Ubuntu dient als Linux-Lernumgebung für Benutzer, Gruppen, Dateiberechtigungen, Prozesse, Dienste, Logs, Bash und Ansible.

### Docker Desktop

Docker stellt isolierte Dienste bereit. Die Container werden später mit Docker Compose beschrieben und reproduzierbar gestartet.

### Windows-10-Testclient

Der zusätzliche PC kann HTTP- und Netzwerkverbindungen zum Laptop testen. Vor seiner Verwendung wird der Sicherheits- und Updatezustand geprüft.

### USB-Backupziel

Der USB-Speicher enthält ausschließlich kleine, künstlich erzeugte Testdaten und verschlüsselte Backups. Eine Wiederherstellung wird praktisch getestet.

## Sicherheitsgrenzen

- Keine produktiven oder personenbezogenen Daten
- Keine Passwörter, Tokens oder privaten Schlüssel im Git-Repository
- Keine ungeprüften Änderungen an vorhandenen Docker-Containern
- Keine Nutzung der persönlichen VirtualBox-VM für Experimente
- Maximal 4 GB zusätzlicher Speicherverbrauch
- Installationsstopp bei weniger als 35 GB freiem Speicher auf C:

## Technische Einschränkung

WSL 2 ist keine vollständig unabhängige Servermaschine. Netzwerk-, Firewall- und Hardwaretests werden deshalb nur innerhalb der dokumentierten Grenzen bewertet.