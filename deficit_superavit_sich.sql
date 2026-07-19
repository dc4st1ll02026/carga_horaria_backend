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

 Date: 30/06/2026 12:56:04
*/


-- ----------------------------
-- Table structure for deficit_superavit_sich
-- ----------------------------
DROP TABLE IF EXISTS "public"."deficit_superavit_sich";
CREATE TABLE "public"."deficit_superavit_sich" (
  "depto_id" varchar(255) COLLATE "pg_catalog"."default",
  "departamento" varchar(255) COLLATE "pg_catalog"."default",
  "distrito_id" varchar(255) COLLATE "pg_catalog"."default",
  "distrito" varchar(255) COLLATE "pg_catalog"."default",
  "cod_ue" varchar(255) COLLATE "pg_catalog"."default",
  "ue" varchar(255) COLLATE "pg_catalog"."default",
  "area" varchar(255) COLLATE "pg_catalog"."default",
  "i_1" int2,
  "i_2" int2,
  "p_1" int2,
  "p_2" int2,
  "p_3" int2,
  "p_4" int2,
  "p_5" int2,
  "p_6" int2,
  "s_1" int2,
  "s_2" int2,
  "s_3" int2,
  "s_4" int2,
  "s_5" int2,
  "s_6" int2,
  "total_deficit" int2,
  "item_96_horas" numeric(5,2)
)
;
