-- Migration v1.1.0 : ajout de la colonne stock dans products
--
-- Methode NON DESTRUCTIVE :
--   - Colonne ajoutee avec DEFAULT : les lignes existantes recoivent 0 sans erreur
--   - Pas de DROP ni RENAME de colonne existante
--   - ADD COLUMN IF NOT EXISTS : idempotent, rejouer sans risque
--
-- Rejouer :
--   psql -h localhost -U shoplite -d shoplite -f database/migration-v1.1.0.sql
--
-- Regles de migration non destructive a respecter :
--   1. Toujours fournir un DEFAULT pour toute colonne NOT NULL ajoutee
--   2. Ne jamais DROP ou RENAME une colonne utilisee par l'application en production
--      sans migration applicative prealable (retirer la reference dans le code d'abord)
--   3. Tester la migration sur staging peuple avant de tagger une version production
--   4. Encapsuler dans une transaction (BEGIN / COMMIT) pour un rollback atomique

BEGIN;

-- Etape 1 : ajout de la colonne avec valeur par defaut
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS stock INTEGER NOT NULL DEFAULT 0;

-- Etape 2 : initialiser les valeurs metier pour les lignes existantes
UPDATE products SET stock = 100 WHERE stock = 0;

COMMIT;
