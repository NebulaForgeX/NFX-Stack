-- 初始化数据库脚本
-- 该脚本会在 MySQL 容器首次启动时自动执行
-- 使用单一数据库，不同表的设计

-- 创建开发环境数据库
CREATE DATABASE IF NOT EXISTS `SjgzTests` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建生产环境数据库
CREATE DATABASE IF NOT EXISTS `SjgzResources` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 授权（如果需要额外用户，可以在这里添加）
-- CREATE USER IF NOT EXISTS 'sjgz_user'@'%' IDENTIFIED BY 'your_password';
-- GRANT ALL PRIVILEGES ON SjgzTests.* TO 'sjgz_user'@'%';
-- GRANT ALL PRIVILEGES ON SjgzResources.* TO 'sjgz_user'@'%';
-- FLUSH PRIVILEGES;

-- 显示创建的数据库
SHOW DATABASES;