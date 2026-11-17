#!/bin/bash
FICHIER_SECRET="/opt/SIGNAL-APP/secret.txt"
echo "🛡️ Initialisation de Sentinel-APP 🛡️"
read -p "Entrez le numéro de la ligne fixe (ex: +33270296426) : " NUMERO

echo ""
echo "⚠️ Signal exige une vérification humaine."
echo "1. Sur ton PC, va sur : https://signalcaptchas.org/registration/generate.html"
echo "2. Résous le Captcha."
echo "3. Fais un clic-droit sur le bouton 'Open Signal' qui apparaît et clique sur 'Copier l'adresse du lien'."
echo ""
read -p "Collez le lien complet ici (il doit commencer par signalcaptcha://) : " CAPTCHA

echo ""
echo "Étape 1/2 : Validation humaine et SMS fantôme..."
signal-cli -u "$NUMERO" register --captcha "$CAPTCHA"

echo "Attente de 65 secondes pour débloquer l'appel vocal..."
sleep 65

echo "Étape 2/2 : Demande d'appel vocal en cours vers $NUMERO..."
signal-cli -u "$NUMERO" register --voice

echo ""
read -p "Entrez le code à 6 chiffres dicté par le téléphone : " CODE

echo "Vérification en cours..."
signal-cli -u "$NUMERO" verify "$CODE"

if [ $? -eq 0 ]; then
echo "$NUMERO" > "$FICHIER_SECRET"
chmod 600 "$FICHIER_SECRET"
echo "✅ Configuration terminée ! Le numéro est sauvegardé dans secret.txt."
else
echo "IMPOSSINLE:  Erreur lors de la vérification. Veuillez réessayer."
exit 1
fi
