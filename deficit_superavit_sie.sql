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

 Date: 30/06/2026 12:55:35
*/


-- ----------------------------
-- Table structure for deficit_superavit_sie
-- ----------------------------
DROP TABLE IF EXISTS "public"."deficit_superavit_sie";
CREATE TABLE "public"."deficit_superavit_sie" (
  "id_departamento" int4,
  "desc_departamento" varchar(255) COLLATE "pg_catalog"."default",
  "cod_distrito" int4,
  "distrito" varchar(255) COLLATE "pg_catalog"."default",
  "cod_ue_id" int4,
  "desc_ue" varchar(255) COLLATE "pg_catalog"."default",
  "area" varchar(255) COLLATE "pg_catalog"."default",
  "cod_dependencia_id" int4,
  "dependencia" varchar(255) COLLATE "pg_catalog"."default",
  "institucioneducativa_id" int4,
  "horas_plan_ue" int4,
  "horas_pagadas_ue" int4,
  "deficit_historico" int4,
  "superhavit_historico" int4
)
;
