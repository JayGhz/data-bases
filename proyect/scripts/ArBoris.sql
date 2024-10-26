CREATE DATABASE ArBoris;
USE  ArBoris;

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
    project_name varchar(100)  NOT NULL,
    client_name varchar(100)  NOT NULL,
    location_type varchar(100)  NOT NULL,
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
    problem_description varchar(100) NOT NULL,
    created_at datetime  NOT NULL,
    resolved_at datetime  NOT NULL,
    status varchar(100)  NOT NULL,
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
    description varchar(250)   NOT NULL,
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
    name_type varchar(100)  NOT NULL,
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
    plant_location varchar(100)  NOT NULL,
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
    name varchar(50)  NOT NULL,
    specialization varchar(100)  NOT NULL,
    languages_spoken varchar(100)  NOT NULL,
    bio varchar(100)  NOT NULL,
    CONSTRAINT support_experts_pk PRIMARY KEY  (id)
);

-- Table: users
CREATE TABLE users (
    id int  NOT NULL,
    subscription_type_id int  NOT NULL,
    username varchar(100)  NOT NULL,
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


-- Insert data
INSERT INTO subscription_types (id, name_type, description, start_date, end_date, cost) VALUES
(1, 'Básico', 'Acceso a la plataforma', '2021-01-01', '2021-12-31', 0),
(2, 'Premium', 'Acceso a la plataforma, soporte experto', '2021-01-01', '2021-12-31', 10),
(3, 'VIP', 'Acceso a la plataforma, soporte experto y notificaciones personalizadas', '2021-01-01', '2021-12-31', 20);


INSERT INTO users (id, subscription_type_id, username, email, password, address, phone) VALUES
(1, 1, 'maria123', 'maria@example.com', 'pass1234', 'Av. Larco 123, Lima', '987654321'),
(2, 2, 'carlos456', 'carlos@example.com', 'pass5678', 'Jr. Puno 456, Lima', '987654322'),
(3, 3, 'ana789', 'ana@example.com', 'pass9101', 'Calle Real 789, Lima', '987654323'),
(4, 1, 'pedro101', 'pedro@example.com', 'pass1121', 'Av. Salaverry 101, Lima', '987654324'),
(5, 2, 'juan202', 'juan@example.com', 'pass3141', 'Jr. Amazonas 202, Lima', '987654325'),
(6, 3, 'laura303', 'laura@example.com', 'pass5161', 'Av. Arequipa 303, Lima', '987654326'),
(7, 1, 'sofia404', 'sofia@example.com', 'pass7181', 'Jr. Cusco 404, Lima', '987654327'),
(8, 2, 'marta505', 'marta@example.com', 'pass9201', 'Calle Lima 505, Lima', '987654328'),
(9, 3, 'javier606', 'javier@example.com', 'pass1221', 'Av. Tacna 606, Lima', '987654329'),
(10, 1, 'elena707', 'elena@example.com', 'pass3241', 'Jr. Arequipa 707, Lima', '987654330'),
(11, 1, 'designer_ace', 'ace@example.com', 'pass4321', 'Av. Javier Prado 123, Lima', '987654331'),
(12, 2, 'creative_mind', 'creative@example.com', 'pass5432', 'Jr. Miraflores 456, Lima', '987654332'),
(13, 3, 'design_guru', 'guru@example.com', 'pass6543', 'Calle San Isidro 789, Lima', '987654333'),
(14, 1, 'artistic_soul', 'soul@example.com', 'pass7654', 'Av. Benavides 101, Lima', '987654334'),
(15, 2, 'visionary_eye', 'eye@example.com', 'pass8765', 'Jr. Barranco 202, Lima', '987654335'),
(16, 3, 'style_master', 'master@example.com', 'pass9876', 'Av. Pardo 303, Lima', '987654336'),
(17, 1, 'trendsetter', 'trend@example.com', 'pass0987', 'Jr. Surco 404, Lima', '987654337'),
(18, 2, 'design_wizard', 'wizard@example.com', 'pass1098', 'Calle Chorrillos 505, Lima', '987654338'),
(19, 3, 'aesthetic_pro', 'pro@example.com', 'pass2109', 'Av. Angamos 606, Lima', '987654339'),
(20, 1, 'modern_artist', 'artist@example.com', 'pass3210', 'Jr. La Molina 707, Lima', '987654340');


INSERT INTO designers (id, user_id, company_name, experience_level, design_preferences_list) VALUES
(1, 11, 'Jardines de la Abuela', 'Principiante', 'Plantas autóctonas, Jardines de la Abuela'),
(2, 12, 'Terrazas de la Ciudad', 'Intermedio', 'Plantas tropicales, Terrazas de la Ciudad'),
(3, 13, 'Patios de la Casa', 'Avanzado', 'Plantas de sombra, Patios de la Casa'),
(4, 14, 'Jardines de la Oficina', 'Principiante', 'Plantas de bajo mantenimiento, Jardines de la Oficina'),
(5, 15, 'Terrazas del Apartamento', 'Intermedio', 'Plantas de interior, Terrazas del Apartamento'),
(6, 16, 'Patios de la Casa de Campo', 'Avanzado', 'Plantas de exterior, Patios de la Casa de Campo'),
(7, 17, 'Jardines de la Casa de Playa', 'Principiante', 'Plantas de sol, Jardines de la Casa de Playa'),
(8, 18, 'Terrazas del Loft', 'Intermedio', 'Plantas de sombra, Terrazas del Loft'),
(9, 19, 'Patios de la Casa de Montaña', 'Avanzado', 'Plantas de bajo mantenimiento, Patios de la Casa de Montaña'),
(10, 20, 'Jardines de la Casa de Campo', 'Principiante', 'Plantas de interior, Jardines de la Casa de Campo');


INSERT INTO amateurs (id, user_id, bio, interests_amateur, favorite_plants_amateur) VALUES
(1, 1, 'Amante de la jardinería y la lectura', 'Jardinería, Lectura', 'Rosas, Lirios'),
(2, 2, 'Interesado en la botánica y la pintura', 'Botánica, Pintura', 'Tulipanes, Margaritas'),
(3, 3, 'Apasionado por la fotografía y el senderismo', 'Fotografía, Senderismo', 'Orquídeas, Girasoles'),
(4, 4, 'Cocinero aficionado y practicante de yoga', 'Cocina, Yoga', 'Cactus, Helechos'),
(5, 5, 'Corredor y viajero frecuente', 'Correr, Viajar', 'Suculentas, Lavanda'),
(6, 6, 'Amante de los animales y la naturaleza', 'Animales, Naturaleza', 'Bromelias, Hortensias'),
(7, 7, 'Interesado en el cultivo de huertos urbanos', 'Huertos Urbanos, Sostenibilidad', 'Aloe Vera, Romero'),
(8, 8, 'Fascinado por las plantas tropicales', 'Plantas Tropicales, Arte', 'Palmeras, Bambú'),
(9, 9, 'Científico aficionado al cuidado de plantas raras', 'Ciencia, Plantas Raras', 'Venus Atrapamoscas, Bonsái'),
(10, 10, 'Jardinero aficionado con un enfoque en plantas autóctonas', 'Jardinería, Plantas Autóctonas', 'Tomillo, Manzanilla');


INSERT INTO plant_types (id, name_type, description) VALUES
(1, 'Suculentas', 'Plantas que almacenan agua en sus hojas'),
(2, 'Cactus', 'Plantas que almacenan agua en su tallo'),
(3, 'Helechos', 'Plantas que no tienen flores'),
(4, 'Orquídeas', 'Plantas con flores exóticas'),
(5, 'Girasoles', 'Plantas con flores amarillas'),
(6, 'Hierbas Aromáticas', 'Plantas comestibles y aromáticas'),
(7, 'Plantas Medicinales', 'Plantas utilizadas en la medicina tradicional'),
(8, 'Plantas de Interior', 'Plantas que purifican el aire y son adecuadas para interiores'),
(9, 'Plantas de Bajo Mantenimiento', 'Plantas que no requieren mucho cuidado'),
(10, 'Plantas Atractivas para Fauna', 'Plantas que atraen a los animales como aves y mariposas');


INSERT INTO plants (id, user_id, plant_type_id, plant_name, acquisition_date) VALUES
(1, 1, 1, 'Suculenta de María', '2021-01-01'),
(2, 2, 2, 'Cactus de Carlos', '2021-02-01'),
(3, 3, 3, 'Helecho de Ana', '2021-03-01'),
(4, 4, 4, 'Orquídea de Pedro', '2021-04-01'),
(5, 5, 5, 'Girasolín de Laura', '2021-05-01'),
(6, 6, 6, 'Albahaca de Juan', '2021-06-01'),
(7, 7, 7, 'Manzanilla de Sofía', '2021-07-01'),
(8, 8, 8, 'Aloe Vera de Marta', '2021-08-01'),
(9, 9, 9, 'Venus Atrapamoscas de Javier', '2021-09-01'),
(10, 10, 10, 'Tomillo de Elena', '2021-10-01');


INSERT INTO design_projects (id, designer_id, project_name, client_name, location_type, start_date, end_date, notes_project) VALUES
(1, 1, 'Jardín de la Abuela', 'María', 'Jardín', '2021-01-01', '2021-02-01', 'Jardín con plantas autóctonas'),
(2, 2, 'Terraza de la Ciudad', 'Carlos', 'Terraza', '2021-02-01', '2021-03-01', 'Terraza con plantas tropicales'),
(3, 3, 'Patio de la Casa', 'Ana', 'Patio', '2021-03-01', '2021-04-01', 'Patio con plantas de sombra'),
(4, 4, 'Jardín de la Oficina', 'Pedro', 'Jardín', '2021-04-01', '2021-05-01', 'Jardín con plantas de bajo mantenimiento'),
(5, 5, 'Terraza del Apartamento', 'Laura', 'Terraza', '2021-05-01', '2021-06-01', 'Terraza con plantas de interior'),
(6, 6, 'Patio de la Casa de Campo', 'Juan', 'Patio', '2021-06-01', '2021-07-01', 'Patio con plantas de exterior'),
(7, 7, 'Jardín de la Casa de Playa', 'Sofía', 'Jardín', '2021-07-01', '2021-08-01', 'Jardín con plantas de sol'),
(8, 8, 'Terraza del Loft', 'Marta', 'Terraza', '2021-08-01', '2021-09-01', 'Terraza con plantas de sombra'),
(9, 9, 'Patio de la Casa de Montaña', 'Javier', 'Patio', '2021-09-01', '2021-10-01', 'Patio con plantas de bajo mantenimiento'),
(10, 10, 'Jardín de la Casa de Campo', 'Elena', 'Jardín', '2021-10-01', '2021-11-01', 'Jardín con plantas de interior');


INSERT INTO support_experts (id, name, specialization, languages_spoken, bio) VALUES
(1, 'Lucía Torres', 'Riego', 'Español, Inglés', 'Experta en riego de plantas'),
(2, 'Miguel Díaz', 'Podar', 'Español, Francés', 'Experto en poda de plantas'),
(3, 'Isabel Ruiz', 'Fertilización', 'Español, Alemán', 'Experta en fertilización de plantas'),
(4, 'Andrés Morales', 'Cambio de maceta', 'Español, Italiano', 'Experto en cambio de maceta de plantas'),
(5, 'Carmen Castillo', 'Riego', 'Español, Portugués', 'Experta en riego de plantas'),
(6, 'Diego Romero', 'Podar', 'Español, Ruso', 'Experto en poda de plantas'),
(7, 'Valeria Ortiz', 'Fertilización', 'Español, Chino', 'Experta en fertilización de plantas'),
(8, 'Santiago Vargas', 'Cambio de maceta', 'Español, Japonés', 'Experto en cambio de maceta de plantas'),
(9, 'Adriana Mendoza', 'Riego', 'Español, Coreano', 'Experta en riego de plantas'),
(10, 'Fernando Navarro', 'Podar', 'Español, Árabe', 'Experto en poda de plantas');


INSERT INTO help_requests (id, amateur_id, support_expert_id, request_type, problem_description, created_at, resolved_at, status) VALUES
(1, 1, 1, 'Riego', 'Planta con hojas secas', '2021-01-01', '2021-01-02', 'Resuelto'),
(2, 2, 2, 'Podar', 'Planta con hojas amarillas', '2021-02-01', '2021-02-02', 'Resuelto'),
(3, 3, 3, 'Fertilización', 'Planta con hojas caídas', '2021-03-01', '2021-03-02', 'Pendiente'),
(4, 4, 4, 'Cambio de maceta', 'Planta con raíces expuestas', '2021-04-01', '2021-04-02', 'Resuelto'),
(5, 5, 5, 'Riego', 'Planta con hojas secas', '2021-05-01', '2021-05-02', 'Resuelto'),
(6, 6, 6, 'Podar', 'Planta con hojas amarillas', '2021-06-01', '2021-06-02', 'Pendiente'),
(7, 7, 7, 'Fertilización', 'Planta con hojas caídas', '2021-07-01', '2021-07-02', 'Pendiente'),
(8, 8, 8, 'Cambio de maceta', 'Planta con raíces expuestas', '2021-08-01', '2021-08-02', 'Resuelto'),
(9, 9, 9, 'Riego', 'Planta con hojas secas', '2021-09-01', '2021-09-02', 'Resuelto'),
(10, 10, 10, 'Podar', 'Planta con hojas amarillas', '2021-10-01', '2021-10-02', 'Resuelto');


INSERT INTO help_request_plants (help_request_id, plant_id, recommendation_given, follow_up_required) VALUES
(1, 1, 'Podar las hojas secas', 1),
(2, 2, 'Cambiar la maceta', 0),
(3, 3, 'Regar con menos frecuencia', 1),
(4, 4, 'Fertilizar con abono orgánico', 0),
(5, 5, 'Podar las hojas secas', 1),
(6, 6, 'Cambiar la maceta', 0),
(7, 7, 'Regar con menos frecuencia', 1),
(8, 8, 'Fertilizar con abono orgánico', 0),
(9, 9, 'Podar las hojas secas', 1),
(10, 10, 'Cambiar la maceta', 0);


INSERT INTO plant_care_details (id, plant_id, fertilizer_type, fertilization_per_month, land_type, light_conditions_plant, watering_interval_days_plant, healthy, care_tips_plant) VALUES
(1, 1, 'Abono orgánico', 1, 'Arcilloso', 'Luz directa', 7, 1, 'Podar las hojas secas'),
(2, 2, 'Abono químico', 2, 'Arenoso', 'Sombra', 14, 1, 'Cambiar la maceta'),
(3, 3, 'Abono orgánico', 1, 'Franco', 'Luz indirecta', 7, 0, 'Regar con menos frecuencia'),
(4, 4, 'Abono orgánico', 2, 'Turba', 'Luz directa, Sombra', 14, 0, 'Fertilizar con abono orgánico'),
(5, 5, 'Abono químico', 1, 'Arcilloso', 'Luz directa', 7, 1, 'Podar las hojas secas'),
(6, 6, 'Abono orgánico', 2, 'Arenoso', 'Sombra', 14, 1, 'Cambiar la maceta'),
(7, 7, 'Abono orgánico', 1, 'Franco', 'Luz indirecta', 7, 0, 'Regar con menos frecuencia'),
(8, 8, 'Abono orgánico', 2, 'Turba', 'Luz directa, Sombra', 14, 0, 'Fertilizar con abono orgánico'),
(9, 9, 'Abono químico', 1, 'Arcilloso', 'Luz directa', 7, 1, 'Podar las hojas secas'),
(10, 10, 'Abono orgánico', 2, 'Arenoso', 'Sombra', 14, 1, 'Cambiar la maceta');


INSERT INTO plant_care_logs (id, plant_id, care_type, care_date, details_log, remarks_log) VALUES
(1, 1, 'Podar', '2021-01-01', 'Se podaron las hojas secas', 'La planta está más saludable'),
(2, 2, 'Cambio de maceta', '2021-02-01', 'Se cambió la maceta', 'La planta está más feliz'),
(3, 3, 'Riego', '2021-03-01', 'Se regó con menos frecuencia', 'La planta está más verde'),
(4, 4, 'Fertilización', '2021-04-01', 'Se fertilizó con abono orgánico', 'La planta está más fuerte'),
(5, 5, 'Podar', '2021-05-01', 'Se podaron las hojas secas', 'La planta está más saludable'),
(6, 6, 'Cambio de maceta', '2021-06-01', 'Se cambió la maceta', 'La planta está más feliz'),
(7, 7, 'Riego', '2021-07-01', 'Se regó con menos frecuencia', 'La planta está más verde'),
(8, 8, 'Fertilización', '2021-08-01', 'Se fertilizó con abono orgánico', 'La planta está más fuerte'),
(9, 9, 'Podar', '2021-09-01', 'Se podaron las hojas secas', 'La planta está más saludable'),
(10, 10, 'Cambio de maceta', '2021-10-01', 'Se cambió la maceta', 'La planta está más feliz');


INSERT INTO suggestions (id, design_project_id, plant_id, plant_location, plant_combinations_project, growth_rate, special_requirements_plant, other_aspects_plant, suggestion_date) VALUES
(1, 1, 1, 'Jardín', 'Suculentas, Cactus', 'Lento', 'Suelo arcilloso', 'Luz directa', '2021-01-01'),
(2, 2, 2, 'Terraza', 'Cactus, Helechos', 'Rápido', 'Suelo arenoso', 'Sombra', '2021-02-01'),
(3, 3, 3, 'Patio', 'Helechos, Orquídeas', 'Lento', 'Suelo franco', 'Luz indirecta', '2021-03-01'),
(4, 4, 4, 'Jardín', 'Orquídeas, Girasoles', 'Rápido', 'Suelo de turba', 'Luz directa, Sombra', '2021-04-01'),
(5, 5, 5, 'Terraza', 'Girasoles, Hierbas Aromáticas', 'Lento', 'Suelo arcilloso', 'Luz directa', '2021-05-01'),
(6, 6, 6, 'Patio', 'Hierbas Aromáticas, Plantas Medicinales', 'Rápido', 'Suelo arenoso', 'Sombra', '2021-06-01'),
(7, 7, 7, 'Jardín', 'Plantas Medicinales, Plantas de Interior', 'Lento', 'Suelo franco', 'Luz indirecta', '2021-07-01'),
(8, 8, 8, 'Terraza', 'Plantas de Interior, Plantas de Bajo Mantenimiento', 'Rápido', 'Suelo de turba', 'Luz directa, Sombra', '2021-08-01'),
(9, 9, 9, 'Patio', 'Plantas de Bajo Mantenimiento, Plantas Atractivas para Fauna', 'Lento', 'Suelo arcilloso', 'Luz directa', '2021-09-01'),
(10, 10, 10, 'Jardín', 'Plantas Atractivas para Fauna, Suculentas', 'Rápido', 'Suelo arenoso', 'Sombra', '2021-10-01');