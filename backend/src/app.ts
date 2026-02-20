import express from "express";
import { clerkMiddleware } from '@clerk/express'
import authRoutes from "./routes/authRoutes";
import chatRoutes from "./routes/chatRoutes";
import messageRoutes from "./routes/messageRoutes";
import userRoutes from "./routes/userRoutes";

const app = express();

app.use(express.json()); // parses incoming JSON request bodies and makes them available as req.body in your route handlers

app.use(clerkMiddleware())

app.get("/health", (req, res) => {
    res.json({ status: "ok", message: "Server is running" });
});

app.use("/api/auth", authRoutes)
app.use("/api/chats", chatsRoutes)
app.use("/api/messages", messagesRoutes)
app.use("/api/users", usersRoutes)

app.use(errorHandler);

export default app;