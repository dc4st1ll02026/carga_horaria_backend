import { Router, Request, Response } from 'express';
import { Pool } from 'pg';

const router = Router();

router.post('/', async (req: Request, res: Response) => {
  const pool: Pool = req.app.locals.pool;

  try {
    const { cod_ue_id } = req.body;

    if (cod_ue_id === undefined || cod_ue_id === null) {
      return res.status(400).json({
        error: 'El parámetro cod_ue_id es requerido'
      });
    }

    const codUeId = Number(cod_ue_id);

    if (isNaN(codUeId)) {
      return res.status(400).json({
        error: 'El parámetro cod_ue_id debe ser un número'
      });
    }

    const [matriculaSich, deficitSuperavitSich, deficitSuperavitSie, datosBase, datosPlanilla] = await Promise.all([
      pool.query('SELECT * FROM matricula_sich WHERE cod_ue = $1', [codUeId]),
      pool.query('SELECT * FROM deficit_superavit_sich WHERE cod_ue = $1', [String(codUeId)]),
      pool.query('SELECT * FROM deficit_superavit_sie WHERE cod_ue_id = $1', [codUeId]),
      pool.query('SELECT * FROM datos_base_ues_matricula WHERE cod_ue_id = $1', [codUeId]),
      pool.query(`
        SELECT
          planilla.servicio,
          planilla.programa,
          planilla.item,
          planilla.carnetcomp as carnet_identidad,
          cargos.descripcion as denominacion_cargo,
          planilla.porcate,
          planilla.cod_rda,
          planilla.horas
        FROM planilla_2026 as planilla
        LEFT JOIN cargos ON planilla.cargo = cargos.cargo
        WHERE programa = $1 and mes = 4
      `, [codUeId])
    ]);

    return res.json({
      matricula_sich: matriculaSich.rows,
      deficit_superavit_sich: deficitSuperavitSich.rows,
      deficit_superavit_sie: deficitSuperavitSie.rows,
      datos_base_ues_matricula: datosBase.rows,
      datos_planilla: datosPlanilla.rows
    });
  } catch (error) {
    console.error('Error en consulta:', error);
    return res.status(500).json({
      error: 'Error interno del servidor'
    });
  }
});

router.post('/docente', async (req: Request, res: Response) => {
  const pool: Pool = req.app.locals.pool;

  try {
    const { docente_id, institucioneducativa_id } = req.body;

    if (docente_id === undefined || docente_id === null) {
      return res.status(400).json({
        error: 'El parámetro docente_id es requerido'
      });
    }
    if (institucioneducativa_id === undefined || institucioneducativa_id === null) {
      return res.status(400).json({
        error: 'El parámetro institucioneducativa_id es requerido'
      });
    }

    const docenteId = String(docente_id);
    const institucionId = Number(institucioneducativa_id);

    if (isNaN(institucionId)) {
      return res.status(400).json({
        error: 'El parámetro institucioneducativa_id debe ser un número'
      });
    }

    const result = await pool.query(
      `SELECT * FROM asignacion_docente_2026
       WHERE carnet = $1 AND institucioneducativa_id = $2`,
      [docenteId, institucionId]
    );

    return res.json({
      asignacion_docente: result.rows
    });
  } catch (error) {
    console.error('Error en consulta de docente:', error);
    return res.status(500).json({
      error: 'Error interno del servidor'
    });
  }
});

router.post('/administrativo', async (req: Request, res: Response) => {
  const pool: Pool = req.app.locals.pool;

  try {
    const { cod_ue_id } = req.body;

    if (cod_ue_id === undefined || cod_ue_id === null) {
      return res.status(400).json({
        error: 'El parámetro cod_ue_id es requerido'
      });
    }

    const codUeId = Number(cod_ue_id);

    if (isNaN(codUeId)) {
      return res.status(400).json({
        error: 'El parámetro cod_ue_id debe ser un número'
      });
    }

    const [datosUe, totalesAdministrativos, datosMatricula, planillaAbril, paralelosSie] = await Promise.all([
      pool.query(
        'SELECT * FROM datos_base_ues_matricula WHERE cod_ue_id = $1 LIMIT 1',
        [codUeId]
      ),
      pool.query(
        'SELECT total, cargo FROM totales_administrativos WHERE institucioneducativa_id = $1 ORDER BY cargo',
        [codUeId]
      ),
      pool.query(
        'SELECT * FROM datos_base_ues_matricula WHERE cod_ue_id = $1 ORDER BY gestion_tipo_id, nivel_tipo_id',
        [codUeId]
      ),
      pool.query(`
        SELECT
          planilla.servicio,
          planilla.programa,
          planilla.item,
          planilla.carnetcomp as carnet_identidad,
          cargos.descripcion as denominacion_cargo,
          planilla.porcate,
          planilla.cod_rda,
          planilla.horas
        FROM planilla_2026 as planilla
        LEFT JOIN cargos ON planilla.cargo = cargos.cargo
        WHERE programa = $1 and mes = 4 and cargos.tipo = 'A'
      `, [codUeId]),
      pool.query(
        'SELECT total, nivel, grado FROM paralelos_sie_agrupados where institucioneducativa_id = $1  ORDER BY nivel, grado',
         [codUeId]
      )
    ]);

    return res.json({
      datos_ue: datosUe.rows,
      totales_administrativos: totalesAdministrativos.rows,
      datos_matricula: datosMatricula.rows,
      planilla_abril: planillaAbril.rows,
      paralelos_sie: paralelosSie.rows
    });
  } catch (error) {
    console.error('Error en consulta administrativa:', error);
    return res.status(500).json({
      error: 'Error interno del servidor'
    });
  }
});

export { router as consultaRoutes };

