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

 Date: 30/06/2026 12:56:25
*/


-- ----------------------------
-- Table structure for matricula_sich
-- ----------------------------
DROP TABLE IF EXISTS "public"."matricula_sich";
CREATE TABLE "public"."matricula_sich" (
  "gestion" int4,
  "mes" varchar(255) COLLATE "pg_catalog"."default",
  "departamento" varchar(255) COLLATE "pg_catalog"."default",
  "cod_distrito" int4,
  "distrito" varchar(255) COLLATE "pg_catalog"."default",
  "cod_ue" int4,
  "ue" varchar(255) COLLATE "pg_catalog"."default",
  "inicial" int4,
  "primaria" int4,
  "secundaria" int4,
  "total" int4
)
;
