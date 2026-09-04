# AStA IT Operations & Recovery Lab

## Projektziel

Dieses Projekt dokumentiert den Aufbau eines kompakten Lernlabors für IT-Systemadministration. Es dient dazu, grundlegende Aufgaben aus den Bereichen Windows, Linux, Netzwerke, Container, Monitoring, Automatisierung sowie Backup und Wiederherstellung praktisch zu üben.

Das Labor verwendet vorhandene Ressourcen und arbeitet ausschließlich mit Testdaten.

## Architektur

Geplante Komponenten:

- Windows 11 als Administrationsarbeitsplatz
- Ubuntu unter WSL 2 als Linux-Lernumgebung
- Docker Desktop für containerisierte Dienste
- Windows 10 als zusätzlicher Testclient
- USB-Speicher für verschlüsselte Test-Backups
- Git für Versionsverwaltung und technische Dokumentation

## Sicherheitsgrundsätze

- Keine Passwörter, Tokens oder privaten Schlüssel im Git-Repository
- Keine persönlichen oder produktiven Daten in Tests
- Keine ungeprüfte Löschung vorhandener Container, Volumes oder Dateien
- Dokumentation jeder absichtlich erzeugten Störung
- Überprüfung jeder Wiederherstellung
- Installationsstopp bei weniger als 35 GB freiem Speicher auf C:

## Aktueller Projektstand

Abgeschlossen:

- Inventarisierung der vorhandenen Hardware
- Prüfung der Virtualisierungsumgebung
- Analyse des Speicherverbrauchs von WSL und Docker
- Festlegung eines zusätzlichen Speicherbudgets von maximal 4 GB
- Initialisierung des lokalen Git-Repositorys

Noch nicht umgesetzt:

- PowerShell-Systembericht
- Linux-Health-Check
- Docker-Compose-Dienste
- Monitoring
- Backup und Restore
- Ansible-Automatisierung
- Störungsszenarien

## Hinweis zur Lernumgebung

WSL 2 bietet eine echte Linux-Umgebung, ersetzt jedoch keinen vollständig unabhängigen Server. Ergebnisse und Kompetenzen werden deshalb im Projekt transparent und ohne Übertreibung dokumentiert.