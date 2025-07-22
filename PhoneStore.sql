CREATE DATABASE IF NOT EXISTS PhoneStore;
USE PhoneStore;

-- BẢNG NGƯỜI DÙNG (gồm cả User và Admin)
CREATE TABLE Users (
  userId INT AUTO_INCREMENT PRIMARY KEY,                         -- Mã người dùng
  fullName VARCHAR(50) NOT NULL,                                 -- Họ và tên
  email VARCHAR(100) NOT NULL UNIQUE,                            -- Email (duy nhất)
  password VARCHAR(100) NOT NULL,                                -- Mật khẩu đã mã hóa
  phone VARCHAR(20),                                             -- Số điện thoại
  address VARCHAR(100) NOT NULL,                                 -- Địa chỉ
  role ENUM('Admin', 'User') NOT NULL DEFAULT 'User',            -- Vai trò người dùng
  isVerified BOOLEAN DEFAULT FALSE,                              -- Tài khoản đã xác minh hay chưa
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- Thời gian tạo tài khoản
  deletedAt DATETIME DEFAULT NULL                                -- Thời gian xóa mềm
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG THƯƠNG HIỆU
CREATE TABLE Brands (
  brandId INT AUTO_INCREMENT PRIMARY KEY,                        -- Mã thương hiệu
  brandName VARCHAR(100) NOT NULL                                -- Tên thương hiệu
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG DANH MỤC SẢN PHẨM
CREATE TABLE ProductCategories (
  categoryId INT AUTO_INCREMENT PRIMARY KEY,                     -- Mã danh mục
  categoryName VARCHAR(100) NOT NULL,                            -- Tên danh mục
  categoryDescription TEXT                                       -- Mô tả danh mục
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG SẢN PHẨM
CREATE TABLE Products (
  productId INT AUTO_INCREMENT PRIMARY KEY,                      -- Mã sản phẩm
  productName VARCHAR(100) NOT NULL,                             -- Tên sản phẩm
  productDescription TEXT,                                       -- Mô tả sản phẩm
  brandId INT NOT NULL,                                          -- Mã thương hiệu
  price DECIMAL(10,2) NOT NULL,                                  -- Giá gốc
  discountPrice DECIMAL(10,2) NOT NULL,                          -- Giá sau giảm
  image VARCHAR(255),                                            -- Đường dẫn ảnh
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- Ngày tạo
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP 
            ON UPDATE CURRENT_TIMESTAMP,                         -- Ngày cập nhật
  deletedAt DATETIME DEFAULT NULL,                               -- Thời gian xóa mềm
  categoryId INT NOT NULL,                                       -- Mã danh mục
  FOREIGN KEY (brandId) REFERENCES Brands(brandId),              -- Khóa ngoại thương hiệu
  FOREIGN KEY (categoryId) REFERENCES ProductCategories(categoryId) -- Khóa ngoại danh mục
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG ĐƠN HÀNG
CREATE TABLE Orders (
  orderId INT AUTO_INCREMENT PRIMARY KEY,                        -- Mã đơn hàng
  userId INT NOT NULL,                                           -- Mã người đặt
  totalAmount DECIMAL(10,2) NOT NULL,                            -- Tổng tiền
  orderStatus ENUM('Pending', 'Delivered', 'Completed', 'Canceled') DEFAULT 'Pending', -- Trạng thái
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- Ngày đặt hàng
  deletedAt DATETIME DEFAULT NULL,                               -- Thời gian xóa mềm
  FOREIGN KEY (userId) REFERENCES Users(userId)                  -- Khóa ngoại người đặt
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG CHI TIẾT ĐƠN HÀNG
CREATE TABLE OrderDetails (
  orderDetailId INT AUTO_INCREMENT PRIMARY KEY,                  -- Mã chi tiết
  orderId INT NOT NULL,                                          -- Mã đơn hàng
  variantId INT NOT NULL,                                       -- Mã biến thể sản phẩm
  quantity INT NOT NULL,                                         -- Số lượng mua
  price DECIMAL(10,2) NOT NULL,                                  -- Giá tại thời điểm mua
  FOREIGN KEY (orderId) REFERENCES Orders(orderId),              -- Khóa ngoại đơn hàng
  FOREIGN KEY (variantId) REFERENCES productVariants(variantId)  -- Khóa ngoại biến thể sản phẩm
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG ĐÁNH GIÁ SẢN PHẨM
CREATE TABLE ProductReviews (
  reviewId INT AUTO_INCREMENT PRIMARY KEY,                       -- Mã đánh giá
  productId INT NOT NULL,                                        -- Mã sản phẩm
  userId INT NOT NULL,                                           -- Mã người đánh giá
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),            -- Điểm đánh giá (1-5 sao)
  comment TEXT,                                                  -- Nội dung đánh giá
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- Ngày đánh giá
  FOREIGN KEY (productId) REFERENCES Products(productId),        -- Khóa ngoại sản phẩm
  FOREIGN KEY (userId) REFERENCES Users(userId)                  -- Khóa ngoại người dùng
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG KHUYẾN MÃI
CREATE TABLE Promotions (
  promotionId INT AUTO_INCREMENT PRIMARY KEY,                    -- Mã khuyến mãi
  productId INT NOT NULL,                                        -- Mã sản phẩm áp dụng
  discountPercent DECIMAL(5,2) CHECK (discountPercent BETWEEN 0 AND 100), -- Phần trăm giảm giá
  startDate DATE,                                                -- Ngày bắt đầu
  endDate DATE,                                                  -- Ngày kết thúc
  FOREIGN KEY (productId) REFERENCES Products(productId)         -- Khóa ngoại sản phẩm
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG THANH TOÁN
CREATE TABLE Payments (
  paymentId INT AUTO_INCREMENT PRIMARY KEY,                      -- Mã thanh toán
  orderId INT NOT NULL,                                          -- Mã đơn hàng
  paymentMethod ENUM('Bank Transfer', 'E-Wallet', 'Cash on Delivery') NOT NULL, -- Phương thức
  paymentStatus ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending', -- Trạng thái
  paymentDate DATE DEFAULT CURRENT_DATE,                         -- Ngày thanh toán
  FOREIGN KEY (orderId) REFERENCES Orders(orderId)               -- Khóa ngoại đơn hàng
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG GIỎ HÀNG
CREATE TABLE ShoppingCart (
  cartId INT AUTO_INCREMENT PRIMARY KEY,                         -- Mã giỏ hàng
  userId INT NOT NULL,                                           -- Mã người dùng
  productId INT NOT NULL,                                        -- Mã sản phẩm
  quantity INT NOT NULL,                                         -- Số lượng sản phẩm
  FOREIGN KEY (userId) REFERENCES Users(userId),                 -- Khóa ngoại người dùng
  FOREIGN KEY (productId) REFERENCES Products(productId)         -- Khóa ngoại sản phẩm
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG NHẬT KÝ HOẠT ĐỘNG
CREATE TABLE ActivityLogs (
  logId INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã nhật ký
  userId INT,                                                    -- Mã người thao tác
  action TEXT,                                                   -- Hành động thực hiện
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- Thời điểm thực hiện
  FOREIGN KEY (userId) REFERENCES Users(userId)                  -- Khóa ngoại người dùng
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG LỊCH SỬ TRẠNG THÁI ĐƠN HÀNG
CREATE TABLE OrderLogs (
  logId INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã log trạng thái
  orderId INT NOT NULL,                                          -- Mã đơn hàng
  status ENUM('Pending', 'Delivered', 'Completed', 'Canceled'), -- Trạng thái ghi lại
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- Thời điểm cập nhật
  FOREIGN KEY (orderId) REFERENCES Orders(orderId)               -- Khóa ngoại đơn hàng
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- BẢNG MÀU SẮC SẢN PHẨM
CREATE TABLE productColors (
  colorId INT AUTO_INCREMENT PRIMARY KEY,  -- Mã màu (tự tăng, khóa chính)
  colorName VARCHAR(50) NOT NULL           -- Tên màu (không được để trống)
);

-- BẢNG BIẾN THỂ SẢN PHẨM
CREATE TABLE productVariants (
  variantId INT AUTO_INCREMENT PRIMARY KEY,       -- Mã biến thể (khóa chính, tự tăng)
  productId INT,                                  -- Mã sản phẩm (khóa ngoại)
  colorId INT,                                    -- Mã màu (khóa ngoại)
  size VARCHAR(50),                               -- Kích thước sản phẩm
  price DECIMAL(10,2) NOT NULL,                   -- Giá sản phẩm (không được để trống)
  stock INT DEFAULT 0,                            -- Số lượng tồn kho (mặc định là 0)
  image VARCHAR(255),                             -- Đường dẫn hình ảnh sản phẩm
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,   -- Ngày tạo biến thể (mặc định là thời điểm hiện tại)
  FOREIGN KEY (productId) REFERENCES Products(productId),      -- Liên kết với bảng Products
  FOREIGN KEY (colorId) REFERENCES productColors(colorId)      -- Liên kết với bảng productColors
); 

ALTER TABLE users 
ADD image VARCHAR(255)
AFTER phone;

ALTER TABLE products 
ADD quantity int(11)
AFTER image;

ALTER TABLE brands
ADD brandDescription text

 
