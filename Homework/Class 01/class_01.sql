-- Student
CREATE TABLE student (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(30),
	date_of_birth DATE,
	enrolled_date DATE,
	gender VARCHAR(10),
	national_id_number VARCHAR(10) UNIQUE,
	student_card_number INTEGER UNIQUE
);

INSERT INTO student VALUES
	(1, 'John', 'Doe', '2000-01-01', '2024-10-10', 'male', 'A435MS2', 345321),
	(2, 'Jane', 'Doe', '2001-08-03', '2024-09-10', 'female', 'A876N87', 345330)

SELECT * FROM student

-- Teacher
CREATE TABLE teacher (
	id SERIAL PRIMARY KEY, 
	first_name VARCHAR(20),
	last_name VARCHAR(30),
	date_of_birth DATE,
	academic_rank VARCHAR(20),
	hire_date DATE
);

INSERT INTO teacher VALUES
	(1, 'Mike', 'Walters', '1987-04-10', 'Professor', '2014-07-02'),
	(2, 'Anna', 'Smith', '1990-09-02', 'Lecturer', '2016-08-09')

SELECT * FROM teacher

-- Course 
CREATE TABLE course (
	id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	credit SMALLINT,
	academic_year SMALLINT,
	semester SMALLINT
);

INSERT INTO course VALUES
	(1, 'Full Stack', 8, 2025, 2),
	(2, 'QA', 12, 2025, 1)

SELECT * FROM course

-- Grade
CREATE TABLE grade (
	id SERIAL PRIMARY KEY,
	student_id INTEGER REFERENCES student(id),
	course_id INTEGER REFERENCES course(id),
	teacher_id INTEGER REFERENCES teacher(id),
	grade VARCHAR(1),
	comment VARCHAR(200),
	created_date DATE
);

INSERT INTO grade VALUES
	(1, 1, 1, 1, 'A', 'Well done', '2024-12-10'),
	(2, 1, 2, 2, 'B', 'Great', '2024-12-12')

SELECT * FROM grade

-- Achievment type
CREATE TABLE achievment_type (
	id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	description VARCHAR(200),
	participation_rate VARCHAR(5)
);

INSERT INTO achievment_type VALUES
	(1, 'Advanced', null, '95%'),
	(2, 'Proficient', null, '90%')

SELECT * FROM achievment_type

-- Grade details
CREATE TABLE grade_details (
	id SERIAL PRIMARY KEY,
	grade_id INTEGER REFERENCES grade(id),
	ahievement_type_id INTEGER REFERENCES achievment_type(id),
	achievement_points SMALLINT,
	achievement_max_points SMALLINT,
	achievement_date DATE
);

INSERT INTO grade_details VALUES
	(1, 1, 1, 85, 100, '2024-12-10'),
	(2, 2, 2, 77, 100, '2024-12-12')

SELECT * FROM grade_details	