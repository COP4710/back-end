-- -----------------------------------------------------
-- Schema ExhibitDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ExhibitDB` DEFAULT CHARACTER SET utf8mb4;
USE `ExhibitDB`;

-- -----------------------------------------------------
-- Table `ExhibitDB`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`User` (
    `username` VARCHAR(200) NOT NULL,
    `password` VARCHAR(200) NOT NULL,
    `role` CHAR(1) NOT NULL DEFAULT 'p',

    PRIMARY KEY (`username`)
);

-- -----------------------------------------------------
-- Table `ExhibitDB`.`Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`Event` (
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT(1000) NULL,
    `event_homepage` VARCHAR(10000) NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `address` VARCHAR(200) NOT NULL,
    `city` VARCHAR(200) NOT NULL,
    `approved` TINYINT NOT NULL DEFAULT 0,
    `host_username` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL AUTO_INCREMENT,

    PRIMARY KEY(`title`, `start_date`, `address`, `city`),
    INDEX(`event_id`),
    CONSTRAINT `HostUsername_Event`
        FOREIGN KEY (`host_username`)
        REFERENCES `ExhibitDB`.`User` (`username`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `ExhibitDB`.`EventAttendee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventAttendee` (
    `user_username` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL,

    PRIMARY KEY(`user_username`, `event_id`),
    CONSTRAINT `user_username_EventAttendee`
        FOREIGN KEY (`user_username`)
        REFERENCES `ExhibitDB`.`User` (`username`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `EventID_EventAttendee`
        FOREIGN KEY (`event_id`)
        REFERENCES `ExhibitDB`.`Event` (`event_id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `ExhibitDB`.`EventReview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventReview` (
    `rating` INT NULL,
    `comment` TEXT(1000) NULL,
    `commenter_username` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL,

    PRIMARY KEY(`commenter_username`, `event_id`),
    CONSTRAINT `EventID_EventReview`
        FOREIGN KEY (`event_id`)
        REFERENCES `ExhibitDB`.`Event` (`event_id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `Commenter_username_EventReview`
        FOREIGN KEY (`commenter_username`)
        REFERENCES `ExhibitDB`.`User` (`username`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);