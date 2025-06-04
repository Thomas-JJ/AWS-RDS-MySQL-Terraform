CREATE TABLE IF NOT EXISTS mydb.Sales
(
	ID INT AUTO_INCREMENT PRIMARY KEY,
	
    CustomerID VARCHAR(16) NOT NULL,
	Gender VARCHAR(6) NOT NULL,
	Region VARCHAR(16) NOT NULL,
	Age INT ,
	ProductName VARCHAR(32) NOT NULL,
	Category VARCHAR(32) NOT NULL,
	UnitPrice DECIMAL(8,2) NOT NULL,
	Quantity INT NOT NULL,
	TotalPrice DECIMAL(8,2) NOT NULL,
	ShippingFee DECIMAL(8,2) NOT NULL,
	ShippingStatus VARCHAR(32) ,
	OrderDate Date NOT NULL,

	-- Standard Audit Columns
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    glue_job_name VARCHAR(255),
    glue_job_run_id VARCHAR(255),
    glue_execution_date DATE,
    glue_execution_timestamp TIMESTAMP,
    source_system VARCHAR(100),
    source_file_path VARCHAR(500),
    source_file_timestamp TIMESTAMP,
    batch_id VARCHAR(100),
    partition_key VARCHAR(100)
    
);



CREATE TABLE IF NOT EXISTS mydb.SalesTemp
(
	CustomerID VARCHAR(16) NOT NULL,
	Gender VARCHAR(6) NOT NULL,
	Region VARCHAR(16) NOT NULL,
	Age INT ,
	ProductName VARCHAR(32) NOT NULL,
	Category VARCHAR(32) NOT NULL,
	UnitPrice DECIMAL(8,2) NOT NULL,
	Quantity INT NOT NULL,
	TotalPrice DECIMAL(8,2) NOT NULL,
	ShippingFee DECIMAL(8,2) NOT NULL,
	ShippingStatus VARCHAR(32) ,
	OrderDate Date NOT NULL
)