# Troubleshooting-Protokoll

## INC-001 – systemd-Zustand „degraded“ unter WSL2

**Datum:** 04.09.2026  
**Umgebung:** Ubuntu 24.04 LTS unter WSL2

### Symptom

Der Befehl `systemctl is-system-running` meldete den Zustand `degraded`.

### Diagnose

Folgende Prüfungen wurden durchgeführt:

```bash
systemctl --failed --no-pager
systemctl status getty@tty1.service --no-pager --full
journalctl --unit=getty@tty1.service --lines=30 --no-pager
ls -l /dev/tty1
systemctl is-enabled getty@tty1.service
```

`getty@tty1.service` befand sich im Zustand `failed`. Der Prozess `agetty` wurde mit dem Signal `HUP` beendet. Nach mehreren Startversuchen wurde zusätzlich `start-limit-hit` erreicht.

### Ursache

Der Dienst war aktiviert, obwohl WSL2 über `wsl.exe` und ein Pseudo-Terminal verwendet wird. Eine klassische lokale Anmeldung über die virtuelle Konsole `tty1` wird in dieser Laborumgebung nicht benötigt.

### Lösung

Der nicht benötigte Dienst wurde deaktiviert und sein Fehlerzustand zurückgesetzt:

```bash
sudo systemctl disable --now getty@tty1.service
sudo systemctl reset-failed getty@tty1.service
```

### Validierung

```bash
systemctl is-system-running
systemctl --failed --no-pager
```

Ergebnis:

```text
running
0 loaded units listed
```

### Rollback

Falls die virtuelle Konsole später benötigt wird:

```bash
sudo systemctl enable --now getty@tty1.service
```

### Hinweis

Diese Änderung gilt nur für die WSL2-Laborumgebung. Auf einem realen Linux-Server darf ein Konsolendienst nicht ohne Prüfung deaktiviert werden.

## INC-002 – Nginx-Webdienst nicht erreichbar

**Umgebung:** Nginx unter Docker Compose

### Symptom

Der Linux-Health-Check meldete:

```text
[WARN] Nginx HTTP service is unavailable
Overall status: WARNING
Exit code: 1
```

### Diagnose

```bash
docker compose -f docker/compose.yaml ps -a
docker compose -f docker/compose.yaml logs --tail=10 web
```

Die Netzwerk- und DNS-Prüfungen waren erfolgreich. Nur der HTTP-Port `8080` war nicht erreichbar. Der Nginx-Container befand sich im gestoppten Zustand.

### Ursache

Der Container wurde für einen kontrollierten Ausfalltest manuell gestoppt.

### Wiederherstellung

```bash
docker compose -f docker/compose.yaml start web
```

### Validierung

```bash
./bash/health-check.sh
docker inspect --format='{{.State.Health.Status}}' asta-it-operations-lab-web-1
```

Ergebnis:

```text
[OK] Nginx HTTP service
Overall status: OK
Exit code: 0
healthy
```

### Ergebnis

Der Ausfall wurde erkannt, eingegrenzt und ohne Datenverlust behoben.