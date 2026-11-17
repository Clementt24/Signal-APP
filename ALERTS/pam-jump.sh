#!/bin/bash
if [ "$PAM_TYPE" != "open_session" ]; then exit 0; fi

(
    sleep 3
    
    DEST_INFO=$(ss -tnp 2>/dev/null | awk '/sshd/ {print $4, $5}' | awk '$1 !~ /:22$/ {print $2}' | head -n 1)
    
    if [ -n "$DEST_INFO" ]; then
        DEST_IP="${DEST_INFO%:*}"
        
        # Sécurité : si l'IP détectée est celle du Raspberry Pi, on ignore l'alerte
        if [ "$DEST_IP" == "192.168.1.25" ]; then
            exit 0
        fi
        
        # Correspondance des noms
        case "$DEST_IP" in
            "192.168.1.24")  DEST_NAME="TOUR-Clement" ;;
            "192.168.1.48")  DEST_NAME="SERVEUR-NAS" ;;
            "192.168.1.54")  DEST_NAME="SERVEUR-THOMSON" ;;
            "192.168.1.71")  DEST_NAME="SERVEUR-1" ;;
            "192.168.1.166") DEST_NAME="DELL-15" ;;
            "192.168.1.156") DEST_NAME="SERVEUR-DELL" ;;
            "192.168.1.196") DEST_NAME="SERVEUR-2" ;;
            *)               DEST_NAME="Hôte Inconnu" ;;
        esac
        
# Nouveau message personnalisé
    MESSAGE="🔀 INFO : Le SERVEUR DE REBOND achemine du trafic vers la cible $DEST_NAME ($DEST_IP) (Avec l'utilisateur $PAM_USER depuis $PAM_RHOST)"
    
    # Ligne corrigée avec des guillemets doubles (\") pour supporter les apostrophes
    su - "$PAM_USER" -c "/usr/local/bin/signal-cli send -m \"$MESSAGE\" -g \"xBFH8WO+gGPTXaE1cwjI3QjL8miQvKvRLXa7VPRZXh4\"" >/dev/null 2>&1
fi
) &
