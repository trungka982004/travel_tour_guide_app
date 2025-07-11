# Resort App Backend

## Authentication Endpoints

### Register
- **POST** `/api/auth/register`
- **Body:**
```
{
  "name": "User Name",
  "email": "user@example.com",
  "password": "password123"
}
```
- **Response:**
```
{
  "token": "<jwt>",
  "user": { "id": "...", "name": "User Name", "email": "user@example.com" }
}
```

### Login
- **POST** `/api/auth/login`
- **Body:**
```
{
  "email": "user@example.com",
  "password": "password123"
}
```
- **Response:**
```
{
  "token": "<jwt>",
  "user": { "id": "...", "name": "User Name", "email": "user@example.com" }
}
```

---

Add your MongoDB connection string and JWT secret to a `.env` file:
```
MONGODB_URI=mongodb://localhost:27017/resortapp
JWT_SECRET=your_jwt_secret
```
