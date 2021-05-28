# Amazon review analytics.

# set the up the amazon aws web serivice

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


#3.Which product category is likely to make the customer happy
# after the purchase
# assumption is customers are happy if the rating is equal or greater than
# four i.e. =>4

#get the count of reviews against each rating
count_overall_rating_CDs_and_Vinyl <- summarize(groupBy(ar_CDs_and_Vinyl, ar_CDs_and_Vinyl$overall), 
                                                count = count(ar_CDs_and_Vinyl$overall))

showDF(count_overall_rating_CDs_and_Vinyl)

#  |overall| count|
#  +-------+------+
#  |    1.0| 46195|
#  |    4.0|246326|
#  |    3.0|101824|
#  |    2.0| 46571|
#  |    5.0|656676|
#  +-------+------+

# Filter high rating rows i.e. overall rating >=4
high_rating_CDs_and_Vinyl <- filter(count_overall_rating_CDs_and_Vinyl, 
                                    count_overall_rating_CDs_and_Vinyl$overall>=4 )

showDF(agg(high_rating_CDs_and_Vinyl, tot = sum(high_rating_CDs_and_Vinyl$count)))
#Total number of high raters for CDs_and_Vinyl : 903002


#get the count of reviews against each rating
count_overall_rating_Kindle_Store <- summarize(groupBy(ar_Kindle_Store.json, ar_Kindle_Store.json$overall), 
                                               count = count(ar_Kindle_Store.json$overall))
showDF(count_overall_rating_Kindle_Store)

#   ----+------+--
#  |overall| count|
#  +-------+------+
#  |    1.0| 23018|
#  |    4.0|254013|
#  |    3.0| 96194|
#  |    2.0| 34130|
#  |    5.0|575264|
#  +-------+------+

# Filter high rating rows i.e. overall rating >=4
high_rating_Kindle_Store <- filter(count_overall_rating_Kindle_Store, 
                                   count_overall_rating_Kindle_Store$overall>=4 )

showDF(agg(high_rating_Kindle_Store, tot = sum(high_rating_Kindle_Store$count)))
# Total number of high raters for Kindle_Store :829277


# change from rajesh-work brach

