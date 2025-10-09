#!/bin/bash

set -e

echo "Generando sitio..."
hugo --minify

echo "Desplegando..."
cd public

git add -f .
git commit -m "Update $(date +"%d/%m/%Y")" 2>/dev/null || true
git push origin main

echo "Sitio guardado correctamente en" https://web-angel1.netlify.app/
