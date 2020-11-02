#Amazon review analytics.

#setting environment using keys
Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAINOXIJSE6J6B7R6A",
           "AWS_SECRET_ACCESS_KEY" = "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",
           "AWS_DEFAULT_REGION" = "us-west-2)")

#loading library
library(SparkR)

#setting the session
sc = sparkR.session(master='local')

#assigning bucket name
S3_BUCKET_NAME <- "s3a://sparks3test"

#loading datasets
ar_Movies_and_TV <- SparkR::read.df(path=paste(S3_BUCKET_NAME, 
                                               "/reviews_Movies_and_TV_5.json", sep = ""), source="json")

ar_CDs_and_Vinyl <- SparkR::read.df(path=paste(S3_BUCKET_NAME, 
                                               "/reviews_CDs_and_Vinyl_5.json", sep = ""), source="json")

ar_Kindle_Store.json <-SparkR::read.df(path=paste(S3_BUCKET_NAME, 
                                                  "/reviews_Kindle_Store_5.json", sep = ""), source="json")

# look at the first few rows
head(ar_CDs_and_Vinyl)
head(ar_Kindle_Store.json)
head(ar_Movies_and_TV)

#1.Which product category has a larger market size ?
# assuming each review as one purchase to find product category which has got
# largest market share
# examine the size of the datasets
nreviews_Movies_and_TV <- nrow(ar_Movies_and_TV) #1697533
nreviews_Movies_and_TV
ncol(ar_Movies_and_TV) #9

nreviews_CDs_and_Vinyl <- nrow(ar_CDs_and_Vinyl) #1097592
nreviews_CDs_and_Vinyl
ncol(ar_CDs_and_Vinyl) #9

nreviews_Kindle_Store <-nrow(ar_Kindle_Store.json) #982619
nreviews_Kindle_Store
ncol(ar_Kindle_Store.json) #9

# sum up number of reviews from all three producs to find 
# total number of reviews
Total_reviews <- nreviews_Movies_and_TV + 
  nreviews_CDs_and_Vinyl +
  nreviews_Kindle_Store

# market size of Movies_and_TV
msize_Movies_and_TV <- (nreviews_Movies_and_TV /Total_reviews)*100
msize_Movies_and_TV #44.9351%

# market size of CDs_and_Vinyl
msize_CDs_and_Vinyl <- (nreviews_CDs_and_Vinyl/Total_reviews)*100
msize_CDs_and_Vinyl #29.05417%

# market size of CDs_and_Vinyl
msize_Kindle_Store <- (nreviews_Kindle_Store/Total_reviews)*100
msize_Kindle_Store  #26.01074%

# Movies_and_TV product category has largest market size i.e. 45% among three
