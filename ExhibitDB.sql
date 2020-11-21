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
    `approved` TINYINT NOT NULL DEFAULT 0,
    `host_id` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL AUTO_INCREMENT,

    PRIMARY KEY(`title`, `start_date`, `address`),
    INDEX(`event_id`),
    CONSTRAINT `HostID_Event`
        FOREIGN KEY (`host_id`)
        REFERENCES `ExhibitDB`.`User` (`username`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `ExhibitDB`.`EventAttendee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventAttendee` (
    `user_id` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL,

    PRIMARY KEY(`user_id`, `event_id`),
    CONSTRAINT `UserID_EventAttendee`
        FOREIGN KEY (`user_id`)
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
    `commenter_id` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL,

    PRIMARY KEY(`commenter_id`, `event_id`),
    CONSTRAINT `EventID_EventReview`
        FOREIGN KEY (`event_id`)
        REFERENCES `ExhibitDB`.`Event` (`event_id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `CommenterID_EventReview`
        FOREIGN KEY (`commenter_id`)
        REFERENCES `ExhibitDB`.`User` (`username`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);