# ETL-Pipeline-with-Amazon-EMR-and-Apache-Spark

A scalable data processing solution using Amazon EMR, PySpark, S3, and Athena to process monthly sales data.

## **Project Overview**
This project implements an ETL (Extract, Transform, Load) pipeline that processes incremental sales data provided by vendors at the end of each month. The system automatically processes CSV files, applies transformations, and makes the data available for analysis.

## **Architecture**
![Architecture](https://github.com/user-attachments/assets/d4c09244-8b23-4a89-82a2-56d49bd680dc)


- Data Source: CSV sales files uploaded to S3 input folder
- Processing: Amazon EMR cluster running PySpark jobs
- Storage: S3 buckets for raw data, processed data, and logs
- Analysis: Amazon Athena for SQL querying of processed data

## **Technology Stack**

1. Amazon EMR: Distributed processing framework
2. Apache Spark: In-memory data processing engine
3. PySpark: Python API for Spark
4. Amazon S3: Object storage for data lake
5. Amazon Athena: Serverless query service
6. Terraform: Infrastructure as Code
7. AWS IAM: Security and access management

# **Implementation Steps**

## **Infrastructure Setup**

1. VPC configuration with proper networking
2. IAM roles with appropriate permissions
3. S3 buckets with folder structure
4. EMR cluster configuration with auto-scaling


## **Cluster Deployment**

- Deployed EMR cluster with Hadoop, Hive, and Spark applications
- Configured security groups to allow SSH access
- Set up logging to S3


## **ETL Job Development**

- Created PySpark script for data transformation
- Implemented data cleansing and validation logic
- Added error handling and logging


## **Job Execution**

- Submitted job via SSH connection to master node
- Monitored execution in real-time
- Validated output data in S3


## **Data Analysis**

- Configured Athena to query processed data
- Created SQL queries for business insights

## **Lessons Learned**

- Properly configuring EMR instance types can significantly impact cost and performance
- IAM role permissions need careful consideration for security
- Auto-scaling policies should be configured based on workload patterns
- S3 bucket policies and lifecycle rules help manage data efficiently
- Terraform makes infrastructure management repeatable and version-controlled

## **Future Improvements**

- Implement AWS Step Functions for orchestration
- Add data quality validation steps
- Create CloudWatch alarms for monitoring
- Implement GitOps workflow for CI/CD
- Add more comprehensive testing

---
Thanks for Reading

