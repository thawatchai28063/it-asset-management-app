CREATE DATABASE IF NOT EXISTS it_asset_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE it_asset_management;

DROP TABLE IF EXISTS maintenance_logs;
DROP TABLE IF EXISTS assets;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin', 'staff') NOT NULL DEFAULT 'staff',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE assets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  asset_name VARCHAR(160) NOT NULL,
  asset_type VARCHAR(80) NOT NULL,
  it_tag VARCHAR(80) NULL UNIQUE,
  employee_no VARCHAR(80) NULL,
  description VARCHAR(160) NULL,
  os_version VARCHAR(160) NULL,
  brand VARCHAR(120) NULL,
  model VARCHAR(200) NULL,
  serial_number VARCHAR(120) NOT NULL UNIQUE,
  ip_address VARCHAR(45) NULL,
  department VARCHAR(120) NOT NULL,
  status ENUM('available', 'in_use', 'repair', 'retired') NOT NULL DEFAULT 'available',
  assigned_user VARCHAR(120) NULL,
  position VARCHAR(120) NULL,
  point_image VARCHAR(160) NULL,
  check_date DATE NULL,
  receipt_of_device DATE NULL,
  invoice_no VARCHAR(120) NULL,
  date2 DATE NULL,
  vendor VARCHAR(200) NULL,
  checker_2025_03_31 VARCHAR(120) NULL,
  check_result_2025_03_31 VARCHAR(120) NULL,
  checker_2025_04_23 VARCHAR(120) NULL,
  checker_2025_05_30 VARCHAR(120) NULL,
  check_result_2025_04_30 VARCHAR(120) NULL,
  purchase_date DATE NULL,
  note TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE maintenance_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  asset_id INT NOT NULL,
  problem TEXT NOT NULL,
  solution TEXT NULL,
  repair_by VARCHAR(120) NOT NULL,
  repair_date DATE NOT NULL,
  status ENUM('pending', 'in_progress', 'completed') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_maintenance_asset
    FOREIGN KEY (asset_id) REFERENCES assets(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO users (name, email, password, role) VALUES
('System Admin', 'admin@example.com', '$2y$10$LreNroZm1TTljFcf3Gj4VOkniWe4kBhbV/Kv3rgyXh84BiviB/ICi', 'admin'),
('IT Staff', 'staff@example.com', '$2y$10$LreNroZm1TTljFcf3Gj4VOkniWe4kBhbV/Kv3rgyXh84BiviB/ICi', 'staff');

INSERT INTO assets
(asset_name, asset_type, it_tag, serial_number, ip_address, department, status, assigned_user, position, purchase_date, note)
VALUES
('Dell Latitude 5440', 'Laptop', 'IT250001', 'DL-5440-001', '192.168.1.21', 'IT', 'in_use', 'Somchai', 'IT Office', '2024-01-15', 'Primary admin laptop'),
('HP ProBook 450', 'Laptop', 'IT250002', 'HP-450-002', '192.168.1.22', 'HR', 'in_use', 'Suda', 'HR Office', '2023-11-02', 'HR payroll user'),
('Lenovo ThinkCentre M70q', 'Desktop', 'IT250003', 'LN-M70-003', '192.168.1.40', 'Finance', 'available', NULL, 'Finance Counter', '2024-03-09', 'Spare mini PC'),
('Canon LBP 2900', 'Printer', 'IT250004', 'CN-2900-004', '192.168.1.60', 'Admin', 'repair', 'Office Admin', 'Admin Room', '2022-08-20', 'Paper jam issue'),
('Cisco SG350 Switch', 'Network', 'IT250005', 'CS-SG350-005', '192.168.1.2', 'IT', 'in_use', 'Network Rack', 'Server Rack A', '2021-05-12', 'Core switch'),
('Ubiquiti UAP AC Pro', 'Access Point', 'IT250006', 'UB-ACPRO-006', '192.168.1.10', 'IT', 'in_use', 'Floor 1', 'Lobby Ceiling', '2023-04-18', 'Lobby wireless'),
('Samsung 24 Monitor', 'Monitor', 'IT250007', 'SS-MON-007', NULL, 'Sales', 'available', NULL, 'Sales Desk 2', '2023-12-01', 'Spare monitor'),
('Synology DS920+', 'Storage', 'IT250008', 'SY-DS920-008', '192.168.1.80', 'IT', 'in_use', 'Server Room', 'Server Room', '2022-02-11', 'Backup NAS'),
('iPad Air', 'Tablet', 'IT250009', 'IP-AIR-009', NULL, 'Marketing', 'retired', 'Marketing Team', 'Marketing Cabinet', '2020-09-10', 'Battery degraded'),
('Brother ADS Scanner', 'Scanner', 'IT250010', 'BR-ADS-010', '192.168.1.70', 'Accounting', 'in_use', 'Accounting Desk', 'Accounting Desk 1', '2023-06-05', 'Invoice scanning');

INSERT INTO maintenance_logs
(asset_id, problem, solution, repair_by, repair_date, status)
VALUES
(4, 'Paper jam and roller noise', 'Cleaned roller, ordered replacement feed kit', 'Niran', '2026-05-01', 'in_progress'),
(1, 'Battery drains quickly', 'Battery health checked and power settings adjusted', 'Niran', '2026-04-20', 'completed'),
(8, 'Backup job warning', 'Updated package and restarted backup service', 'Kanda', '2026-04-15', 'completed'),
(9, 'Battery degraded', 'Marked as retired for replacement planning', 'IT Team', '2026-03-22', 'completed');
