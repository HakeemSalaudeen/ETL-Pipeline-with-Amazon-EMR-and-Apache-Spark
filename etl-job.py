from pyspark.sql import SparkSession
from pyspark.sql import functions as F
import logging

def main():
    # start Spark Session
    spark = SparkSession.builder \
        .appName("Monthly Sales Data Processing") \
        .getOrCreate()
        
    # Configure logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # log level to avoid verbose logging
    spark.sparkContext.setLogLevel('WARN')

    # s3 Input and output paths
    input_path = 's3://emr-datalake/input-folder/SalesData.csv'
    output_path = 's3://emr-datalake/output-folder/'

    try:
        # Read CSV data with header and infer schema
        logger.info("Reading input data from S3 bucket")
        df = spark.read.csv(input_path, header=True, inferSchema=True)
        
        # Basic data cleaning steps:
        
        # 1. Clean column names (remove spaces)
        logger.info("Cleaning column names")
        df = df.select([F.col(col).alias(col.replace(' ', '_')) for col in df.columns])
        
        # 2. Filter out empty rows (where all values are null)
        df = df.na.drop(how='all')
        
        # Show some basic statistics
        logger.info(f"Total records: {df.count()}")
        logger.info(f"Columns: {', '.join(df.columns)}")
        df.printSchema()
        df.show(5)
        
        # Write output as Parquet
        logger.info("Writing output data to S3 as Parquet...")
        df.write \
          .mode('overwrite') \
          .parquet(output_path)
        
        logger.info("Successfully processed and saved data")
        
    except Exception as e:
        logger.error(f"Error processing data: {str(e)}")
    finally:
        spark.stop()

if __name__ == '__main__':
    main()