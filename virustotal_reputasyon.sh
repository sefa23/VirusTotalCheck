#!/bin/bash

# VirüsTotal API anahtarını ayarlayın
VT_API_KEY="VirüsTotal API KEY"

# Dosya hash'lerini alın
read -p "Dosya hash'lerini girin (birkaç hash'i virgülle ayırın): " file_hashes

# VirüsTotal API'sine istek gönderin
response=$(curl -s -X GET "https://www.virustotal.com/api/v3/files/$file_hashes/scans" -H "x-apikey: $VT_API_KEY")

# Yanıtı JSON olarak dönüştürün
data=$(echo "$response" | jq -r '. | to_entries | map(.value) | .[] | .response | .detected')

# Dosyaların itibarını değerlendirin
for hash in $file_hashes; do
  if [ "$data" == "true" ]; then
    echo "Dosya $hash kötü amaçlı yazılım içerdiği tespit edildi."
  else
    echo "Dosya $hash kötü amaçlı yazılım içermediği tespit edildi."
  fi
done
