import 'dotenv/config';
import { Pool } from 'pg';
import { consultaRoutes } from './routes/consulta';
import express from 'express';
import cors from 'cors';

const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'simulacion',
  user: 'postgres',
  password: process.env.DB_PASSWORD || 'adminpg',
});

const app = express();
const PORT = Number(process.env.PORT) || 3500;

app.use(cors({
  origin: true,
  credentials: false,
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type']
}));
app.use(express.json());

app.locals.pool = pool;

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/consulta', consultaRoutes);

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://0.0.0.0:${PORT}`);
});

process.on('SIGINT', async () => {
  await pool.end();
  process.exit(0);
});
