-- Roda uma única vez, na criação do volume, ANTES do GoTrue subir.
-- O GoTrue migra para dentro de `auth`, mas não cria o schema sozinho.
create schema if not exists auth;
create extension if not exists pgcrypto;
