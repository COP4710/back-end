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
    -- Could have a boolean instead
    -- `super_admin TINYINT NOT NULL DEFAULT 'false',

    -- The char was made for the purposes of having three roles, but if we just combine the admin and person role, which it seems
    -- we can, then we can just have two roles. Super admins and not super admins.
    `role` CHAR(1) NOT NULL DEFAULT 'p',
    PRIMARY KEY (`username`)
);


-- -----------------------------------------------------
-- Table `ExhibitDB`.`EventLocation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventLocation` (
    `name` VARCHAR(200) NOT NULL,
    `location` VARCHAR(200) NOT NULL,
    `description` TEXT(1000) NULL,
    `people_capacity` INT NULL,
    `area_size` VARCHAR(100) NULL,
    `location_id` INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`location`),
    INDEX(`location_id`)
    -- No check necessary here since we are determining this data. 
);


-- -----------------------------------------------------
-- Table `ExhibitDB`.`Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`Event` (
    `name` VARCHAR(200) NOT NULL,
    `category` VARCHAR(200) NULL,
    `description` TEXT(1000) NULL,
    `phone_number` VARCHAR(20) NULL,
    `email_address` VARCHAR(200) NULL,
    `num_attendees` INT NOT NULL,
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    `date` DATE NOT NULL,
    `approved` TINYINT NOT NULL DEFAULT 0,
    `host_id` VARCHAR(200) NOT NULL,
    `location_id` INT NOT NULL,
    `event_id` INT NOT NULL AUTO_INCREMENT,

    -- Name and time and date and location
    -- There should never be an event with the same name starting at the same time, date, and location as another.
    PRIMARY KEY(`name`, `start_time`, `date`, `location_id`),
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
        ON UPDATE NO ACTION,
    -- This ensures that the int is not overflowed
    -- However, we could make this a front end check so the sql request isn't even triggered. 
    CONSTRAINT `Attendees_Limit`
        CHECK (num_attendees > 0 AND num_attendees <= 2147483646)
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
-- Make sure to check if the commenter is an attendee
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventReview` (
    `rating` INT NULL,
    `comment` TEXT(1000) NULL,
    `commenter_id` VARCHAR(200) NOT NULL,
    `event_id` INT NOT NULL,
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
-- Table `ExhibitDB`.`EventProposed`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExhibitDB`.`EventProposed` (
    `location_id` INT NOT NULL,
    `event_id` INT NOT NULL,
    -- Event can only be proposed to one location at a time
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