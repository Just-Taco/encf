-- Create the database
CREATE DATABASE enchantet /*!40100 COLLATE 'utf8mb4_general_ci' */;

-- Use the database
USE enchantet;

-- Create the table
CREATE TABLE `users` (
    `id` INT(11) NOT NULL DEFAULT '1',
    `identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    `banned` VARCHAR(50) NULL DEFAULT 'no' COLLATE 'utf8mb4_general_ci',
    `allowlisted` VARCHAR(50) NULL DEFAULT 'no' COLLATE 'utf8mb4_general_ci',
    `firstname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    `lastname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    `bank` INT(11) NULL DEFAULT '0',
    `wallet` INT(11) NULL DEFAULT '0',
    PRIMARY KEY (`id`) USING BTREE
) COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;
