# Takeout Mall Management System

A full-stack food delivery management system built with Spring Boot, Vue 2, and WeChat MiniProgram.

## 🚀 Live Demo

- **Admin Frontend**: http://167.179.78.66
- **API Documentation**: http://167.179.78.66:8080/doc.html
- **Demo Account**: `admin` / `123456`

## 📋 Features

- Staff & category management
- Dish & setmeal management
- Order processing & tracking
- Data statistics & dashboard
- WeChat MiniProgram client (local dev only)

## 🛠️ Tech Stack

**Backend:** Spring Boot, MyBatis, MySQL, Redis, JWT  
**Frontend:** Vue 2, TypeScript, Element UI  
**Infrastructure:** Docker, Nginx

## 📁 Project Structure

```
takeout mall/
├── backend/                      # Backend services
│   ├── sky-common/              # Common utilities & constants
│   │   └── src/main/java/com/sky/
│   │       ├── constant/        # Constants (MessageConstant, StatusConstant)
│   │       ├── exception/       # Custom exceptions
│   │       ├── properties/      # Configuration properties
│   │       ├── result/          # Result wrapper class
│   │       └── utils/           # Utility classes (JwtUtil, AliOssUtil, etc.)
│   │
│   ├── sky-pojo/                # Data transfer objects
│   │   └── src/main/java/com/sky/
│   │       ├── dto/             # Data Transfer Objects
│   │       ├── entity/          # Entity classes (Dish, Order, etc.)
│   │       └── vo/              # View Objects
│   │
│   └── sky-server/              # Main application
│       ├── src/main/java/com/sky/
│       │   ├── controller/      # REST controllers (admin/user)
│       │   ├── service/         # Business logic layer
│       │   ├── mapper/          # MyBatis mappers
│       │   ├── config/          # Configuration classes
│       │   ├── interceptor/     # JWT interceptors
│       │   ├── task/            # Scheduled tasks
│       │   └── websocket/       # WebSocket server
│       │
│       └── src/main/resources/
│           ├── mapper/          # MyBatis XML files
│           └── application.yml  # Application configuration
│
├── frontend-admin/               # Admin frontend (Vue.js)
│   ├── src/
│   │   ├── api/                 # API service calls
│   │   ├── views/               # Page components
│   │   │   ├── dashboard/       # Dashboard pages
│   │   │   ├── dish/            # Dish management
│   │   │   ├── order/           # Order management
│   │   │   └── ...
│   │   ├── components/          # Reusable components
│   │   ├── layout/              # Layout components
│   │   ├── router.ts            # Route configuration
│   │   └── store/               # Vuex state management
│   ├── Dockerfile               # Frontend Docker image
│   └── nginx.conf               # Nginx configuration
│
├── miniprogram/                  # WeChat MiniProgram (uni-app)
│   └── mp-weixin/
│       ├── pages/               # MiniProgram pages
│       │   ├── index/           # Home page
│       │   ├── order/           # Order pages
│       │   └── my/              # User center
│       └── static/              # Static resources
│
├── docs/                         # Documentation
│   └── sql/                     # Database scripts
│
├── docker-compose.yml            # Local development
├── docker-compose.prod.yml       # Production deployment
└── deploy.sh                     # Deployment script
```

### Key Modules

**backend/sky-common/**  
Shared utilities, constants, and exception classes used across the backend.

**backend/sky-pojo/**  
Data models: DTOs (data transfer), Entities (database mapping), VOs (view objects).

**backend/sky-server/**  
Main application with controllers, services, mappers, and configurations.

**frontend-admin/**  
Vue.js admin dashboard for managing dishes, orders, and system settings.

**miniprogram/**  
WeChat MiniProgram client for end users (local development only).

## 🚀 Quick Start

```bash
# 1. Clone and start services
git clone <repository-url>
cd "takeout mall"
docker compose -f docker-compose.yml up -d

# 2. Access application
# Admin: http://localhost:8888 (admin/123456)
# API: http://localhost:8080
```

For detailed deployment, see [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md).

## 📚 Documentation

- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - Deployment instructions
- [USER_GUIDE.md](./USER_GUIDE.md) - User guide

## 📝 License

MIT License
