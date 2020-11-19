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
-- Table `ExhibitDB`.`EventLocation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventLocation` (
    `location` VARCHAR(200) NOT NULL,
    `location_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `description` TEXT(1000) NULL,
    `area_size` VARCHAR(100) NULL,
    `people_capacity` INT NULL,
    -- `owner` VARCHAR(200) NOT NULL,
    PRIMARY KEY (`location`),
    INDEX(`location_id`),
    -- CONSTRAINT `OwnerID_EventLocation`
    --     FOREIGN KEY (`owner`)
    --     REFERENCES `ExhibitDB`.`User` (`username`)
    --     ON DELETE CASCADE
    --     ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table `ExhibitDB`.`Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`Event` (
    `event_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `category` VARCHAR(200) NULL,
    `description` TEXT(1000) NULL,
    `time` TIME NOT NULL,
    `date` DATE NOT NULL,
    `phone_number` VARCHAR(20) NULL,
    `email_address` VARCHAR(200) NULL,
    `host_id` VARCHAR(200) NOT NULL,
    `location_id` INT NOT NULL,
    `public` TINYINT NOT NULL DEFAULT 0,
    `approved` TINYINT NOT NULL DEFAULT 0,
    -- Name and time and date and location
    -- There should never be an event with the same name happening at the same time, date, and location as another.
    PRIMARY KEY(`name`, `time`, `date`, `location_id`),
    INDEX(`event_id`),
    CONSTRAINT `HostID_Event`
        FOREIGN KEY (`host_id`)
        REFERENCES `ExhibitDB`.`User` (`username`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `LocationID_Event`
        FOREIGN KEY (`location_id`)
        REFERENCES `ExhibitDB`.`EventLocation` (`location_id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table `ExhibitDB`.`Invitation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`Invitation` (
    `invited_id` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL,
    PRIMARY KEY(`invited_id`, `event_id`),
    CONSTRAINT `EventID_Invitation`
        FOREIGN KEY (`event_id`)
        REFERENCES `ExhibitDB`.`Event` (`event_id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `InvitedUserID_Invitation`
        FOREIGN KEY (`invited_id`)
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
    `commenter_id` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL,
    `rating` INT NULL,
    `comment` TEXT(1000) NULL,
    -- A user can only comment once on a single event
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


-- -----------------------------------------------------
-- Table `ExhibitDB`.`LocationPicture`
-- -----------------------------------------------------
-- Do we want multiple pictures or just one picture?
-- CREATE TABLE IF NOT EXISTS `ExhibitDB`.`LocationPicture` (
--     `location_id` INT NOT NULL,
--     `image_val` BIGINT NOT NULL,
--     `picture` LONGBLOB NULL,
--     -- This is kind of gross. Have to compare longblob's
--     PRIMARY KEY(`location_id`, `image_val`),
--     CONSTRAINT `LocationID_LocationPicture`
--         FOREIGN KEY (`location_id`)
--         REFERENCES `ExhibitDB`.`EventLocation` (`location_id`)
--         ON DELETE CASCADE
--         ON UPDATE NO ACTION
-- );


-- -----------------------------------------------------
-- Table `ExhibitDB`.`EventProposed`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventProposed` (
    `location_id` INT NOT NULL,
    `event_id` INT NOT NULL,
    -- Event can only be proposed to one 
    PRIMARY KEY (`location_id`, `event_id`),
    CONSTRAINT `EventID_EventProposed`
        FOREIGN KEY (`event_id`)
        REFERENCES `ExhibitDB`.`Event` (`event_id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `LocationID_EventProposed`
        FOREIGN KEY (`location_id`)
        REFERENCES `ExhibitDB`.`EventLocation` (`location_id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);