# Comandos GCP para Provisionamiento

## Configuración Inicial de Google Cloud Platform

### Prerrequisitos
- Cuenta de Google Cloud Platform activa
- gcloud SDK instalado en tu máquina local
- Proyecto de GCP creado (ej: "library-app-2024")

### 1. Autenticación con GCP

```bash
# Login en gcloud
gcloud auth login

# Establecer proyecto por defecto
gcloud config set project sistemas-integracion-01

# Verificar configuración
gcloud config list
```

---

## 2. Crear VPC (Virtual Private Cloud)

```bash
# Crear VPC
gcloud compute networks create maquina01 \
    --subnet-mode=custom \
    --description="VPC for Library Application"

# Crear subred en us-central1
gcloud compute networks subnets create library-subnet \
    --network=maquina01 \
    --region=us-central1 \
    --range=10.0.1.0/24 \
    --enable-flow-logs
```

---

## 3. Configurar Firewall Rules

```bash
# Permitir SSH desde Internet (temporal para setup)
gcloud compute firewall-rules create library-allow-ssh \
    --network=library-vpc \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0 \
    --description="Allow SSH from anywhere (setup only)"

# Permitir HTTP
gcloud compute firewall-rules create library-allow-http \
    --network=library-vpc \
    --allow=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --description="Allow HTTP traffic"

# Permitir HTTPS
gcloud compute firewall-rules create library-allow-https \
    --network=library-vpc \
    --allow=tcp:443 \
    --source-ranges=0.0.0.0/0 \
    --description="Allow HTTPS traffic"

# Permitir tráfico interno entre VM y Cloud SQL
gcloud compute firewall-rules create library-allow-internal \
    --network=library-vpc \
    --allow=tcp,udp \
    --source-ranges=10.0.1.0/24 \
    --description="Allow internal traffic"

# Denegar SSH desde internet (después de setup)
# gcloud compute firewall-rules update library-allow-ssh --source-ranges=YOUR_IP/32
```

---

## 4. Crear Instancia de Compute Engine

```bash
# Variable de configuración
INSTANCE_NAME="library-app-vm"
ZONE="us-central1-a"
MACHINE_TYPE="n1-standard-2"          # 2 vCPU, 7.5GB RAM
IMAGE_FAMILY="centos-stream-10"
IMAGE_PROJECT="centos-cloud"
NETWORK="library-vpc"
SUBNET="library-subnet"

# Crear instancia
gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --image-family=$IMAGE_FAMILY \
    --image-project=$IMAGE_PROJECT \
    --network-interface=network=$NETWORK,subnet=$SUBNET,no-address \
    --tags=http-server,https-server \
    --metadata-from-file startup-script=./startup.sh \
    --enable-display-device \
    --maintenance-policy=MIGRATE \
    --scopes=https://www.googleapis.com/auth/cloud-platform

# Asignar IP estática externa
gcloud compute addresses create library-ip-static \
    --region=us-central1

# Asociar IP estática a instancia
gcloud compute instances add-access-config $INSTANCE_NAME \
    --zone=$ZONE \
    --address=library-ip-static

# Ver detalles de la instancia
gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE
```

---

## 5. Crear Cloud SQL Instance (PostgreSQL)

```bash
# Variables
SQL_INSTANCE="library-postgres-db"
SQL_REGION="us-central1"
SQL_VERSION="POSTGRES_14"           # PostgreSQL 14
TIER="db-n1-standard-1"             # 1 vCPU, 3.75GB RAM

# Crear instancia PostgreSQL
gcloud sql instances create $SQL_INSTANCE \
    --database-version=$SQL_VERSION \
    --tier=$TIER \
    --region=$SQL_REGION \
    --network=$NETWORK \
    --backup-start-time=03:00 \
    --retained-backups-count=30 \
    --enable-bin-log \
    --database-flags=cloudsql_iam_authentication=on,log_statement=all

# Esperar a que se cree (tarda ~3-5 min)
gcloud sql operations wait --project=library-app-2024

# Crear base de datos
gcloud sql databases create library_db \
    --instance=$SQL_INSTANCE

# Crear usuario de aplicación
gcloud sql users create library_user \
    --instance=$SQL_INSTANCE \
    --password=CHANGE_ME_STRONG_PASSWORD

# Obtener IP privada de Cloud SQL
gcloud sql instances describe $SQL_INSTANCE \
    --format="value(ipAddresses[0].ipAddress)"
```

---

## 6. Conectarse a la Instancia VM

```bash
# SSH en la instancia
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE

# O usar gcloud compute ssh con puerto específico
gcloud compute ssh $INSTANCE_NAME \
    --zone=$ZONE \
    --tunnel-through-iap     # Si usas Identity-Aware Proxy
```

---

## 7. Instalación de Software en la VM (CentOS Stream 10)

### En la máquina local, crear script de inicio:

```bash
# startup.sh - Ejecutado automáticamente en boot
#!/bin/bash

# Actualizar sistema
sudo yum update -y
sudo yum upgrade -y

# Instalar Node.js 18+ desde NodeSource
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Instalar PostgreSQL client
sudo yum install -y postgresql

# Instalar Git
sudo yum install -y git

# Instalar Nginx (opcional, como reverse proxy)
sudo yum install -y nginx

# Crear directorio de aplicación
sudo mkdir -p /opt/library-app
sudo chown -R $(whoami):$(whoami) /opt/library-app
cd /opt/library-app

# Clonar repositorio (si aplica)
# git clone https://github.com/usuario/library-app.git .

# Instalar dependencias Node
npm install

# Crear directorio para logs
mkdir -p logs
mkdir -p uploads

# Crear archivo .env (reemplazar valores)
cat > .env << 'EOF'
NODE_ENV=production
PORT=3000
DB_HOST=CLOUD_SQL_PRIVATE_IP
DB_PORT=5432
DB_NAME=library_db
DB_USER=library_user
DB_PASSWORD=CHANGE_ME_STRONG_PASSWORD
SESSION_SECRET=CHANGE_ME_RANDOM_SECRET_KEY
BCRYPT_ROUNDS=10
CORS_ORIGIN=http://YOUR_STATIC_IP
EOF

# Hacer archivo .env legible solo por usuario
chmod 600 .env

# Instalar PM2 para process management
sudo npm install -g pm2

# Iniciar aplicación con PM2
pm2 start app.js --name library-app
pm2 startup
pm2 save

# Configurar Nginx como reverse proxy (opcional)
sudo systemctl enable nginx
sudo systemctl start nginx
```

### Ejecutar manualmente en la VM:

```bash
# Conectarse a VM
gcloud compute ssh library-app-vm --zone=us-central1-a

# Una vez dentro de la VM:

# Actualizar sistema
sudo yum update -y

# Instalar Node.js
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Instalar PostgreSQL client para pruebas
sudo yum install -y postgresql

# Crear directorio de app
sudo mkdir -p /opt/library-app
cd /opt/library-app

# Clonar o copiar código
# scp -r ./library-app gcloud-user@INSTANCE_IP:/opt/library-app/

# Instalar dependencias
npm install

# Copiar y configurar .env
nano .env
# (Reemplazar valores: DB_HOST, DB_PASSWORD, etc)

# Iniciar aplicación
npm start
```

---

## 8. Pruebas de Conectividad

```bash
# Desde la VM, probar conexión a Cloud SQL
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE

# Dentro de la VM:
psql -h CLOUD_SQL_PRIVATE_IP -U library_user -d library_db

# Si conecta, escribir:
SELECT version();
\q

# Probar aplicación localmente
curl http://localhost:3000/health

# O desde tu máquina local
curl http://STATIC_IP:3000/health
```

---

## 9. Configurar Nginx como Reverse Proxy (Opcional)

### En la VM, editar configuración de Nginx:

```bash
sudo nano /etc/nginx/sites-available/library

# Agregar contenido:
server {
    listen 80;
    server_name _;

    client_max_body_size 2M;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}

# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/library /etc/nginx/sites-enabled/

# Verificar configuración
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
```

---

## 10. Ejecutar Scripts SQL de Inicialización

### Desde tu máquina local, copiar scripts a VM:

```bash
# Copiar scripts SQL a VM
gcloud compute scp ./db/00_create_database.sql \
    $INSTANCE_NAME:/tmp/00_create_database.sql \
    --zone=$ZONE

gcloud compute scp ./db/01_schema.sql \
    $INSTANCE_NAME:/tmp/01_schema.sql \
    --zone=$ZONE

gcloud compute scp ./db/02_seed_30_per_table.sql \
    $INSTANCE_NAME:/tmp/02_seed_30_per_table.sql \
    --zone=$ZONE

# Conectarse a VM y ejecutar
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE

# Dentro de VM:
psql -h CLOUD_SQL_PRIVATE_IP -U library_user -d library_db \
    -f /tmp/01_schema.sql

psql -h CLOUD_SQL_PRIVATE_IP -U library_user -d library_db \
    -f /tmp/02_seed_30_per_table.sql
```

---

## 11. Monitoreo y Logging

```bash
# Ver logs de Compute Engine
gcloud compute instances get-serial-port-output $INSTANCE_NAME \
    --zone=$ZONE

# Ver logs de aplicación en la VM
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE
tail -f /opt/library-app/logs/app.log

# Ver métricas de Cloud SQL
gcloud sql instances describe $SQL_INSTANCE

# Ver connections a Cloud SQL
gcloud sql operations list --instance=$SQL_INSTANCE
```

---

## 12. Backups y Recuperación

```bash
# Crear backup manual de Cloud SQL
gcloud sql backups create \
    --instance=$SQL_INSTANCE

# Listar backups
gcloud sql backups list --instance=$SQL_INSTANCE

# Restaurar desde backup (CUIDADO!)
gcloud sql backups restore BACKUP_ID \
    --backup-instance=$SQL_INSTANCE \
    --target-instance=$SQL_INSTANCE

# Exportar base de datos a Cloud Storage
gcloud sql export sql $SQL_INSTANCE \
    gs://library-backups/library_db_backup.sql \
    --database=library_db
```

---

## 13. Limpiar Recursos (Cuando ya no sea necesario)

```bash
# Eliminar instancia Compute Engine
gcloud compute instances delete $INSTANCE_NAME --zone=$ZONE

# Eliminar IP estática
gcloud compute addresses delete library-ip-static --region=us-central1

# Eliminar Cloud SQL instance
gcloud sql instances delete $SQL_INSTANCE

# Eliminar firewall rules
gcloud compute firewall-rules delete library-allow-ssh
gcloud compute firewall-rules delete library-allow-http
gcloud compute firewall-rules delete library-allow-https
gcloud compute firewall-rules delete library-allow-internal

# Eliminar VPC y subnet
gcloud compute networks subnets delete library-subnet --region=us-central1
gcloud compute networks delete library-vpc
```

---

## Checklist de Despliegue

- [ ] Proyecto GCP creado
- [ ] VPC y subnet configurados
- [ ] Firewall rules establecidas
- [ ] Compute Engine instance creada
- [ ] Cloud SQL PostgreSQL instance creada
- [ ] Node.js instalado en VM
- [ ] Código de aplicación clonado/copiado
- [ ] .env configurado con valores correctos
- [ ] Dependencias instaladas (npm install)
- [ ] Scripts SQL ejecutados (schema + seeds)
- [ ] Aplicación iniciada (npm start o PM2)
- [ ] Health check accesible (/health endpoint)
- [ ] Backups automáticos configurados

---

## Monitoreo Recomendado

```bash
# Alertas de CPU > 80%
gcloud alpha monitoring policies create \
    --notification-channels=YOUR_CHANNEL_ID \
    --display-name="High CPU Usage"

# Alertas de tráfico HTTP 5xx
gcloud logging create-sink library-errors \
    logging.googleapis.com/projects/library-app-2024/logs/http_server \
    --log-filter='httpRequest.status >= 500'
```

---

## Notas de Seguridad

1. **Restricción SSH**: Cambiar source-ranges de SSH a tu IP después de setup
2. **Secretos**: Usar Secret Manager en lugar de .env en producción
3. **HTTPS**: Instalar certificado SSL (Let's Encrypt con Certbot)
4. **Backups**: Verificar que backups automáticos se ejecutan
5. **Auditoría**: Habilitar Cloud Audit Logs para compliance

---

## Referencias

- [Google Cloud Platform Documentation](https://cloud.google.com/docs)
- [Compute Engine SSH](https://cloud.google.com/compute/docs/instances/connecting-advanced)
- [Cloud SQL PostgreSQL](https://cloud.google.com/sql/docs/postgres)
- [CentOS Stream 10](https://www.centos.org/stream)
