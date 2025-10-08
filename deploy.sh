#!/bin/bash

# Despliegue Hugo - Versión definitiva
set -e

echo "Generando sitio..."
hugo --minify

echo "🚀Desplegando..."
cd public

# Forzar add ignorando los .gitignore del directorio padre
git add -f .
git commit -m "Update $(date +"%d/%m/%Y")" 2>/dev/null || true
git push origin main

echo "Sitio desplegado en GitHub Pages"
