CREATE DATABASE ArBoris;

-- tables
-- Table: amateurs
USE  ArBoris
CREATE TABLE amateurs (
    id int  NOT NULL,
    user_id int  NOT NULL,
    bio varchar(100)  NOT NULL,
    interests_amateur varchar(100)  NOT NULL,
    favorite_plants_amateur varchar(100)  NOT NULL,
    CONSTRAINT amateurs_pk PRIMARY KEY  (id)
);

-- Table: design_projects
CREATE TABLE design_projects (
    id int  NOT NULL,
    designer_id int  NOT NULL,
    project_name varchar(10)  NOT NULL,
    client_name varchar(10)  NOT NULL,
    location_type varchar(10)  NOT NULL,
    start_date date  NOT NULL,
    end_date date  NOT NULL,
    notes_project varchar(100)  NOT NULL,
    CONSTRAINT design_projects_pk PRIMARY KEY  (id)
);

-- Table: designers
CREATE TABLE designers (
    id int  NOT NULL,
    user_id int  NOT NULL,
    company_name varchar(250)  NOT NULL,
    experience_level varchar(100)  NOT NULL,
    design_preferences_list varchar(100)  NOT NULL,
    CONSTRAINT designers_pk PRIMARY KEY  (id)
);

-- Table: help_request_plants
CREATE TABLE help_request_plants (
    help_request_id int  NOT NULL,
    plant_id int  NOT NULL,
    recommendation_given varchar(100)  NOT NULL,
    follow_up_required bit  NOT NULL,
    CONSTRAINT help_request_plants_pk PRIMARY KEY  (help_request_id,plant_id)
);

-- Table: help_requests
CREATE TABLE help_requests (
    id int  NOT NULL,
    amateur_id int  NOT NULL,
    support_expert_id int  NOT NULL,
    request_type varchar(100)  NOT NULL,
    problem_description int  NOT NULL,
    created_at datetime  NOT NULL,
    resolved_at datetime  NOT NULL,
    status varchar(10)  NOT NULL,
    CONSTRAINT help_requests_pk PRIMARY KEY  (id)
);

-- Table: plant_care_details
CREATE TABLE plant_care_details (
    id int  NOT NULL,
    plant_id int  NOT NULL,
    fertilizer_type varchar(250)  NOT NULL,
    fertilization_per_month int  NOT NULL,
    land_type varchar(250)  NOT NULL,
    light_conditions_plant varchar(250)  NOT NULL,
    watering_interval_days_plant int  NOT NULL,
    healthy int  NOT NULL,
    care_tips_plant varchar(100)  NOT NULL,
    CONSTRAINT plant_care_details_pk PRIMARY KEY  (id)
);

-- Table: plant_care_logs
CREATE TABLE plant_care_logs (
    id int  NOT NULL,
    plant_id int  NOT NULL,
    care_type varchar(250)  NOT NULL,
    care_date date  NOT NULL,
    details_log varchar(200)  NOT NULL,
    remarks_log varchar(200)  NOT NULL,
    CONSTRAINT plant_care_logs_pk PRIMARY KEY  (id)
);

-- Table: plant_types
CREATE TABLE plant_types (
    id int  NOT NULL,
    name_type varchar(250)  NOT NULL,
    description int  NOT NULL,
    CONSTRAINT plant_types_pk PRIMARY KEY  (id)
);

-- Table: plants
CREATE TABLE plants (
    id int  NOT NULL,
    user_id int  NOT NULL,
    plant_type_id int  NOT NULL,
    plant_name varchar(250)  NOT NULL,
    acquisition_date date  NOT NULL,
    CONSTRAINT plants_pk PRIMARY KEY  (id)
);

-- Table: subscription_types
CREATE TABLE subscription_types (
    id int  NOT NULL,
    name_type varchar(10)  NOT NULL,
    description varchar(250)  NOT NULL,
    start_date date  NOT NULL,
    end_date date  NOT NULL,
    cost float  NOT NULL,
    CONSTRAINT subscription_types_pk PRIMARY KEY  (id)
);

-- Table: suggestions
CREATE TABLE suggestions (
    id int  NOT NULL,
    design_project_id int  NOT NULL,
    plant_id int  NOT NULL,
    plant_location varchar(10)  NOT NULL,
    plant_combinations_project varchar(100)  NOT NULL,
    growth_rate varchar(100)  NOT NULL,
    special_requirements_plant varchar(100)  NOT NULL,
    other_aspects_plant varchar(100)  NOT NULL,
    suggestion_date date  NOT NULL,
    CONSTRAINT suggestions_pk PRIMARY KEY  (id)
);

-- Table: support_experts
CREATE TABLE support_experts (
    id int  NOT NULL,
    name varchar(8)  NOT NULL,
    specialization varchar(100)  NOT NULL,
    languages_spoken varchar(100)  NOT NULL,
    bio varchar(100)  NOT NULL,
    CONSTRAINT support_experts_pk PRIMARY KEY  (id)
);

-- Table: users
CREATE TABLE users (
    id int  NOT NULL,
    subscription_type_id int  NOT NULL,
    username varchar(10)  NOT NULL,
    email varchar(20)  NOT NULL,
    password varchar(8)  NOT NULL,
    address varchar(250)  NOT NULL,
    phone varchar(250)  NOT NULL,
    CONSTRAINT users_pk PRIMARY KEY  (id)
);

-- foreign keys
-- Reference: Amateur_Users (table: amateurs)
ALTER TABLE amateurs ADD CONSTRAINT Amateur_Users
    FOREIGN KEY (user_id)
    REFERENCES users (id);

-- Reference: Decorator_Users (table: designers)
ALTER TABLE designers ADD CONSTRAINT Decorator_Users
    FOREIGN KEY (user_id)
    REFERENCES users (id);

-- Reference: Design_Projects_Decorators (table: design_projects)
ALTER TABLE design_projects ADD CONSTRAINT Design_Projects_Decorators
    FOREIGN KEY (designer_id)
    REFERENCES designers (id);

-- Reference: Help_Request_Plants_Help_Requests (table: help_request_plants)
ALTER TABLE help_request_plants ADD CONSTRAINT Help_Request_Plants_Help_Requests
    FOREIGN KEY (help_request_id)
    REFERENCES help_requests (id);

-- Reference: Help_Request_Plants_Plants (table: help_request_plants)
ALTER TABLE help_request_plants ADD CONSTRAINT Help_Request_Plants_Plants
    FOREIGN KEY (plant_id)
    REFERENCES plants (id);

-- Reference: Help_Requests_Amateurs (table: help_requests)
ALTER TABLE help_requests ADD CONSTRAINT Help_Requests_Amateurs
    FOREIGN KEY (amateur_id)
    REFERENCES amateurs (id);

-- Reference: Help_Requests_Support_Experts (table: help_requests)
ALTER TABLE help_requests ADD CONSTRAINT Help_Requests_Support_Experts
    FOREIGN KEY (support_expert_id)
    REFERENCES support_experts (id);

-- Reference: Plant_Care_Details_Plants (table: plant_care_details)
ALTER TABLE plant_care_details ADD CONSTRAINT Plant_Care_Details_Plants
    FOREIGN KEY (plant_id)
    REFERENCES plants (id);

-- Reference: Plant_Care_Logs_Plants (table: plant_care_logs)
ALTER TABLE plant_care_logs ADD CONSTRAINT Plant_Care_Logs_Plants
    FOREIGN KEY (plant_id)
    REFERENCES plants (id);

-- Reference: Plants_Type_Plants (table: plants)
ALTER TABLE plants ADD CONSTRAINT Plants_Type_Plants
    FOREIGN KEY (plant_type_id)
    REFERENCES plant_types (id);

-- Reference: Plants_Users (table: plants)
ALTER TABLE plants ADD CONSTRAINT Plants_Users
    FOREIGN KEY (user_id)
    REFERENCES users (id);

-- Reference: Suggestions_Design_Projects (table: suggestions)
ALTER TABLE suggestions ADD CONSTRAINT Suggestions_Design_Projects
    FOREIGN KEY (design_project_id)
    REFERENCES design_projects (id);

-- Reference: Suggestions_Plants (table: suggestions)
ALTER TABLE suggestions ADD CONSTRAINT Suggestions_Plants
    FOREIGN KEY (plant_id)
    REFERENCES plants (id);

-- Reference: Users_Type_Subscription (table: users)
ALTER TABLE users ADD CONSTRAINT Users_Type_Subscription
    FOREIGN KEY (subscription_type_id)
    REFERENCES subscription_types (id);

-- End of file.

