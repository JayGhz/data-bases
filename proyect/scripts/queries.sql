SELECT dp.project_name AS Proyecto, u.username AS Diseñador
FROM design_projects dp
JOIN designers d ON dp.designer_id = d.id
JOIN users u ON d.user_id = u.id;

SELECT u.username, s.name_type AS subscription_type
FROM users u
JOIN subscription_types s ON u.subscription_type_id = s.id;

SELECT d.company_name AS Compañia, p.plant_name AS Planta
FROM designers d JOIN users u ON d.id = u.id
JOIN plants p ON u.id = p.user_id

SELECT d.company_name, d.experience_level, COUNT(p.id) AS total_projects
FROM designers d
LEFT JOIN design_projects p ON d.id = p.designer_id
GROUP BY d.company_name, d.experience_level;

SELECT TOP 5 hr.id, u.username AS user_name, hr.problem_description, hr.created_at
FROM help_requests hr
JOIN amateurs a ON hr.amateur_id = a.id
JOIN users u ON a.user_id = u.id
ORDER BY hr.created_at DESC;



CREATE PROCEDURE BuscarPlantasPorTipo
@tipoPlanta VARCHAR(250)
AS
BEGIN
    SELECT p.plant_name AS Planta,u.username AS Usuario,pt.name_type AS Tipo
    FROM plants p
    JOIN plant_types pt ON p.plant_type_id = pt.id
    JOIN users u ON p.user_id = u.id
    WHERE pt.name_type = @tipoPlanta;
END
GO

EXEC  BuscarPlantasPorTipo 'Suculentas'


CREATE PROCEDURE ObtenerAyudasPendientesPorAmateur
@idAmateur INT
AS
BEGIN
    SELECT hr.request_type AS TipoSolicitud, hr.problem_description AS Descripcion, se.name AS ExpertoAsignado
    FROM help_requests hr
    JOIN support_experts se ON hr.support_expert_id = se.id
    WHERE hr.amateur_id = @idAmateur AND hr.status = 'Pendiente';
END
GO

EXEC ObtenerAyudasPendientesPorAmateur 3



CREATE PROCEDURE support_and_users
@supportname varchar(250)
AS
  BEGIN
	SELECT sp.name AS Nombre, u.username AS Usuarios_ayudados
	FROM support_experts sp
	JOIN help_requests hr ON hr.support_expert_id = sp.id
	JOIN amateurs a ON hr.amateur_id = a.id
	JOIN users u ON a.user_id = u.id
	WHERE sp.name = @supportname
END
GO

EXEC support_and_users 'Lucía Torres'


CREATE PROCEDURE recommendation_username
@nombre varchar(250)
AS
 BEGIN
    SELECT pa.plant_name AS Planta, hrp.recommendation_given AS Recomendacion
	FROM users u JOIN plants pa ON u.id = pa.user_id
	JOIN help_request_plants hrp ON pa.id = hrp.plant_id
	WHERE u.username = @nombre
END
GO


EXEC recommendation_username 'maria123'


CREATE PROCEDURE ObtenerProyectosPorDiseñador
    @designerId INT
AS
BEGIN
    SELECT
        p.project_name AS Proyecto,
        p.client_name AS Cliente,
        p.location_type AS TipoUbicacion,
        p.start_date AS FechaInicio,
        p.end_date AS FechaFin,
        p.notes_project AS Notas
    FROM design_projects p
    WHERE p.designer_id = @designerId;
END
GO

EXEC ObtenerProyectosPorDiseñador @designerId = 3;


CREATE PROCEDURE ObtenerAyudaPorAmateur
    @amateurId INT
AS
BEGIN
    SELECT
        h.request_type AS TipoSolicitud,
        h.problem_description AS DescripcionProblema,
        h.created_at AS FechaCreacion,
        h.resolved_at AS FechaResolucion,
        h.status AS Estado
    FROM help_requests h
    WHERE h.amateur_id = @amateurId;
END
GO
EXEC ObtenerAyudaPorAmateur @amateurId = 1;


CREATE PROCEDURE contarUsuariosPorSuscripcion
AS
BEGIN
    SELECT st.name_type AS Suscripcion, COUNT(u.id) AS NumeroUsuarios
    FROM subscription_types st
    LEFT JOIN users u ON st.id = u.subscription_type_id
    GROUP BY st.name_type;
END
GO

EXEC contarUsuariosPorSuscripcion;


CREATE PROCEDURE get_help_requests_by_type
    @request_type VARCHAR(100)
AS
BEGIN
    SELECT hr.id, u.username AS user_name, hr.problem_description, hr.created_at, hr.status
    FROM help_requests hr
    JOIN amateurs a ON hr.amateur_id = a.id
    JOIN users u ON a.user_id = u.id
    WHERE hr.request_type = @request_type;
END;
GO

EXEC get_help_requests_by_type 'Riego';


CREATE PROCEDURE get_projects_by_date_range
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT dp.project_name, dp.client_name, dp.start_date, dp.end_date, d.company_name
    FROM design_projects dp
    JOIN designers d ON dp.designer_id = d.id
    WHERE dp.start_date BETWEEN @start_date AND @end_date;
END;
GO

EXEC get_projects_by_date_range '2021-01-01', '2021-12-31';



CREATE FUNCTION project_progress(@project_id INT)
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @start_date DATE;
    DECLARE @end_date DATE;
    DECLARE @progress DECIMAL(5, 2);


    SELECT @start_date = start_date, @end_date = end_date
    FROM design_projects
    WHERE id = @project_id;

    IF GETDATE() < @start_date
    BEGIN
        SET @progress = 0.00;
    END
    ELSE IF GETDATE() > @end_date
    BEGIN
        SET @progress = 100.00;
    END
    ELSE
    BEGIN
        SET @progress = (CAST(DATEDIFF(DAY, @start_date, GETDATE()) AS DECIMAL(5, 2))
                         / NULLIF(DATEDIFF(DAY, @start_date, @end_date), 0)) * 100;
    END

    RETURN @progress;
END;

SELECT
    dp.id AS ProjectID,
    u.username AS DesignerName,
    dp.start_date AS StartDate,
    dbo.project_progress(dp.id) AS ProjectProgress
FROM
    design_projects dp
JOIN
    users u ON dp.designer_id = u.id
WHERE
    dp.id = 1;



CREATE FUNCTION top_designer()
RETURNS INT
AS
BEGIN
    DECLARE @top_designer_id INT;

    SELECT @top_designer_id = designer_id
    FROM (
        SELECT
            designer_id,
            COUNT(id) AS ProjectCount
        FROM
            design_projects
        GROUP BY
            designer_id
    ) AS Subquery
    ORDER BY ProjectCount DESC
    OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

    RETURN @top_designer_id;
END;

SELECT dbo.top_designer();



CREATE FUNCTION recommend_plants(@amateur_id INT)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @interests VARCHAR(100);
    DECLARE @recommendations VARCHAR(255);

    SELECT @interests = interests_amateur
    FROM amateurs
    WHERE id = @amateur_id;

    SELECT @recommendations = STRING_AGG(favorite_plants_amateur, ', ')
    FROM (
        SELECT DISTINCT favorite_plants_amateur
        FROM amateurs
        WHERE interests_amateur = @interests
        AND id != @amateur_id
    ) AS distinct_plants;

    RETURN @recommendations;
END;

SELECT dbo.recommend_plants(1);