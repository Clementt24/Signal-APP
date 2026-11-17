#!/bin/bash
GROUP_ID="xBFH8WO+gGPTXaE1cwjI3QjL8miQvKvRLXa7VPRZXh4"
USER_NAME="${USER:-$PAM_USER}"
CLIENT_IP="${SSH_CONNECTION%% *}"

/usr/local/bin/signal-cli send -m "⚠️ INFO : Connexion SSH réussie sur le SERVEUR DE REBOND avec l'utilisateur : $USER_NAME depuis $CLIENT_IP" -g "$GROUP_ID" >/dev/null 2>&1 &
