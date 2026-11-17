#!/bin/bash
# Script principal d'envoi Sentinel-APP

DOSSIER="/opt/SIGNAL-APP"
FICHIER_SECRET="$DOSSIER/secret.txt"
SCRIPT_LANCEMENT="$DOSSIER/lancement.sh"
MESSAGE="$1"

# Vérifie si le fichier secret existe, sinon lance la configuration
if [ ! -f "$FICHIER_SECRET" ]; then
    echo "ATTENTION : Sentinel-APP n'est pas configuré. Lancement de l'initialisation..."
    bash "$SCRIPT_LANCEMENT"
    
    # Vérifie à nouveau si l'initialisation a réussi avant de continuer
    if [ ! -f "$FICHIER_SECRET" ]; then
        echo "IMPOSSIBLE : Échec de la configuration. Envoi du message annulé."
        exit 1
    fi
fi

# Charge le numéro depuis le fichier secret
NUMERO=$(cat "$FICHIER_SECRET")

# Envoi du message en tâche de fond
signal-cli -u "$NUMERO" send -m "$MESSAGE" "$NUMERO" > /dev/null 2>&1 &
