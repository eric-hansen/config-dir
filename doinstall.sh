#!/bin/sh

echo "Searching for install scripts to execute..."

for script in $(find . -type f -name "install.sh"); do
  echo "[>>] Executing install script $script"
  sh $script
done
