/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : PostgreSQL
 Source Server Version : 180003 (180003)
 Source Host           : localhost:5432
 Source Catalog        : simulacion
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 180003 (180003)
 File Encoding         : 65001

 Date: 30/06/2026 12:55:06
*/


-- ----------------------------
-- Table structure for datos_base_ues_matricula
-- ----------------------------
DROP TABLE IF EXISTS "public"."datos_base_ues_matricula";
CREATE TABLE "public"."datos_base_ues_matricula" (
  "gestion_tipo_id" int4,
  "id_departamento" int4,
  "desc_departamento" varchar(255) COLLATE "pg_catalog"."default",
  "cod_distrito" int4,
  "distrito" varchar(255) COLLATE "pg_catalog"."default",
  "cod_ue_id" int4,
  "desc_ue" varchar(255) COLLATE "pg_catalog"."default",
  "nivel_tipo_id" int4,
  "estadomatricula" varchar(255) COLLATE "pg_catalog"."default",
  "als" int4,
  "cod_le_id" int4,
  "direccion" varchar(255) COLLATE "pg_catalog"."default",
  "zona" varchar(255) COLLATE "pg_catalog"."default",
  "area" varchar(255) COLLATE "pg_catalog"."default",
  "id_provincia" int4,
  "desc_provincia" varchar(255) COLLATE "pg_catalog"."default",
  "id_seccion" int4,
  "desc_seccion" varchar(255) COLLATE "pg_catalog"."default",
  "id_canton" int4,
  "desc_canton" varchar(255) COLLATE "pg_catalog"."default",
  "id_localidad" int4,
  "desc_localidad" varchar(255) COLLATE "pg_catalog"."default",
  "cod_convenio_id" int4,
  "convenio" varchar(255) COLLATE "pg_catalog"."default",
  "dependencia_gen" varchar(255) COLLATE "pg_catalog"."default",
  "cod_dependencia_id" int4,
  "dependencia" varchar(255) COLLATE "pg_catalog"."default",
  "ini" int4,
  "pri" int4,
  "sec" int4,
  "epa" int4,
  "esa" int4,
  "eta" int4,
  "esp" int4,
  "perm" int4,
  "perm_tec" int4,
  "perm_otros" int4,
  "eja" int4,
  "fecha_last_update" timestamp(6),
  "estadoinstitucion" varchar(255) COLLATE "pg_catalog"."default",
  "cordx" float8,
  "cordy" float8,
  "nro_resolucion" varchar(255) COLLATE "pg_catalog"."default",
  "fecha_resolucion" timestamp(6),
  "fecha_creacion" varchar(255) COLLATE "pg_catalog"."default",
  "fecha_cierre" varchar(255) COLLATE "pg_catalog"."default",
  "fecha_fundacion" varchar(255) COLLATE "pg_catalog"."default",
  "obs_rue" varchar(255) COLLATE "pg_catalog"."default",
  "nro_anios_cerrados" int4,
  "cod_org_curr_id" int4,
  "orgcurricula" varchar(255) COLLATE "pg_catalog"."default"
)
;
