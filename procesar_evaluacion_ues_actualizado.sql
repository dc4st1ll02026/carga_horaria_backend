-- Stored Procedure actualizado para evaluación de UEs
-- Ajuste: Semáforo "Matrícula SIE" ahora compara solo 2025 vs 2026

CREATE OR REPLACE FUNCTION procesar_evaluacion_ues()
RETURNS void AS $$
DECLARE
  v_cod_ue INTEGER;
  v_cursor CURSOR FOR SELECT DISTINCT cod_ue_id FROM matricula_gestiones;
  
  -- Variables para semáforos
  v_datos_ue BOOLEAN := FALSE;
  v_matricula_sie BOOLEAN := FALSE;
  v_deficit_sie BOOLEAN := FALSE;
  v_deficit_sich BOOLEAN := FALSE;
  v_matricula_sich BOOLEAN := FALSE;
  v_planilla BOOLEAN := FALSE;
  
  -- Variables para datos de la UE
  v_desc_ue VARCHAR(255);
  v_desc_departamento VARCHAR(100);
  v_distrito VARCHAR(100);
  v_cod_distrito VARCHAR(20);
  v_area VARCHAR(50);
  v_dependencia VARCHAR(100);
  
  -- Variables para cálculos
  v_count INTEGER;
  v_deficit_historico NUMERIC;
  v_total_marzo INTEGER;
  v_total_abril INTEGER;
  v_total_mayo INTEGER;
  v_als_2025 INTEGER;
  v_als_2026 INTEGER;
  
  v_total_cumplen INTEGER;
BEGIN
  -- Limpiar tabla de resultados
  TRUNCATE TABLE resultado_evaluacion_ues;
  
  OPEN v_cursor;
  LOOP
    FETCH v_cursor INTO v_cod_ue;
    EXIT WHEN NOT FOUND;
    
    BEGIN
      -- Resetear semáforos
      v_datos_ue := FALSE;
      v_matricula_sie := FALSE;
      v_deficit_sie := FALSE;
      v_deficit_sich := FALSE;
      v_matricula_sich := FALSE;
      v_planilla := FALSE;
      
      -- Obtener datos básicos de la UE
      SELECT desc_ue, desc_departamento, distrito, cod_distrito, area, dependencia
      INTO v_desc_ue, v_desc_departamento, v_distrito, v_cod_distrito, v_area, v_dependencia
      FROM datos_base_ues_matricula
      WHERE cod_ue_id = v_cod_ue
      LIMIT 1;
      
      -- Semáforo 1: datos-ue
      SELECT COUNT(*) INTO v_count
      FROM datos_base_ues_matricula
      WHERE cod_ue_id = v_cod_ue;
      v_datos_ue := (v_count > 0);
      
      -- Semáforo 2: matricula-sie (2025 <= 2026)
      SELECT COALESCE(SUM(als), 0) INTO v_als_2025
      FROM datos_base_ues_matricula
      WHERE cod_ue_id = v_cod_ue AND gestion_tipo_id = 2025;
      
      SELECT COALESCE(SUM(als), 0) INTO v_als_2026
      FROM datos_base_ues_matricula
      WHERE cod_ue_id = v_cod_ue AND gestion_tipo_id = 2026;
      
      -- Asegurar que las variables no sean NULL
      v_als_2025 := COALESCE(v_als_2025, 0);
      v_als_2026 := COALESCE(v_als_2026, 0);
      
      -- Nueva lógica: solo compara 2025 vs 2026
      v_matricula_sie := (v_als_2026 >= v_als_2025);
      
      -- Semáforo 3: deficit-sie
      SELECT COALESCE(deficit_historico, 0) INTO v_deficit_historico
      FROM deficit_superavit_sie
      WHERE cod_ue_id = v_cod_ue
      LIMIT 1;
      
      -- Asegurar que la variable no sea NULL
      v_deficit_historico := COALESCE(v_deficit_historico, 0);
      v_deficit_sie := (v_deficit_historico > 0);
      
      -- Semáforo 4: deficit-sich
      SELECT COUNT(*) INTO v_count
      FROM deficit_superavit_sich
      WHERE cod_ue = v_cod_ue::TEXT;
      v_deficit_sich := (v_count > 0);
      
      -- Semáforo 5: matricula-sich (Marzo <= Abril <= Mayo 2026)
      SELECT COALESCE(total, 0) INTO v_total_marzo
      FROM matricula_sich
      WHERE cod_ue = v_cod_ue AND gestion = 2026 AND mes = 'Marzo';
      
      SELECT COALESCE(total, 0) INTO v_total_abril
      FROM matricula_sich
      WHERE cod_ue = v_cod_ue AND gestion = 2026 AND mes = 'Abril';
      
      SELECT COALESCE(total, 0) INTO v_total_mayo
      FROM matricula_sich
      WHERE cod_ue = v_cod_ue AND gestion = 2026 AND mes = 'Mayo';
      
      -- Asegurar que las variables no sean NULL
      v_total_marzo := COALESCE(v_total_marzo, 0);
      v_total_abril := COALESCE(v_total_abril, 0);
      v_total_mayo := COALESCE(v_total_mayo, 0);
      
      v_matricula_sich := (v_total_marzo <= v_total_abril AND v_total_abril <= v_total_mayo);
      
      -- Semáforo 6: planilla
      SELECT COUNT(*) INTO v_count
      FROM planilla_2026 p
      LEFT JOIN cargos c ON p.cargo = c.cargo
      WHERE p.programa = v_cod_ue AND p.mes = 4 AND c.tipo = 'A';
      v_planilla := (v_count > 0);
      
      -- Calcular totales
      v_total_cumplen := 
        CASE WHEN v_datos_ue THEN 1 ELSE 0 END +
        CASE WHEN v_matricula_sie THEN 1 ELSE 0 END +
        CASE WHEN v_deficit_sie THEN 1 ELSE 0 END +
        CASE WHEN v_deficit_sich THEN 1 ELSE 0 END +
        CASE WHEN v_matricula_sich THEN 1 ELSE 0 END +
        CASE WHEN v_planilla THEN 1 ELSE 0 END;
      
      -- Insertar resultado
      INSERT INTO resultado_evaluacion_ues (
        cod_ue_id, desc_ue, desc_departamento, distrito, cod_distrito, area, dependencia,
        semaforo_datos_ue, semaforo_matricula_sie, semaforo_deficit_sie,
        semaforo_deficit_sich, semaforo_matricula_sich, semaforo_planilla,
        total_cumplen, total_no_cumplen, fecha_procesado
      ) VALUES (
        v_cod_ue, v_desc_ue, v_desc_departamento, v_distrito, v_cod_distrito, v_area, v_dependencia,
        v_datos_ue, v_matricula_sie, v_deficit_sie,
        v_deficit_sich, v_matricula_sich, v_planilla,
        v_total_cumplen, 6 - v_total_cumplen, NOW()
      )
      ON CONFLICT (cod_ue_id) DO UPDATE SET
        desc_ue = EXCLUDED.desc_ue,
        desc_departamento = EXCLUDED.desc_departamento,
        distrito = EXCLUDED.distrito,
        cod_distrito = EXCLUDED.cod_distrito,
        area = EXCLUDED.area,
        dependencia = EXCLUDED.dependencia,
        semaforo_datos_ue = EXCLUDED.semaforo_datos_ue,
        semaforo_matricula_sie = EXCLUDED.semaforo_matricula_sie,
        semaforo_deficit_sie = EXCLUDED.semaforo_deficit_sie,
        semaforo_deficit_sich = EXCLUDED.semaforo_deficit_sich,
        semaforo_matricula_sich = EXCLUDED.semaforo_matricula_sich,
        semaforo_planilla = EXCLUDED.semaforo_planilla,
        total_cumplen = EXCLUDED.total_cumplen,
        total_no_cumplen = EXCLUDED.total_no_cumplen,
        fecha_procesado = NOW();
      
    EXCEPTION WHEN OTHERS THEN
      -- Log error y continuar con la siguiente UE
      RAISE NOTICE 'Error procesando UE %: %', v_cod_ue, SQLERRM;
      CONTINUE;
    END;
    
  END LOOP;
  CLOSE v_cursor;
END;
$$ LANGUAGE plpgsql;
