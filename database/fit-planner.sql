-- ============================================
-- Health Planner 데이터베이스 스키마
-- ============================================

-- 1. 회원 테이블
CREATE TABLE member (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255),
    oauth_provider VARCHAR(50),           -- 'local', 'google', 'naver', 'kakao'
    oauth_id VARCHAR(255),
    height DOUBLE NOT NULL,               -- 키 (cm)
    weight DOUBLE NOT NULL,               -- 현재 몸무게 (kg)
    goal VARCHAR(50),                     -- 목표 ('diet', 'muscle', 'maintain')
    daily_calorie_goal INT,               -- 일일 목표 칼로리
    gender VARCHAR(10),                   -- 'M' or 'F'
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_oauth (oauth_provider, oauth_id)
);

-- 2. 식품 정보 테이블 (식품의약품안전처 API에서 가져온 데이터)
CREATE TABLE food (
    id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(200) NOT NULL,
    food_code VARCHAR(50),                -- 식품 코드
    serving_size DOUBLE,                  -- 1회 제공량 (g)
    calorie DOUBLE NOT NULL,              -- 칼로리 (kcal)
    protein DOUBLE,                       -- 단백질 (g)
    carbs DOUBLE,                         -- 탄수화물 (g)
    fat DOUBLE,                           -- 지방 (g)
    dietary_fiber DOUBLE,                 -- 식이섬유 (g)
    sugar DOUBLE,                         -- 당류 (g)
    sodium DOUBLE,                        -- 나트륨 (mg)
    source VARCHAR(100),                  -- 출처
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_food_code (food_code)
);

-- 3. 식단 기록 테이블
CREATE TABLE meal_record (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    meal_date DATE NOT NULL,
    meal_type VARCHAR(20),                -- 'breakfast', 'lunch', 'dinner', 'snack'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE,
    KEY idx_member_date (member_id, meal_date)
);

-- 4. 식단 상세 항목 테이블
CREATE TABLE meal_detail (
    id INT PRIMARY KEY AUTO_INCREMENT,
    meal_record_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity DOUBLE NOT NULL,            -- 섭취량 (g 또는 회)
    calories DOUBLE,                      -- 섭취한 칼로리
    protein DOUBLE,
    carbs DOUBLE,
    fat DOUBLE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (meal_record_id) REFERENCES meal_record(id) ON DELETE CASCADE,
    FOREIGN KEY (food_id) REFERENCES food(id)
);

-- 5. 일일 영양소 목표 테이블
CREATE TABLE daily_nutrition_goal (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL UNIQUE,
    target_calorie INT,                   -- 목표 칼로리
    target_protein INT,                   -- 목표 단백질 (g)
    target_carbs INT,                     -- 목표 탄수화물 (g)
    target_fat INT,                       -- 목표 지방 (g)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE
);

-- 6. 일일 영양소 섭취 현황 테이블
CREATE TABLE daily_nutrition_intake (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    intake_date DATE NOT NULL,
    total_calorie DOUBLE DEFAULT 0,
    total_protein DOUBLE DEFAULT 0,
    total_carbs DOUBLE DEFAULT 0,
    total_fat DOUBLE DEFAULT 0,
    total_fiber DOUBLE DEFAULT 0,
    total_sodium DOUBLE DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE,
    UNIQUE KEY unique_member_date (member_id, intake_date),
    KEY idx_member_date (member_id, intake_date)
);

-- 인덱스 추가 (성능 최적화)
CREATE INDEX idx_meal_record_member ON meal_record(member_id);
CREATE INDEX idx_meal_detail_meal ON meal_detail(meal_record_id);
CREATE INDEX idx_daily_intake_member ON daily_nutrition_intake(member_id);