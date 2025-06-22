CREATE DATABASE PhoneStore;
USE PhoneStore;
-- Bảng thông tin người dùng
CREATE TABLE Users ( 
  userId INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã người dùng
  fullName VARCHAR(50) NOT NULL,                                  -- Họ và tên
  email VARCHAR(100) NOT NULL UNIQUE,                             -- Email
  password VARCHAR(50) NOT NULL,                                  -- Mật khẩu
  address VARCHAR(50) NOT NULL,                                   -- Địa chỉ
  role VARCHAR(50) NOT NULL DEFAULT 'User'                        -- Vai trò (User hoặc Admin)
    CHECK (role IN ('Admin', 'User')),
  createdAt DATETIME DEFAULT NOW()                                -- Ngày tạo tài khoản
);
-- Bảng danh mục sản phẩm
CREATE TABLE ProductCategories ( 
  categoryId INT AUTO_INCREMENT PRIMARY KEY,                      -- Mã danh mục
  categoryName VARCHAR(100) NOT NULL,                             -- Tên danh mục
  categoryDescription TEXT                                        -- Mô tả danh mục
);
-- Bảng thông tin sản phẩm
CREATE TABLE Products ( 
  productId INT AUTO_INCREMENT PRIMARY KEY,                       -- Mã sản phẩm
  productName VARCHAR(50) NOT NULL,                               -- Tên sản phẩm
  productDescription TEXT,                                        -- Mô tả sản phẩm
  brand VARCHAR(50) NOT NULL,                                     -- Thương hiệu
  price DECIMAL(10,2) NOT NULL,                                   -- Giá gốc
  discountPrice DECIMAL(10,2) NOT NULL,                           -- Giá sau giảm
  image VARCHAR(255),                                             -- Ảnh sản phẩm
  createdAt DATETIME DEFAULT NOW(),                               -- Ngày tạo
  categoryId INT NOT NULL,                                        -- Mã danh mục
  updatedAt DATETIME DEFAULT NOW(),                               -- Ngày cập nhật
  FOREIGN KEY (categoryId) REFERENCES ProductCategories(categoryId) -- Ràng buộc danh mục
);
-- Bảng đơn hàng
CREATE TABLE Orders ( 
  orderId INT AUTO_INCREMENT PRIMARY KEY,                         -- Mã đơn hàng
  userId INT NOT NULL,                                            -- Mã người đặt
  totalAmount DECIMAL(10,2) NOT NULL,                             -- Tổng tiền
  orderStatus VARCHAR(50) DEFAULT 'Pending' CHECK (orderStatus IN ('Pending', 'Delivered', 'Completed', 'Canceled')), -- Trạng thái đơn hàng('Đang chờ', 'Đã giao', 'Đã hoàn thành', 'Đã hủy')
  createdAt DATETIME DEFAULT NOW(),                               -- Ngày tạo đơn
  FOREIGN KEY (userId) REFERENCES Users(userId)                   -- Khóa ngoại người dùng
);
-- Bảng chi tiết đơn hàng
CREATE TABLE OrderDetails ( 
  orderDetailId INT AUTO_INCREMENT PRIMARY KEY,                   -- Mã chi tiết đơn
  orderId INT NOT NULL,                                           -- Mã đơn hàng
  productId INT NOT NULL,                                         -- Mã sản phẩm
  quantity DECIMAL(10,2) NOT NULL,                                -- Số lượng mua
  price DECIMAL(10,2) NOT NULL,                                   -- Giá tại thời điểm mua
  FOREIGN KEY (orderId) REFERENCES Orders(orderId),               -- Khóa ngoại đơn hàng
  FOREIGN KEY (productId) REFERENCES Products(productId)          -- Khóa ngoại sản phẩm
);
-- Bảng đánh giá sản phẩm
CREATE TABLE ProductReviews ( 
  reviewId INT AUTO_INCREMENT PRIMARY KEY,                        -- Mã đánh giá
  productId INT NOT NULL,                                         -- Mã sản phẩm
  userId INT NOT NULL,                                            -- Mã người dùng đánh giá
  rating INT CHECK (rating >= 1 AND rating <= 5),                 -- Điểm (1-5 sao)
  comment TEXT,                                                   -- Bình luận
  FOREIGN KEY (productId) REFERENCES Products(productId),         -- Khóa ngoại sản phẩm
  FOREIGN KEY (userId) REFERENCES Users(userId)                   -- Khóa ngoại người dùng
);
-- Bảng khuyến mãi
CREATE TABLE Promotions ( 
  promotionId INT AUTO_INCREMENT PRIMARY KEY,                     -- Mã khuyến mãi
  productId INT NOT NULL,                                         -- Mã sản phẩm áp dụng
  discountPercent DECIMAL(5,2) CHECK (discountPercent BETWEEN 0 AND 100), -- Phần trăm giảm
  startDate DATE,                                                 -- Ngày bắt đầu
  endDate DATE,                                                   -- Ngày kết thúc
  FOREIGN KEY (productId) REFERENCES Products(productId)          -- Khóa ngoại sản phẩm
);
-- Bảng thanh toán
CREATE TABLE Payments ( 
  paymentId INT AUTO_INCREMENT PRIMARY KEY,                       -- Mã thanh toán
  orderId INT NOT NULL,                                           -- Mã đơn hàng
  paymentMethod VARCHAR(50) NOT NULL                              -- Phương thức
    CHECK (paymentMethod IN ('Bank Transfer', 'E-Wallet', 'Cash on Delivery')),
  paymentStatus VARCHAR(50) DEFAULT 'Pending'                     -- Trạng thái thanh toán
    CHECK (paymentStatus IN ('Pending', 'Completed', 'Failed')),
  paymentDate DATE DEFAULT NOW(),                                 -- Ngày thanh toán
  FOREIGN KEY (orderId) REFERENCES Orders(orderId)                -- Khóa ngoại đơn hàng
);
-- Bảng giỏ hàng tạm thời
CREATE TABLE ShoppingCart ( 
  cartId INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã giỏ hàng
  userId INT NOT NULL,                                            -- Mã người dùng
  productId INT NOT NULL,                                         -- Mã sản phẩm
  quantity INT NOT NULL,                                          -- Số lượng sản phẩm
  FOREIGN KEY (userId) REFERENCES Users(userId),                  -- Khóa ngoại người dùng
  FOREIGN KEY (productId) REFERENCES Products(productId)          -- Khóa ngoại sản phẩm
);
