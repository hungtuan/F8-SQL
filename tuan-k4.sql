-- Tạo bảng courses 

CREATE TABLE IF NOT EXISTS courses
(
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    price money,
    detail text,
    teacher_id integer NOT NULL,
    active integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT courses_id_primary_key PRIMARY KEY (id),
    CONSTRAINT courses_name_unique UNIQUE (name),
    CONSTRAINT courses_price_unique UNIQUE (price)
);

-- Thêm trường description kiểu text, nulll

ALTER TABLE IF EXISTS courses
ADD description text DEFAULT NULL;

-- Đổi tên trường detail thành content và ràng buộc chuyển thành NOT NULL

ALTER TABLE IF EXISTS courses
RENAME detail TO content;

ALTER TABLE IF EXISTS courses
ALTER COLUMN content SET NOT NULL;

-- Tạo bảng teacher

CREATE TABLE IF NOT EXISTS teacher
(
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    bio text DEFAULT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT teacher_id_primary_key PRIMARY KEY (id),
    CONSTRAINT teacher_bio_unique UNIQUE (bio)
);

ALTER TABLE IF EXISTS courses
ADD CONSTRAINT courses_teacher_id_foreign_key FOREIGN KEY (teacher_id)
REFERENCES teacher (id);

-- Thêm 3 giảng viên vào bảng teacher, mỗi giảng viên thêm 3 khóa học

INSERT INTO teacher(id, name, bio)
	VALUES
		(1,'Giảng viên 1', 'Bio version 1'),
		(2,'Giảng viên 2', 'Bio version 1'),
		(3,'Giảng viên 3', 'Bio version 1');

INSERT INTO courses(id, name, price, content, teacher_id, active, description)
	VALUES
		(1,'Khóa học 1 version 1', 100, 'Content khóa học 1', 1, 1, 'Description khóa học 1'),
		(2,'Khóa học 2 version 1', 200, 'Content khóa học 2', 1, 1, 'Description khóa học 2'),
		(3,'Khóa học 3 version 1', 300, 'Content khóa học 3', 2, 1, 'Description khóa học 3'),
		(4,'Khóa học 4 version 1', 400, 'Content khóa học 4', 2, 1, 'Description khóa học 4'),
		(5,'Khóa học 5 version 1', 500, 'Content khóa học 5', 3, 1, 'Description khóa học 5'),
		(6,'Khóa học 6 version 1', 600, 'Content khóa học 6', 3, 1, 'Description khóa học 6'),
		

-- Sửa tên và giá từng khóa học thành tên mới và giá mới (Tên khóa học,giá khóa học các khóa học không được giống nhau)

UPDATE courses
SET name = 'Khóa học 1 version 2', price = 1000, updated_at = NOW()
WHERE id = 1;

UPDATE courses
SET name = 'Khóa học 2 version 2', price = 2000, updated_at = NOW()
WHERE id = 2;

UPDATE courses
SET name = 'Khóa học 3 version 2', price = 3000, updated_at = NOW()
WHERE id = 3;

UPDATE courses
SET name = 'Khóa học 4 version 2', price = 4000, updated_at = NOW()
WHERE id = 4;

UPDATE courses
SET name = 'Khóa học 5 version 2', price = 5000, updated_at = NOW()
WHERE id = 5;

UPDATE courses
SET name = 'Khóa học 6 version 2', price = 6000, updated_at = NOW()
WHERE id = 6;

-- Sửa lại bio của từng giảng viên (Bio từng giảng viên không được giống nhau)

UPDATE teacher
SET bio = 'Bio version 2', updated_at = NOW()
WHERE id = 1;

UPDATE teacher
SET bio = 'Bio version 2', updated_at = NOW()
WHERE id = 2;

UPDATE teacher
SET bio = 'Bio version 2', updated_at = NOW()
WHERE id = 3;

-- Hiển thị danh sách giảng viên, danh sách khóa học
SELECT * FROM courses;
SELECT * FROM teacher;