--------------------------------------------------------------- Customer -------------------------------------------------------------------------
CREATE TABLE [dbo].[Customer] (
	[id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	[firstName] VARCHAR (100) NOT NULL,
	[lastName] VARCHAR (100) NOT NULL,
	[phoneNumber] VARCHAR (13) NOT NULL,
	[birthDate] DATE NOT NULL CHECK (birthDate < GETDATE()),
	[citizenship] VARCHAR (4) NOT NULL CHECK (citizenship IN ('SG','PR','OT')),
	[email] VARCHAR (100) NOT NULL UNIQUE,
	[password] NVARCHAR(MAX) NOT NULL,
	[emailVerified] BIT NOT NULL DEFAULT 0 CHECK (emailVerified IN (0,1))
)
-- Create a customer account
GO
CREATE PROCEDURE [dbo].[insertCustomer]
	@firstName VARCHAR (95),
	@lastName VARCHAR (95),
	@phoneNumber VARCHAR (13),
	@birthDate DATE,
	@citizenship VARCHAR (3),
	@email VARCHAR (95),
	@password NVARCHAR(MAX)
AS
	INSERT INTO dbo.Customer(firstName,lastName,phoneNumber,birthDate,citizenship,email,password) VALUES (@firstName,@lastName,@phoneNumber,@birthDate,@citizenship,@email,@password);
GO
-- Select all customer accounts
CREATE PROCEDURE [dbo].[selectAllCustomer]
AS
	SET NOCOUNT ON;
	SELECT CONCAT(firstName,' ',lastName), phoneNumber, birthDate, citizenship,email FROM dbo.Customer;
GO
-- Select one customer account
CREATE PROCEDURE [dbo].[selectOneCustomer]
	@id UNIQUEIDENTIFIER 
AS
	SET NOCOUNT ON;
	SELECT TOP 1 id, CONCAT(firstName,' ',lastName) AS fullName, phoneNumber, birthDate, citizenship, email, emailVerified FROM dbo.Customer WHERE id = @id;
GO
-- For customer login purpose
CREATE PROCEDURE [dbo].[verifyCustomer]
	@email VARCHAR (95)
AS
	SET NOCOUNT ON;
	SELECT TOP 1 id,password, emailVerified FROM dbo.Customer WHERE email = @email;
GO
-- Update customer informations
CREATE PROCEDURE [dbo].[updateCustomerInfo]
	@id UNIQUEIDENTIFIER,
	@firstName VARCHAR (95),
	@lastName VARCHAR (95),
	@phoneNumber VARCHAR (13),
	@birthDate DATE,
	@citizenship VARCHAR (3),
	@email VARCHAR (95)
AS
	UPDATE dbo.Customer SET 
	firstName = @firstName,
	lastName= @lastName,
	phoneNumber = @phoneNumber,
	birthDate = @birthDate,
	Citizenship = @citizenship,
	email = @email
	WHERE id = @id;
GO
-- Update customer password
CREATE PROCEDURE [dbo].[updateCustomerPW]
	@id UNIQUEIDENTIFIER,
	@password NVARCHAR (MAX),
	@result INT OUTPUT
AS
	UPDATE dbo.Customer SET 
	password = @password
	WHERE id = @id;
GO
-- Update customer email is validated
CREATE PROCEDURE [dbo].[updateCustomerValidated] 
	@id UNIQUEIDENTIFIER, 
	@emailVerified BIT
AS
	UPDATE dbo.Customer SET emailVerified = @emailVerified WHERE id = @id;
GO
-- Delete customer account
CREATE PROCEDURE [dbo].[deleteCustomer]
	@id UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Customer WHERE id=@id;
GO

--------------------------------------------------------------- Admin -------------------------------------------------------------------------
CREATE TABLE [dbo].[Admin] (
	[id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	[username] VARCHAR (100) NOT NULL,
	[password] NVARCHAR (MAX) NOT NULL,
	[role] VARCHAR (100) NOT NULL
)
GO
-- Create an admin account
CREATE PROCEDURE [dbo].[insertAdmin]
	@username VARCHAR (95),
	@password NVARCHAR (MAX),
	@role VARCHAR (95)
AS
	INSERT INTO dbo.Admin (username,password,role) VALUES (@username,@password,@role);
GO
-- Select all admin accounts
CREATE PROCEDURE [dbo].[selectAllAdmin]
AS
	SET NOCOUNT ON;
	SELECT id, username, role FROM dbo.Admin;
GO
-- Select an admin account
CREATE PROCEDURE [dbo].[selectOneAdmin]
	@id UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT TOP 1 id, username, role FROM dbo.Admin WHERE id = @id;
GO
-- For admin login purpose only
CREATE PROCEDURE [dbo].[verifyAdmin]
	@username VARCHAR (100)
AS
	SET NOCOUNT ON;
	SELECT TOP 1 id, password FROM dbo.Admin WHERE username = @username;
GO
-- Update admin information
CREATE PROCEDURE [dbo].[updateAdminInfo]
	@id UNIQUEIDENTIFIER,
	@username VARCHAR (95),
	@password NVARCHAR (MAX)
AS
	UPDATE dbo.Admin SET
	username = @username,
	password = @password
	WHERE id = @id;
GO
-- Update admin password and role
CREATE PROCEDURE [dbo].[updateAdminPW]
	@id UNIQUEIDENTIFIER,
	@password NVARCHAR (MAX),
	@role VARCHAR (95)
AS
	UPDATE dbo.Admin SET
	password = @password,
	role = @role
	WHERE id = @id;
GO

-- Delete an admin account
CREATE PROCEDURE [dbo].[deleteAdmin]
	@id UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Admin WHERE id = @id;
GO

--------------------------------------------------------------- Business -------------------------------------------------------------------------
CREATE TABLE [dbo].[Business] (
	[id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	[name] VARCHAR (200) NOT NULL,
	[type] VARCHAR (50) NOT NULL,
	[email] VARCHAR (100) NOT NULL,
	[logoId] UNIQUEIDENTIFIER NOT NULL,
	[acraCertificate] VARCHAR (100) NOT NULL,
	[password] NVARCHAR(MAX) NOT NULL,
	[verified] BIT NOT NULL DEFAULT 0 CHECK (verified IN (0,1)), 
	[customerId] UNIQUEIDENTIFIER UNIQUE,
	[adminId] UNIQUEIDENTIFIER,
	CONSTRAINT baBusinessFK FOREIGN KEY (customerId) REFERENCES dbo.Customer(id),
	CONSTRAINT bbBusinessFK FOREIGN KEY (adminId) REFERENCES dbo.Admin(id)
)
GO
-- Create a business account
CREATE PROCEDURE [dbo].[insertBusiness]
	@name VARCHAR (195),
	@type VARCHAR (45),
	@email VARCHAR (95),
	@logoId UNIQUEIDENTIFIER,
	@acraCertificate VARCHAR (95),
	@password NVARCHAR(MAX),
	@customerId UNIQUEIDENTIFIER
AS
	INSERT INTO dbo.Business (name, type, email, logoId, acraCertificate, password, customerId) VALUES (@name, @type, @email, @logoId, @acraCertificate, @password, @customerId);
GO
-- Select all business account
CREATE PROCEDURE [dbo].[selectAllBusiness]
AS
	SET NOCOUNT ON;
	SELECT name, type, email, logoId, acraCertificate, password, verified FROM dbo.Business;
GO
-- Select a business account
CREATE PROCEDURE [dbo].[selectOneBusiness]
	@id UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT TOP 1 name,type,email,logoId,acraCertificate, verified FROM dbo.Business;
GO
-- For business login purpose only
CREATE PROCEDURE [dbo].[verifyBusiness]
	@customerId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT id, password, verified FROM dbo.Business;
GO
-- Update business information
CREATE PROCEDURE [dbo].[updateBusinessInfo]
	@id UNIQUEIDENTIFIER,
	@name VARCHAR (195),
	@type VARCHAR (45),
	@email VARCHAR (95),
	@logoId UNIQUEIDENTIFIER,
	@acraCertificate VARCHAR (95),
	@customerId UNIQUEIDENTIFIER
AS
	UPDATE dbo.Business SET
	name = @name,
	type = @type,
	email = @email,
	logoId = @logoId,
	acraCertificate = @acraCertificate,
	customerId = @customerId
	WHERE id = @id AND customerId = @customerId
GO
-- Update business password
CREATE PROCEDURE [dbo].[updateBusinessPW]
	@id UNIQUEIDENTIFIER,
	@password NVARCHAR (MAX),
	@customerId UNIQUEIDENTIFIER
AS
	UPDATE dbo.Business SET
	password = @password
	WHERE id = @id AND customerId = @customerId
GO
-- Update business validated
CREATE PROCEDURE [dbo].[updateBusinessVerified]
	@id UNIQUEIDENTIFIER, 
	@verified BIT
AS
	UPDATE dbo.Business SET verified = @verified WHERE id = @id;
GO
-- Delete an business account
CREATE PROCEDURE [dbo].[deleteBusiness]
	@customerId UNIQUEIDENTIFIER,
	@id UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.Business WHERE customerId = @customerId AND id = @id;
GO

--------------------------------------------------------------- Staff -------------------------------------------------------------------------
CREATE TABLE [dbo].[Staff] (
	[id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	[firstName] VARCHAR (100) NOT NULL,
	[lastName] VARCHAR (100) NOT NULL,
	[photoId] UNIQUEIDENTIFIER NOT NULL,
	[role] VARCHAR (100) NULL,
	[email] VARCHAR (100) NOT NULL, 
	[password] NVARCHAR (MAX) NOT NULL,
	[mainStaff] BIT NOT NULL DEFAULT 0 CHECK (mainStaff IN (0,1)),
	[branchId] UNIQUEIDENTIFIER UNIQUE,
	CONSTRAINT saStaffFK FOREIGN KEY (branchId) REFERENCES dbo.Branch(id)
)
GO

-- Create a staff account
CREATE PROCEDURE [dbo].[insertStaff] 
	@firstName VARCHAR (95),
	@lastName VARCHAR (95),
	@photoId UNIQUEIDENTIFIER, 
	@role VARCHAR (95),
	@email VARCHAR (100),
	@password NVARCHAR (MAX), 
	@mainStaff BIT, 
	@branchId UNIQUEIDENTIFIER
AS
	INSERT INTO dbo.Staff (firstName, lastName, photoId, role, email, password, mainStaff, branchId) VALUES (@firstName, @lastName, @photoId, @role, @email, @password, @mainStaff, @branchId) ;
GO
-- Select all staff account
CREATE PROCEDURE [dbo].[selectAllStaff]
AS
	SET NOCOUNT ON;
	SELECT CONCAT(firstName, " ", lastName) AS fullName, photoId, role, email, mainStaff, branchId FROM dbo.Staff;
GO
-- Select a staff account
CREATE PROCEDURE [dbo].[selectAStaff]
	@id UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT TOP 1 CONCAT(firstName, " ", lastName) AS fullName, photoId, role, email, mainStaff, branchId FROM dbo.Staff WHERE id = @id;
GO
-- Update staff information
CREATE PROCEDURE [dbo].[updateStaffInfo]
	@id UNIQUEIDENTIFIER,
	@firstName VARCHAR (95),
	@lastName VARCHAR (95),
	@photoId UNIQUEIDENTIFIER, 
	@email VARCHAR (100),
	@mainStaff BIT, 
	@branchId UNIQUEIDENTIFIER,
	@password NVARCHAR (MAX)
AS
	UPDATE dbo.Staff SET 
	firstName = @firstName, 
	lastName = @lastName, 
	photoId = @photoId, 
	email = @email, 
	password = @password, 
	mainStaff = @mainStaff, 
	branchId = @branchId
	WHERE id = @id
GO	
-- Update staff password and role
CREATE PROCEDURE [dbo].[updateStaffPW]
	@id UNIQUEIDENTIFIER,
	@role VARCHAR (95),
	@password NVARCHAR (MAX)
AS
	UPDATE dbo.Staff SET 
	role= @role, 
	password= @password
	WHERE id = @id
GO
-- Delete staff
CREATE PROCEDURE [dbo].[deleteStaff]
	@id UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Staff WHERE id = @id;
GO

--------------------------------------------------------------- Branch -------------------------------------------------------------------------
CREATE TABLE [dbo].[Branch] (
	[id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	[shopName] VARCHAR (100) NOT NULL, 
	[phoneNumber] VARCHAR (15) NOT NULL,
	[email] VARCHAR (100) NOT NULL,
	[description] VARCHAR (2000) NOT NULL,
	[branchLocation] VARCHAR (50) NOT NULL,
	[branchAddress] VARCHAR (200) NOT NULL,
	[mainBranch] BIT NOT NULL DEFAULT 0 CHECK (mainBranch IN (0,1)),
	[businessId] UNIQUEIDENTIFIER,
	CONSTRAINT baBranchFK FOREIGN KEY (businessId) REFERENCES dbo.Business(id)
)
GO
-- Create a branch account
	CREATE PROCEDURE [dbo].[insertBranch]
	@shopName VARCHAR (95), 
	@phoneNumber VARCHAR (14),
	@email VARCHAR (95),
	@description varchar (1995),
	@branchLocation VARCHAR (49),
	@branchAddress VARCHAR (195),
	@businessId UNIQUEIDENTIFIER
AS
	INSERT INTO dbo.Branch (shopName, phoneNumber, email, description, branchLocation, branchAddress, businessId) VALUES (@shopName, @phoneNumber, @email, @description, @branchLocation, @branchAddress, @businessId)
GO
-- Select all branch account
CREATE PROCEDURE [dbo].[selectAllBranch]
AS
	SET NOCOUNT ON;
	SELECT id, shopName, phoneNumber, email, description, branchLocation, branchAddress FROM dbo.Branch;
GO
-- Select a branch account
CREATE PROCEDURE [dbo].[selectOneBranch]
AS
	SET NOCOUNT ON;
	SELECT TOP 1 id, shopName, phoneNumber, email, description, branchLocation, branchAddress FROM dbo.Branch;
GO
-- Select all branch account with businessId
CREATE PROCEDURE [dbo].[selectAllBranchWithId]
	@businessId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT id, shopName, phoneNumber, email, description, branchLocation, branchAddress FROM dbo.Branch WHERE businessId = @businessId;
GO
-- Select a branch account with businessId and branchId
CREATE PROCEDURE [dbo].[selectOneBranchWithId]
	@id UNIQUEIDENTIFIER,
	@businessId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT TOP 1 id, shopName, phoneNumber, email, description, branchLocation, branchAddress FROM dbo.Branch WHERE businessId = @businessId AND id = @id;
GO
-- Update a branch information
CREATE PROCEDURE [dbo].[updateBranchInfo]
	@id UNIQUEIDENTIFIER,
	@shopName VARCHAR (95), 
	@phoneNumber VARCHAR (14),
	@email VARCHAR (95),
	@description varchar (1995),
	@branchLocation VARCHAR (49),
	@branchAddress VARCHAR (195),
	@businessId UNIQUEIDENTIFIER
AS
	UPDATE dbo.Branch SET 
	shopName = @shopName, 
	phoneNumber = @phoneNumber,
	email = @email,
	description = @description,
	branchLocation = @branchLocation,
	branchAddress = @branchAddress,
	businessId = @businessId
	WHERE id = @id AND businessId = @businessId
GO
-- Delete a branch account
CREATE PROCEDURE [dbo].[deleteBranch]
	@id UNIQUEIDENTIFIER,
	@businessId UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Branch WHERE id = @id AND businessId = @businessId;
GO
	
	

--------------------------------------------------------------- BranchPhoto -------------------------------------------------------------------------
CREATE TABLE [dbo].[BranchPhoto] (
	[photoId] VARCHAR (100) PRIMARY KEY, -- IDENTITY (1,1),
	[photoName] UNIQUEIDENTIFIER UNIQUE,
	[createdDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[branchId] UNIQUEIDENTIFIER NOT NULL,
	CONSTRAINT bpaBranchPhotoFK FOREIGN KEY (branchId) REFERENCES dbo.Branch(id)
)

GO
-- Insert branch photo
CREATE PROCEDURE [dbo].[insertBranchPhoto]
	@photoName UNIQUEIDENTIFIER,
	@branchId UNIQUEIDENTIFIER
AS
	INSERT INTO dbo.BranchPhoto (photoName, branchId) VALUES (@photoName, @branchId);
GO
-- Select all branch photos
CREATE PROCEDURE [dbo].[selectAllBranchPhoto]
	@branchId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT photoName, createdDate, branchId FROM dbo.BranchPhoto WHERE branchId = @branchId ORDER BY createdDate DESC;
GO
-- Delete a branch photo
CREATE PROCEDURE [dbo].[deleteBranchPhoto]
	@branchId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.BranchPhoto WHERE branchId= @branchId;
GO

--------------------------------------------------------------- Review -------------------------------------------------------------------------
CREATE TABLE [dbo].[Review] (	
	[id] int PRIMARY KEY IDENTITY(1,1),
	[rating] DECIMAL(5) NOT NULL, 
	[comment] VARCHAR (1000) NOT NULL,
	[dateCreated] DATETIME NOT NULL,
	[reviewCount] INT NOT NULL, --AUTO_INCREMENT,
	[customerId] UNIQUEIDENTIFIER NOT NULL,
	[branchId] UNIQUEIDENTIFIER NOT NULL,
	CONSTRAINT raCustomerFK FOREIGN KEY (customerId) REFERENCES dbo.Customer(id),
	CONSTRAINT rbCustomerFK FOREIGN KEY (branchId) REFERENCES dbo.Branch(id)
)

GO
--Create a Review
CREATE PROCEDURE [dbo].[insertReview]
	@rating DECIMAL(5),
	@comment VARCHAR(1000),
	@dateCreated DATETIME,
	@customerId UNIQUEIDENTIFIER,
	@branchId UNIQUEIDENTIFIER
AS
	INSERT INTO dbo.Review (rating,comment,dateCreated,customerId,branchId) VALUES (@rating, @comment, @dateCreated, @customerId, @branchId)
GO

-- Select all reviews
CREATE PROCEDURE [dbo].[selectAllReview]
AS
	SET NOCOUNT ON;
	SELECT rating, comment, dateCreated, reviewCount FROM dbo.Review;
GO
-- Select all reviews by descending
CREATE PROCEDURE [dbo].[selectAllReviewByDesc]
AS
	SET NOCOUNT ON;
	SELECT rating, comment, dateCreated, reviewCount FROM dbo.Review ORDER BY dateCreated DESC; 
GO

--Select a review with customerId
CREATE PROCEDURE [dbo].[selectOneReview]
	@customerId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT TOP 1 rating, comment, dateCreated, reviewCount,customerId, branchId FROM dbo.Review WHERE customerId=@customerId;
GO
-- Update a review
CREATE PROCEDURE [dbo].[updateReview]
	@id int,
	@rating DECIMAL(5), 
	@comment VARCHAR (1000),
	@dateCreated DATETIME,
	@customerId UNIQUEIDENTIFIER,
	@branchId UNIQUEIDENTIFIER
AS
	UPDATE dbo.Review SET 
	rating = @rating,
	comment = @comment,
	dateCreated = @dateCreated,
	@customerId = @customerId
	WHERE id = @id AND customerId = @customerId
GO
-- Delete a review
CREATE PROCEDURE [dbo].[deleteReview]
	@id int,
	@customerId UNIQUEIDENTIFIER,
	@branchId UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Review WHERE id = @id AND customerId = @customerId and branchId = @branchId;

GO

--------------------------------------------------------------- Appointment -------------------------------------------------------------------------
CREATE TABLE [dbo].[Appointment] (	
	[id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	[aptTime] DATETIME NOT NULL, 
	[aptDate] DATETIME NOT NULL,
	[bookTime] DATETIME NOT NULL,
	[bookDate] DATETIME NOT NULL,
	[customerId] UNIQUEIDENTIFIER,
	[branchId] UNIQUEIDENTIFIER UNIQUE,
	[businessId] UNIQUEIDENTIFIER,
	[appointmentSettingId] INT,
	CONSTRAINT aaAppointmentFK FOREIGN KEY (customerId) REFERENCES dbo.Customer(id),
	CONSTRAINT abAppointmentFK FOREIGN KEY (branchId) REFERENCES dbo.Branch(id),
	CONSTRAINT acAppointmentFK FOREIGN KEY (businessId) REFERENCES dbo.Business(id),
	CONSTRAINT adAppointmentFK FOREIGN KEY (appointmentSettingId) REFERENCES dbo.AppointmentSetting(id)
)

GO
-- Create an appointment
CREATE PROCEDURE [dbo].[insertAppointment]
	@aptTime DATETIME,
	@aptDate DATETIME,
	@bookTime DATETIME,
	@bookDate DATETIME,
	@customerId UNIQUEIDENTIFIER,
	@branchId UNIQUEIDENTIFIER,
	@businessId UNIQUEIDENTIFIER,
	@appointmentSettingId INT
AS
	INSERT INTO dbo.Appointment (aptTime,aptDate,bookTime,bookDate,customerId,branchId,businessId,appointmentSettingId) VALUES (@aptTime, @aptDate, @bookTime, @bookDate, @customerId, @branchId, @businessId,@appointmentSettingId)
GO

-- Select all apppointment
CREATE PROCEDURE [dbo].[selectAllAppointment]
AS
	SET NOCOUNT ON;
	SELECT id, aptTime, aptDate, bookTime, bookDate  FROM dbo.Appointment;
GO
-- Select an appointment with customerId
CREATE PROCEDURE [dbo].[selectOneAppointmentwithCustId]
	@customerId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	SELECT TOP 1 id, aptTime, aptDate, bookTime, bookDate  FROM dbo.Appointment WHERE customerId = @customerId ;
GO
-- Select an appointment with businessId
CREATE PROCEDURE [dbo].[selectOneAppointmentwithBusId]
	@businessId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT TOP 1 id, aptTime, aptDate, bookTime, bookDate  FROM dbo.Appointment WHERE businessId = @businessId ;
GO

-- Update a appointment information
CREATE PROCEDURE [dbo].[updateAppointment]
	@id UNIQUEIDENTIFIER,
	@aptDate DATETIME, 
	@aptTime DATETIME,
	@bookDate DATETIME,
	@bookTime DATETIME,
	@customerId UNIQUEIDENTIFIER,
	@branchId UNIQUEIDENTIFIER,
	@businessId UNIQUEIDENTIFIER,
	@appointmentSettingId INT
AS
	UPDATE dbo.Appointment SET 
	aptDate = @aptDate, 
	aptTime = @aptTime,
	bookDate = @bookDate,
	bookTime = @bookTime,
	customerId = @customerId,
	branchId = @branchId,
	businessId = @businessId,
	appointmentSettingId = @appointmentSettingId
	WHERE id = @id AND customerId = @customerId AND branchId =@branchId AND businessId = @businessId AND appointmentSettingId = @appointmentSettingId
GO
-- Delete an appointment
CREATE PROCEDURE [dbo].[deleteAppointment]
	@id UNIQUEIDENTIFIER,
	@customerId UNIQUEIDENTIFIER,
	@branchId UNIQUEIDENTIFIER,
	@businessId UNIQUEIDENTIFIER,
	@appointmentSettingId UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Appointment WHERE id = @id AND customerId = @customerId AND branchId =@branchId AND businessId = @businessId AND appointmentSettingId = @appointmentSettingId;
GO

--------------------------------------------------------------- AppointmentSetting -------------------------------------------------------------------------
CREATE TABLE [dbo].[AppointmentSetting] (	
	[id] INT PRIMARY KEY IDENTITY(1,1),
	[dateSlot] DATE NOT NULL CHECK (dateSlot > GETDATE()) ,
	[timeSlot] TIME NOT NULL,
	[branchId] UNIQUEIDENTIFIER UNIQUE,
	[businessId] UNIQUEIDENTIFIER UNIQUE,
	CONSTRAINT asaAppointmentSettingFK FOREIGN KEY (branchId) REFERENCES dbo.Branch(id),
	CONSTRAINT asbAppointmentSettingFK FOREIGN KEY (businessId) REFERENCES dbo.Business(id)
)
GO
-- Create a Appointment Setting
CREATE PROCEDURE [dbo].[insertAppointmentSetting]
	@dateSlot DATE,
	@timeSlot TIME,
	@branchId UNIQUEIDENTIFIER ,
	@businessId UNIQUEIDENTIFIER 
AS
	INSERT INTO dbo.AppointmentSetting (dateSlot, timeSlot, branchId, businessId) VALUES (@dateSlot, @timeSlot, @branchId, @businessId);
GO
-- Select Appointment Setting by businessId and branchId
--CREATE PROCEDURE [dbo].[selectOneAppointmentSetting] 
--	@branchId UNIQUEIDENTIFIER 
--AS
--	SET NOCOUNT ON;
--	SET ANSI_NULLS OFF;
--	SELECT TOP 1 COUNT(dateSlot), dateSlot, timeSlot, branchId, businessId FROM dbo.AppointmentSetting WHERE branchId = @branchId GROUP BY dateSlot;
--GO
-- Update an Appointment Setting
CREATE PROCEDURE [dbo].[updateAppointmentSetting]
	@id INT,
	@timeSlot TIME, 
	@dateSlot DATE
AS
	UPDATE dbo.AppointmentSetting SET 
	timeSlot = @timeSlot, 
	dateSlot = @dateSlot
	WHERE id = @id;
GO
-- Delete an Appointment Setting
CREATE PROCEDURE [dbo].[deleteAppointmentSetting]
	@id INT
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.AppointmentSetting WHERE id = @id;
GO


--------------------------------------------------------------- Search -------------------------------------------------------------------------
CREATE TABLE [dbo].[Search] (
	[id] INT PRIMARY KEY IDENTITY(1,1),
	[searchString] VARCHAR(MAX) NOT NULL,
	[searchDateTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[customerId] UNIQUEIDENTIFIER,
	CONSTRAINT saSearchFK FOREIGN KEY (customerId) REFERENCES dbo.Customer(id)
)
GO
-- Create a search
CREATE PROCEDURE [dbo].[insertSearch]
	@searchString VARCHAR (MAX),
	@searchDateTime DATETIME ,
	@customerId UNIQUEIDENTIFIER
AS
	INSERT INTO dbo.Search (searchString, searchDateTime, customerId) VALUES (@searchString, @searchDateTime, @customerId);
GO
-- Select search by customerId
CREATE PROCEDURE [dbo].[selectSearchByCustomerId]
	@customerId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT searchString, searchDateTime FROM dbo.Search WHERE customerId = @customerId ORDER BY searchDateTime DESC;
GO
-- Delete a search by id
CREATE PROCEDURE [dbo].[deleteSearchById]
	@id INT
AS
	DELETE FROM dbo.Search WHERE id = @id;
GO
-- Delete search by customerId
CREATE PROCEDURE [dbo].[deleteSearchByCustomerId]
	@customerId UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Search WHERE customerId = @customerId;
GO



--------------------------------------------------------------- BlacklistRecord -------------------------------------------------------------------------
CREATE TABLE [dbo].[BlacklistRecord] (	
	[id] INT PRIMARY KEY IDENTITY(1,1),
	[createdAt] DATETIME NOT NULL,
	[endedAt] DATETIME NULL,
	[reason] VARCHAR (200) NOT NULL,
	[customerId] UNIQUEIDENTIFIER UNIQUE,
	[businessId] UNIQUEIDENTIFIER UNIQUE,
	[adminId] UNIQUEIDENTIFIER,
	CONSTRAINT braBlacklistRecordFK FOREIGN KEY (customerId) REFERENCES dbo.Customer(id),
	CONSTRAINT brbBlacklistRecordFK FOREIGN KEY (businessId) REFERENCES dbo.Business(id),
	CONSTRAINT brcBlacklistRecordFK FOREIGN KEY (adminId) REFERENCES dbo.Admin(id)
)
GO
-- insert
CREATE PROCEDURE [dbo].[insertBlacklistRecord]
    @createdAt DATETIME,
    @endedAt DATETIME,
    @reason VARCHAR(200),
    @customerId UNIQUEIDENTIFIER,
    @businessId UNIQUEIDENTIFIER,
    @adminId UNIQUEIDENTIFIER
AS
    INSERT INTO dbo.BlacklistRecord (createdAt, endedAt, reason, customerId, businessId, adminId) VALUES (@createdAt, @endedAt, @reason, @customerId, @businessId, @adminId);
GO

-- delete
CREATE PROCEDURE [dbo].[deleteBlacklistRecord]
    @id Int
AS
    DELETE FROM dbo.BlacklistRecord
    WHERE id = @id;
GO

-- select
CREATE PROCEDURE [dbo].[selectOneBlacklistRecord]
    @id INT
AS
	SET NOCOUNT ON;
    SELECT TOP 1 createdAt, endedAt, reason, customerId, businessId, adminId FROM dbo.BlacklistRecord WHERE id = @id;
GO

--------------------------------------------------------------- AuditLog -------------------------------------------------------------------------
CREATE TABLE [dbo].[AuditLog] (
	[id] INT PRIMARY KEY IDENTITY(1,1),
	[host] VARCHAR (100) NOT NULL,
	[loggedAt] DATETIME NOT NULL,
	[lastLoginAt] DATETIME NOT NULL,
	[description] VARCHAR (300) NOT NULL,
	[ipAddress] VARCHAR (15) NOT NULL,
	[adminId] UNIQUEIDENTIFIER,
	CONSTRAINT audBlacklistRecordFK FOREIGN KEY (adminId) REFERENCES dbo.Admin(id)
)
GO
-- insert
CREATE PROCEDURE [dbo].[insertAuditLog]
    @host VARCHAR(200),
    @loggedAt DATETIME,
    @lastLoginAt DATETIME,
    @description VARCHAR(300),
    @ipAddress VARCHAR(15),
    @adminId UNIQUEIDENTIFIER
AS
    INSERT INTO dbo.AuditLog (host, loggedAt, lastLoginAt, description, ipAddress, adminId)
    VALUES (@host, @loggedAt, @lastLoginAt, @description, @ipAddress, @adminId);
GO
-- select all
CREATE PROCEDURE [dbo].[selectAllAuditLog]
    @id INT
AS
	SET NOCOUNT ON;
   	SELECT host, loggedAt, lastLoginAt, description, ipAddress, adminId FROM dbo.AuditLog
GO

-- select One
CREATE PROCEDURE [dbo].[selectOneAuditLog]
    @id INT
AS
	SET NOCOUNT ON;
    SELECT host, loggedAt, lastLoginAt, description, ipAddress, adminId FROM dbo.AuditLog WHERE id = @id;
GO

--------------------------------------------------------------- View -------------------------------------------------------------------------
CREATE TABLE [dbo].[ViewHistory] (
    [id]           INT              IDENTITY (1, 1) NOT NULL,
    [viewDateTime] DATETIME         DEFAULT (getdate()) NOT NULL,
    [branchId]   UNIQUEIDENTIFIER NULL,
    [customerId]   UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [bViewFK] FOREIGN KEY ([branchId]) REFERENCES [dbo].[Branch] ([id]),
    CONSTRAINT [aViewFK] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer] ([id])
);
GO

-- insert
CREATE PROCEDURE [dbo].[insertView]
	@viewDateTime DATETIME ,
	@branchId UNIQUEIDENTIFIER,
	@customerId UNIQUEIDENTIFIER
AS
	INSERT INTO dbo.ViewHistory (viewDateTime, branchId, customerId) VALUES (@viewDateTime, @branchId, @customerId);
GO

-- Select view by customerId
CREATE PROCEDURE [dbo].[selectViewByCustomerId]
	@customerId UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON;
	SELECT v.viewDateTime,b.* FROM dbo.ViewHistory as v INNER JOIN dbo.Branch as b ON v.branchId = b.id WHERE customerId = @customerId ORDER BY v.viewDateTime DESC;;
GO