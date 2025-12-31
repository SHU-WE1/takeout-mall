# Server Deployment Guide

## Server Information

- **IP Address**: 167.179.78.66
- **IPv6**: 2001:19f0:7001:28a8:5400:05ff:fec1:8e1c
- **Username**: root
- **Password**: `your_server_password` (use your actual server password)

## Deployment Steps

### Step 1: Server Environment Initialization

1. **Connect to Server**
   ```bash
   ssh root@167.179.78.66
   ```

2. **Upload Project Files to Server**
   
   Execute locally (requires `rsync` or `scp`):
   ```bash
   # Using rsync (recommended, can exclude unnecessary files)
   rsync -avz --exclude 'node_modules' --exclude 'target' --exclude '.git' \
     /Users/weishu/Desktop/takeout\ mall/ root@167.179.78.66:/root/takeout-mall/
   
   # Or using scp
   scp -r /Users/weishu/Desktop/takeout\ mall root@167.179.78.66:/root/takeout-mall
   ```

3. **Upload WeChat Pay Certificate Files**
   ```bash
   # Create certs directory on server
   ssh root@167.179.78.66 "mkdir -p /root/takeout-mall/certs"
   
   # Upload certificate files
   scp apiclient_key.pem root@167.179.78.66:/root/takeout-mall/certs/
   scp wechatpay_*.pem root@167.179.78.66:/root/takeout-mall/certs/
   ```

4. **Run Initialization Script on Server**
   ```bash
   ssh root@167.179.78.66
   cd /root/takeout-mall
   chmod +x server-setup.sh
   ./server-setup.sh
   ```

   This script will:
   - Update system packages
   - Install Docker
   - Install Docker Compose
   - Install Git
   - Configure firewall (open ports 22, 80, 8080)

### Step 2: Deploy Project

1. **Navigate to Project Directory**
   ```bash
   ssh root@167.179.78.66
   cd /root/takeout-mall
   ```

2. **Check Required Files**
   ```bash
   # Verify these files exist
   ls -la docker-compose.prod.yml
   ls -la .env.prod
   ls -la certs/apiclient_key.pem
   ls -la certs/wechatpay_*.pem
   ```

3. **Run Deployment Script**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

   The deployment script will:
   - Check Docker and Docker Compose
   - Check required files
   - Stop existing containers
   - Build Docker images
   - Start all services
   - Display service status and logs

### Step 3: Verify Deployment

1. **Check Service Status**
   ```bash
   docker compose -f docker-compose.prod.yml --env-file .env.prod ps
   ```

   You should see all services running:
   - sky-mysql (MySQL)
   - sky-redis (Redis)
   - sky-backend (Backend service)
   - sky-frontend (Frontend service)

2. **View Service Logs**
   ```bash
   # View all service logs
   docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f
   
   # View specific service logs
   docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f backend
   docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f frontend
   ```

3. **Test Access**
   - Frontend: http://167.179.78.66
   - Backend API: http://167.179.78.66:8080
   - API Documentation: http://167.179.78.66:8080/doc.html

## Common Management Commands

### View Service Status
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod ps
```

### View Service Logs
```bash
# View all service logs
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f

# View specific service logs
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f backend
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f frontend
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f mysql
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f redis
```

### Restart Services
```bash
# Restart all services
docker compose -f docker-compose.prod.yml --env-file .env.prod restart

# Restart specific service
docker compose -f docker-compose.prod.yml --env-file .env.prod restart backend
docker compose -f docker-compose.prod.yml --env-file .env.prod restart frontend
```

### Stop Services
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod down
```

### Stop and Remove Volumes (Use with Caution)
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod down -v
```

### Rebuild and Start
```bash
# Stop services
docker compose -f docker-compose.prod.yml --env-file .env.prod down

# Rebuild images
docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache

# Start services
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

## Troubleshooting

### 1. Port Already in Use
```bash
# Check port usage
netstat -tulpn | grep :80
netstat -tulpn | grep :8080

# If port is occupied, modify port mapping in docker-compose.prod.yml
```

### 2. Container Won't Start
```bash
# View container logs
docker compose -f docker-compose.prod.yml --env-file .env.prod logs [service-name]

# Check container status
docker ps -a
```

### 3. Database Connection Failed
```bash
# Check if MySQL container is running normally
docker compose -f docker-compose.prod.yml --env-file .env.prod logs mysql

# Check backend service logs
docker compose -f docker-compose.prod.yml --env-file .env.prod logs backend
```

### 4. Frontend Cannot Access Backend API
```bash
# Check Nginx configuration
docker exec -it sky-frontend cat /etc/nginx/conf.d/default.conf

# Check if backend service is running normally
curl http://localhost:8080/admin/employee/login
```

### 5. WeChat Pay Certificate Issues
```bash
# Check if certificate files exist
ls -la certs/

# Check certificate file permissions
chmod 644 certs/*.pem
```

## Update Deployment

### Method 1: Pull Updates via Git (Recommended)

If the project on server is already a Git repository:

1. **SSH to Server**
   ```bash
   ssh root@167.179.78.66
   ```

2. **Navigate to Project Directory and Pull Latest Code**
   ```bash
   cd /root/takeout-mall
   git pull origin main
   # or
   git pull origin master
   ```

3. **Update Backend Service**
   ```bash
   # Using update script (recommended)
   chmod +x update-backend.sh
   ./update-backend.sh
   
   # Or manually execute
   docker compose -f docker-compose.prod.yml --env-file .env.prod stop backend
   docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache backend
   docker compose -f docker-compose.prod.yml --env-file .env.prod up -d backend
   ```

### Method 2: Upload Updates via rsync

If the project on server is not a Git repository:

1. **Update Code Locally and Push to Git**
   ```bash
   git add .
   git commit -m "Update code"
   git push
   ```

2. **Re-upload to Server**
   ```bash
   rsync -avz --exclude 'node_modules' --exclude 'target' --exclude '.git' \
     /Users/weishu/Desktop/takeout\ mall/ root@167.179.78.66:/root/takeout-mall/
   ```

3. **Update Backend Service on Server**
   ```bash
   ssh root@167.179.78.66
   cd /root/takeout-mall
   chmod +x update-backend.sh
   ./update-backend.sh
   ```

### Method 3: Full Redeployment

If you need to redeploy all services (including frontend, MySQL, Redis):

```bash
ssh root@167.179.78.66
cd /root/takeout-mall
./deploy.sh
```

## Security Recommendations

1. **Change Default Password**: Change server root password immediately after deployment
2. **Configure SSH Keys**: Use SSH key authentication, disable password login
3. **Configure Firewall**: Only open necessary ports (22, 80, 8080)
4. **Regular Backups**: Regularly backup database and important files
5. **Update System**: Regularly update system and Docker images
6. **Monitor Logs**: Regularly check service logs to detect issues and anomalies

## Backup and Restore

### Backup Database
```bash
# Backup MySQL data (replace your_mysql_password with actual MySQL password)
docker exec sky-mysql mysqldump -u root -pyour_mysql_password sky_take_out > backup_$(date +%Y%m%d).sql

# Backup Redis data (replace your_redis_password with actual Redis password)
docker exec sky-redis redis-cli --pass your_redis_password SAVE
docker cp sky-redis:/data/dump.rdb ./redis_backup_$(date +%Y%m%d).rdb
```

### Restore Database
```bash
# Restore MySQL data (replace your_mysql_password with actual MySQL password)
docker exec -i sky-mysql mysql -u root -pyour_mysql_password sky_take_out < backup_20231110.sql

# Restore Redis data
docker cp redis_backup_20231110.rdb sky-redis:/data/dump.rdb
docker restart sky-redis
```

## Important Notes

1. **Certificate Files**: Ensure WeChat Pay certificate files are correctly uploaded to `certs/` directory
2. **Environment Variables**: Production `.env.prod` file contains sensitive information, do not commit to Git
3. **Port Configuration**: Production uses standard ports (80, 8080), local development uses non-standard ports (8081, 3307, 6380)
4. **Database Initialization**: First deployment will automatically execute SQL scripts in `docs/sql/` directory to initialize database
5. **Log Management**: Production environment should configure log rotation to prevent log files from becoming too large

## Support

If you encounter issues, please check:
1. Service logs
2. Container status
3. Network connection
4. Firewall configuration
5. Certificate files

---

**After deployment, access addresses:**
- Frontend: http://167.179.78.66
- Backend API: http://167.179.78.66:8080
- API Documentation: http://167.179.78.66:8080/doc.html
