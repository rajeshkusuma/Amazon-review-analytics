# Amazon review analytics.

install.packages("sparklyr")
library(sparklyr)
library(dplyr)

# creating a spark session.
sc <- sparklyr::spark_connect(master = "local", spark_home = "/usr/lib/spark/")
sc = sparkR.session(master='local')

spark_version(sc)

# s3 bucket path
s3_bucket <- "s3://adb-amazon-review/Amazon-Review/"


# assinging the s3 bucket name
movies_data <- spark_read_csv(sc, 'reviews_Movies_and_TV_5',
                              path = s3_bucket,
                              memory = T,
                              columns = NULL,
                              infer_schema = T)

#loading datasets
ar_Movies_and_TV <- SparkR::read.df(path=paste(s3_bucket, 
                                               "/reviews_Movies_and_TV_5.json", sep = ""), source="json")


# copying data
movies_data <- tbl(sc, "reviews_movies_and_tv_5")

dim(movies_data)

# printing the first few columns of the dataset.
print(movies_data, n =5, width = Inf)

# examine the structure of the dataset
str(movies_data)
glimpse(movies_data)
nrow(movies_data)





