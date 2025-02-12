const express = require('express');
const axios = require('axios');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;


app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// API routes to interact with Flask backend
const API_URL = process.env.API_URL || 'http://localhost:5000';
const TODOS_API = `${API_URL}/todos`;

// Serve the frontend
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});


app.get('/api/todos', async (req, res) => {
    try {
        const response = await axios.get(TODOS_API);
        res.json(response.data);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch todos' });
    }
});

app.post('/api/todos', async (req, res) => {
    try {
        const response = await axios.post(TODOS_API, req.body);
        res.json(response.data);
    } catch (error) {
        res.status(500).json({ error: 'Failed to add todo' });
    }
});

app.put('/api/todos/:id', async (req, res) => {
    try {
        const response = await axios.put(`${TODOS_API}/${req.params.id}`, req.body);
        res.json(response.data);
    } catch (error) {
        res.status(500).json({ error: 'Failed to update todo' });
    }
});

app.delete('/api/todos/:id', async (req, res) => {
    try {
        const response = await axios.delete(`${TODOS_API}/${req.params.id}`);
        res.json(response.data);
    } catch (error) {
        res.status(500).json({ error: 'Failed to delete todo' });
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});