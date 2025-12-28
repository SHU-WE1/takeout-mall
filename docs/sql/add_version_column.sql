-- ============================================
-- 楽観ロック用の version 列を追加するスクリプト
-- Dish（料理）・Setmeal（セットメニュー）テーブルに version を追加
-- ============================================

-- Dish テーブルに version 列を追加
ALTER TABLE `dish`
  ADD COLUMN `version` INT NOT NULL DEFAULT 0 COMMENT 'バージョン（楽観ロック用）' AFTER `stock`;

-- Setmeal テーブルに version 列を追加
ALTER TABLE `setmeal`
  ADD COLUMN `version` INT NOT NULL DEFAULT 0 COMMENT 'バージョン（楽観ロック用）' AFTER `stock`;


