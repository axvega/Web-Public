#!/bin/bash

# Script de despliegue automático para Hugo
# Autor: Ángel Vega
# Descripción: Genera el sitio estático y lo despliega automáticamente

set -e  # Salir si hay algún error

echo "======================================"
echo "  DESPLIEGUE AUTOMÁTICO - HUGO"
echo "======================================"

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para mensajes de éxito
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Función para mensajes de información
info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Función para mensajes de error
error() {
    echo -e "${RED}✗ $1${NC}"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "hugo.toml" ]; then
    error "Error: No se encuentra hugo.toml. ¿Estás en el directorio del proyecto?"
    exit 1
fi

# Paso 1: Guardar cambios en el repositorio de desarrollo
info "Paso 1: Guardando cambios en el repositorio de desarrollo..."
git add .
read -p "Mensaje del commit: " commit_msg
git commit -m "$commit_msg" || info "No hay cambios para commitear"
success "Cambios guardados en desarrollo"

# Paso 2: Generar el sitio estático
info "Paso 2: Generando sitio estático con Hugo..."
hugo --cleanDestinationDir
success "Sitio generado en el directorio public/"

# Paso 3: Desplegar en el repositorio de producción
info "Paso 3: Desplegando en producción..."

cd public

# Verificar si existe el repositorio git en public
if [ ! -d ".git" ]; then
    error "No existe repositorio Git en public/. Inicializando..."
    git init
    git branch -M main
    read -p "URL del repositorio remoto de producción: " remote_url
    git remote add origin "$remote_url"
fi

# Añadir todos los cambios
git add -A

# Commit con timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
git commit -m "Despliegue automático - $timestamp" || info "No hay cambios para desplegar"

# Push al repositorio remoto
info "Subiendo cambios al repositorio de producción..."
git push origin main -f || error "Error al hacer push. Verifica la configuración del repositorio remoto."

cd ..

success "======================================"
success "  ¡DESPLIEGUE COMPLETADO CON ÉXITO!"
success "======================================"

echo ""
info "Resumen:"
echo "  - Cambios guardados en desarrollo"
echo "  - Sitio regenerado"
echo "  - Cambios desplegados en producción"
echo ""

# Opcional: Mostrar la URL del sitio (si está configurada en hugo.toml)
base_url=$(grep -oP "baseURL\s*=\s*['\"]?\K[^'\"]*" hugo.toml)
if [ ! -z "$base_url" ]; then
    info "Tu sitio está disponible en: $base_url"
fi
