#!/usr/bin/env bash
set -u
overall_status=0

echo "=== AStA IT Operations - Linux Health Check ==="
printf "Generated: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')"
printf "Hostname: %s\n" "$(hostname)"
printf "Kernel: %s\n" "$(uname -r)"
printf "Uptime: %s\n" "$(uptime -p)"
printf "Load average: %s\n" "$(cut -d ' ' -f1-3 /proc/loadavg)"

echo
echo "--- Memory ---"
free -h

echo
echo "--- Root filesystem ---"
df -h /

echo
echo "--- systemd ---"
systemctl is-system-running
echo
echo "--- Network ---"

if ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
    echo "[OK] IP connectivity"
else
    echo "[WARN] IP connectivity failed"
    overall_status=1
fi

if getent hosts ubuntu.com >/dev/null 2>&1; then
    echo "[OK] DNS resolution"
else
    echo "[WARN] DNS resolution failed"
    overall_status=1
fi


# Erreichbarkeit des Nginx-Webservers prüfen
if curl --fail --silent --show-error --max-time 3 \
    http://127.0.0.1:8080/ >/dev/null; then
    echo "[OK] Nginx HTTP service"
else
    echo "[WARN] Nginx HTTP service is unavailable"
    overall_status=1
fi

echo
echo "--- Services ---"

check_service() {
    local service_name="$1"

    if systemctl is-active --quiet "$service_name"; then
        echo "[OK] Service $service_name is active"
    else
        echo "[WARN] Service $service_name is not active"
        overall_status=1
    fi
}

check_service "systemd-journald"
check_service "systemd-resolved"

echo "--- Ressourcenauslastung ---"

# CPU-Leerlauf mit zwei Messungen im Abstand von einer Sekunde ermitteln
cpu_idle=$(vmstat 1 2 | tail -n 1 | awk '{print $15}')

# CPU-Auslastung aus dem Leerlauf berechnen
cpu_used=$((100 - cpu_idle))

# Verwendeten Arbeitsspeicher in Prozent berechnen
memory_used=$(free | awk '/^Mem:/ {
    printf "%.0f", ($3 / $2) * 100
}')

# Belegten Speicherplatz des Root-Dateisystems ermitteln
# gsub entfernt das Prozentzeichen
disk_used=$(df -P / | awk 'NR==2 {
    gsub("%", "", $5)
    print $5
}')

# Warnung ausgeben, wenn die CPU-Auslastung mindestens 90 % beträgt
if (( cpu_used >= 90 )); then
    echo "[WARN] CPU-Auslastung: ${cpu_used}%"
    overall_status=1
else
    echo "[OK] CPU-Auslastung: ${cpu_used}%"
fi

# Warnung ausgeben, wenn die Speicherauslastung mindestens 80 % beträgt
if (( memory_used >= 80 )); then
    echo "[WARN] Speicherauslastung: ${memory_used}%"
    overall_status=1
else
    echo "[OK] Speicherauslastung: ${memory_used}%"
fi

# Warnung ausgeben, wenn das Root-Dateisystem mindestens 80 % belegt ist
if (( disk_used >= 80 )); then
    echo "[WARN] Festplattenauslastung: ${disk_used}%"
    overall_status=1
else
    echo "[OK] Festplattenauslastung: ${disk_used}%"
fi


echo

if (( overall_status == 0 )); then
    echo "Overall status: OK"
else
    echo "Overall status: WARNING"
fi
echo

exit "$overall_status"
