# BotShield API

## 📌 Overview

BotShield API is a backend system designed to manage posts, comments, likes, and bot interactions while preventing spam using Redis-based guardrails.

The system supports both human users and bots, with real-time virality scoring and efficient rate limiting.

---

## 🚀 Features

### 👤 User & Bot Management

* Register users
* Register bots
* Clear separation between user and bot actions

### 📝 Posts

* Create posts
* Retrieve post comments

### 💬 Comments (Threaded)

* Add comments to posts
* Reply to comments (nested structure)
* Depth tracking (`parent.depth + 1`)
* Maximum depth limit (20)

### ❤️ Likes

* Like a post
* Prevent duplicate likes
* Count total likes

---

## ⚡ Redis-Based Features

### 📊 Virality Score

Each post has a real-time score stored in Redis:

* User comment → **+50**
* Bot comment → **+1**
* Like → **+20**

Implemented using atomic Redis operations (`INCRBY`).

---

### 🤖 Bot Guardrails

#### 1. Bot Reply Limit

* Maximum **100 bot replies per post**
* Stored in Redis:

  ```
  post:{postId}:bot_reply_count
  ```

#### 2. Cooldown Mechanism

* Prevents bots from replying repeatedly to the same user
* Cooldown duration: **15 minutes**
* Redis key:

  ```
  cooldown:bot_{botId}:user_{userId}
  ```
* Implemented using Redis TTL (auto-expiry)

---

### 🏆 Leaderboard (Top Posts)

* Tracks most viral posts using Redis Sorted Set (ZSET)
* Key:

  ```
  post:leaderboard
  ```
* Supports real-time ranking

---

## 🛠 Tech Stack

* Java (Spring Boot)
* PostgreSQL (Database)
* Redis (Caching & Real-time scoring)
* Docker (Redis container)

---

## ▶️ How to Run

### Option A: Run Everything with Docker Compose (Recommended)

Start the Spring Boot application, PostgreSQL, and Redis with a single command:

```bash
docker-compose up --build
```
Or in detached mode:
```bash
docker-compose up -d --build
```

To stop all services:
```bash
docker-compose down
```

The application will be accessible at: `http://localhost:8089`

---

### Option B: Run Locally with Maven

#### 1. Start PostgreSQL
Make sure PostgreSQL is running locally on port `5432` with database `BOTSHIELD`.

#### 2. Start Redis using Docker
```bash
docker run -d -p 6379:6379 --name redis redis:7-alpine
```

#### 3. Run the Application
```bash
mvn spring-boot:run
```

---

## 📡 API Endpoints

### 👤 User

* `POST /api/users` → Register user
* `GET /api/users/{userId}` → Get user
* `GET /api/users/{userId}/posts` → Get user posts

---

### 🤖 Bot

* `POST /api/bots` → Register bot

---

### 📝 Posts

* `POST /api/posts` → Create post
* `GET /api/posts/{postId}/comments` → Get comments

---

### 💬 Comments

* `POST /api/posts/{postId}/comment` → Add comment / reply

---

### ❤️ Likes

* `POST /api/posts/{postId}/like` → Like post
* `GET /api/posts/{postId}/likes/count` → Get like count

---

### 📊 Virality

* `GET /api/posts/{postId}/virality` → Get virality score

---

### 🏆 Leaderboard

* `GET /api/posts/leaderboard?limit=10` → Top posts

---

## 🧠 System Design

* **Database (PostgreSQL)** → Source of truth
* **Redis** → Stores derived real-time data
* **Flow:**

  ```
  User Action → DB Save → Redis Update
  ```

---

## ⚠️ Edge Case Handling

* Prevent duplicate likes
* Handle null values from Redis safely
* Cooldown only applies when bot replies to a user
* Bot-to-bot replies do not trigger cooldown
* Depth limit prevents infinite nesting

---

## 🎯 Key Highlights

* Real-time scoring using Redis
* Atomic operations ensure consistency
* Efficient bot spam prevention
* Scalable leaderboard implementation

---

## 🏁 Conclusion

This system demonstrates how Redis can be used alongside a relational database to handle high-frequency operations efficiently while maintaining data consistency and scalability.
