#loading library
library(SparkR)

#setting the session
sc = sparkR.session(master='local')

# s3 bucket path
S3_BUCKET_NAME <- "s3://adb-amazon-review/Amazon-Review/"

#loading datasets
ar_Movies_and_TV <- SparkR::read.df(path=paste(S3_BUCKET_NAME, 
                                               "/reviews_Movies_and_TV_5.json", sep = ""), source="json")

ar_CDs_and_Vinyl <- SparkR::read.df(path=paste(S3_BUCKET_NAME, 
                                               "/reviews_CDs_and_Vinyl_5.json", sep = ""), source="json")

ar_Kindle_Store <-SparkR::read.df(path=paste(S3_BUCKET_NAME, 
                                                  "/reviews_Kindle_Store_5.json", sep = ""), source="json")

# look at the first few rows
head(ar_CDs_and_Vinyl)
head(ar_Kindle_Store)
head(ar_Movies_and_TV)

# look at the summary of the datasets
summarise(ar_CDs_and_Vinyl)
summarise(ar_Kindle_Store)
summarise(ar_Movies_and_TV)

# head(summarize(groupBy(ar_CDs_and_Vinyl, ar_CDs_and_Vinyl$asin), count = n()))

#1.Which product category has a larger market size ?
#********************************************************************************
# assuming each review as one purchase in order to find product category 
# which has got largest market share
#********************************************************************************

# examine the size of the datasets
dim_cd <- dim(ar_CDs_and_Vinyl)
dim_kindle <- dim(ar_Kindle_Store)
dim_movies <- dim(ar_Movies_and_TV)

# sum up number of reviews from all three producs to find 
# total number of reviews
Total_reviews <- dim_cd[1] + dim_kindle[1] + dim_movies[1]
# 3777744

# market size of Movies_and_TV
msize_Movies_and_TV <- (dim_movies[1]/Total_reviews)*100
msize_Movies_and_TV #44.9351%

# market size of CDs_and_Vinyl
msize_CDs_and_Vinyl <- (dim_cd[1]/Total_reviews)*100
msize_CDs_and_Vinyl #29.05417%

# market size of CDs_and_Vinyl
msize_Kindle_Store <- (dim_kindle[1]/Total_reviews)*100
msize_Kindle_Store  #26.01074%

# Movies_and_TV product category has largest market size i.e. 45% among three

#3.Which product category is likely to make the customer happy after the purchase
#********************************************************************************
# assumption is customers are happy if the rating is equal or greater than
# four i.e. =>4
#********************************************************************************

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
count_overall_rating_Kindle_Store <- summarize(groupBy(ar_Kindle_Store, ar_Kindle_Store$overall), 
                                               count = count(ar_Kindle_Store$overall))
showDF(count_overall_rating_Kindle_Store)

# ----+------+
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


#get the count of reviews against each rating
count_overall_rating_Movies_and_TV <- summarize(groupBy(ar_Movies_and_TV, ar_Movies_and_TV$overall), 
                                                count = count(ar_Movies_and_TV$overall))
showDF(count_overall_rating_Movies_and_TV)

#  +-------+------+
#  |overall| count|
#  +-------+------+
#  |    1.0|104219|
#  |    4.0|382994|
#  |    3.0|201302|
#  |    2.0|102410|
#  |    5.0|906608|
#  +-------+------+

# Filter high rating rows i.e. overall rating >=4
high_rating_Movies_and_TV <- filter(count_overall_rating_Movies_and_TV, 
                                    count_overall_rating_Movies_and_TV$overall>=4 )

showDF(agg(high_rating_Movies_and_TV, tot = sum(high_rating_Movies_and_TV$count)))
# Total number of high raters for Movies_and_TV :1289602

# Total number of high raters for CDs_and_Vinyl : 903002
# Total number of high raters for Kindle_Store  : 829277
# Total number of high raters for Movies_and_TV :1289602
# looking at the above data,poduct category is likely to make
# customer happy is Movies_and_TV segment

#2.Which product category is likely to be purchased heavily based on
# grant total of helpful ratio
#***********************************************************************************
#Helful ratio = number of people who found the review helpful/ total number of people
#***********************************************************************************

# Extracting 1st and 2n values from Tuple to find helpful ratio
temp_Movies_and_TV <- select(ar_Movies_and_TV,posexplode(ar_Movies_and_TV$helpful))
temp_Movies_and_TV_helpful <- filter(temp_Movies_and_TV,temp_Movies_and_TV$pos == 0)
temp_Movies_and_TV_totalreview <- filter(temp_Movies_and_TV,temp_Movies_and_TV$pos == 1)


# collecting values into r frame
temp_Movies_and_TV_helpful_r_df <- collect(temp_Movies_and_TV_helpful)
temp_Movies_and_TV_totalreview_r_df <- collect(temp_Movies_and_TV_totalreview)

temp_Movies_and_TV_helpful_r_df$tot <-temp_Movies_and_TV_totalreview_r_df$col
colnames(temp_Movies_and_TV_helpful_r_df)[2] <- "fnd_helpful"

# adding helpful ratio for each row
temp_Movies_and_TV_helpful_r_df$helpful_ratio <- temp_Movies_and_TV_helpful_r_df$fnd_helpful/ temp_Movies_and_TV_helpful_r_df$tot


# finding grant total of helpful ratio
Movies_and_TV_helpful_r_total_help_ratio <- dplyr::summarize(temp_Movies_and_TV_helpful_r_df,sum(temp_Movies_and_TV_helpful_r_df$helpful_ratio,na.rm = TRUE))

Movies_and_TV_helpful_r_total_help_ratio #678481.9
#grant total of helpful ratio for Movies_and_TV : 678481.9

# Extracting values from Tuple to find total helpful ratio for Kindle_Store
temp_CDs_and_Vinyl<- select(ar_CDs_and_Vinyl,posexplode(ar_CDs_and_Vinyl$helpful))

temp_CDs_and_Vinyl_helpful<- filter(temp_CDs_and_Vinyl,temp_CDs_and_Vinyl$pos == 0)
temp_CDs_and_Vinyl_totalreview <- filter(temp_CDs_and_Vinyl,temp_CDs_and_Vinyl$pos == 1)


temp_CDs_and_Vinyl_helpful_r_df <- collect(temp_CDs_and_Vinyl_helpful)
temp_CDs_and_Vinyl_totalreview_r_df <- collect(temp_CDs_and_Vinyl_totalreview)

temp_CDs_and_Vinyl_helpful_r_df$tot <- temp_CDs_and_Vinyl_totalreview_r_df$col
colnames(temp_CDs_and_Vinyl_helpful_r_df)[2] <- "fnd_helpful"

temp_CDs_and_Vinyl_helpful_r_df$helpful_ratio <- temp_CDs_and_Vinyl_helpful_r_df$fnd_helpful/ temp_CDs_and_Vinyl_helpful_r_df$tot

CDs_and_Vinyl_helpful_r_total_help_ratio <- dplyr::summarize(temp_CDs_and_Vinyl_helpful_r_df, 
                                                             sum (temp_CDs_and_Vinyl_helpful_r_df$helpful_ratio,na.rm = TRUE))

CDs_and_Vinyl_helpful_r_total_help_ratio #566979.2
#grant total of helpful ratio for CDs_and_Vinyl : 566979.2

#Extracting values from Tuple to find total helpful ratio for CDs_and_Vinyl 

temp_Kindle_Store <- select(ar_Kindle_Store,posexplode(ar_Kindle_Store$helpful))

temp_Kindle_Store_helpful <- filter(temp_Kindle_Store,temp_Kindle_Store$pos == 0)
temp_Kindle_Store_totalreview <- filter(temp_Kindle_Store,temp_Kindle_Store$pos == 1)

temp_Kindle_Store_helpful_r_df <- collect(temp_Kindle_Store_helpful)
temp_Kindle_Store_totalreview_r_df <- collect(temp_Kindle_Store_totalreview)

temp_Kindle_Store_helpful_r_df$tot <-temp_Kindle_Store_totalreview_r_df$col
colnames(temp_Kindle_Store_helpful_r_df)[2] <- "fnd_helpful"

temp_Kindle_Store_helpful_r_df$helpful_ratio <- temp_Kindle_Store_helpful_r_df$fnd_helpful/ temp_Kindle_Store_helpful_r_df$tot


Kindle_Store_helpful_r_total_help_ratio <- dplyr::summarize(temp_Kindle_Store_helpful_r_df, 
                                                            sum (temp_Kindle_Store_helpful_r_df$helpful_ratio,na.rm = TRUE))

Kindle_Store_helpful_r_total_help_ratio  #367361.5
#grant total of helpful ratio for Kindle_Store:367361.5

#Total helpful ratio for Movies_and_TV is #678481.9
#Total helpful ratio for CDs_and_Vinyl is #566979.2 
#Total helpful ratio for Kindle_Store  is #367361.5
#as Movies_and_TV has got higher helpful ratio i.e.678481.9 
#hence Movies_and_TV is likely to be purchased heavily

#2a.Which product category is likely to be purchased heavily based on avg help_ratio
#***********************************************************************************
#Helful ratio = number of peole who found the review helpful/ total number of people
#***********************************************************************************
CDs_and_Vinyl_helpful_r_avg_help_ratio <- dplyr::summarize(temp_CDs_and_Vinyl_helpful_r_df, 
                                                           mean (temp_CDs_and_Vinyl_helpful_r_df$helpful_ratio,na.rm = TRUE))
CDs_and_Vinyl_helpful_r_avg_help_ratio # 0.7073386

Movies_and_TV_helpful_r_avg_help_ratio <- dplyr::summarize(temp_Movies_and_TV_helpful_r_df,mean(temp_Movies_and_TV_helpful_r_df$helpful_ratio,na.rm = TRUE))
Movies_and_TV_helpful_r_avg_help_ratio # 0.6231739


Kindle_Store_helpful_r_avg_help_ratio <- dplyr::summarize(temp_Kindle_Store_helpful_r_df, 
                                                          mean (temp_Kindle_Store_helpful_r_df$helpful_ratio,na.rm = TRUE))
Kindle_Store_helpful_r_avg_help_ratio  # 0.8122255

#kindle store is famous product line based on average helpful ratio

#4.Which product catogry is famous across reviewers based on length of the review text
#**************************************************************************************
#assumption : If length of the review text is more, then customers are happy
#**************************************************************************************

###adding length of the review text
ar_Movies_and_TV$reviewtext_length <-length(ar_Movies_and_TV$reviewText)
ar_Kindle_Store$reviewtext_length <- length(ar_Kindle_Store$reviewText)
ar_CDs_and_Vinyl$reviewtext_length <- length(ar_CDs_and_Vinyl$reviewText)

head(agg(ar_Movies_and_TV, length_tol = sum(ar_Movies_and_TV$reviewtext_length)))
#Total length of review text for Movies_and_TV : 1565297599

head(agg(ar_Kindle_Store, length_tol = sum(ar_Kindle_Store$reviewtext_length)))
#Total length of review text for Kindle_Store  :  593450774

head(agg(ar_CDs_and_Vinyl, length_tol = sum(ar_CDs_and_Vinyl$reviewtext_length)))
#Total length of review text for CDs_and_Vinyl : 1089459822

#Movies_and_TV is the product is famous across reviewers

#5.Which product catogry is famous across high rated reviewers based on length of the review text
#************************************************************************************************
#assumption : If length of the review text is more & rating is 5, then customers are happy
#************************************************************************************************

#Find the total length of the review text for reviews got 5 ratings for each product
high_rating_movies_TV_rev_txt_tol_len <- filter(ar_Movies_and_TV, 
                                                ar_Movies_and_TV$overall==5 )

showDF(agg(high_rating_movies_TV_rev_txt_tol_len, tot = sum(high_rating_movies_TV_rev_txt_tol_len$reviewtext_length)))

#Total length of review text for Kindle_Store for high rating reviews :712575303


high_rating_Kindle_Store_rev_txt_tol_len <- filter(ar_Kindle_Store, 
                                                   ar_Kindle_Store$overall==5 )

showDF(agg(high_rating_Kindle_Store_rev_txt_tol_len, tot = sum(high_rating_Kindle_Store_rev_txt_tol_len$reviewtext_length)))
#Total length of review text for Kindle_Store for high rating reviews :319591343


high_rating_CDs_Vinyl_rev_txt_tol_len <- filter(ar_CDs_and_Vinyl, 
                                                ar_CDs_and_Vinyl$overall==5 )

showDF(agg(high_rating_CDs_Vinyl_rev_txt_tol_len, tot = sum(high_rating_CDs_Vinyl_rev_txt_tol_len$reviewtext_length)))
#Total length of review text for Kindle_Store for high rating reviews :622567752

#Movies_and_TV is the product is famous across top rated reviews

#6.Which product catogry is famous based on +ve key words in summary text ?
#************************************************************************************************
#assumption :  if summary text contains below keywords, then it is assumed customers are happy and
#new buys will also likely to buy the product
# +ve keywords : good|nice|excellent|happy|satisfied|worth
#************************************************************************************************

#Movies_and_TV
#-------------
#convert dataframe to rdd
ar_Movies_and_TV.rdd <- SparkR:::toRDD(ar_Movies_and_TV)

#filter the RDD data using +ve key words
ar_Movies_and_TV.rdd.filtered <- SparkR:::filterRDD(ar_Movies_and_TV.rdd, function(s) 
{ grepl("good|nice|excellent|happy|satisfied|worth", s$summary, ignore.case = TRUE, perl = TRUE) })

ar_Movies_and_TV.filtered <- as.DataFrame(ar_Movies_and_TV.rdd.filtered)
head(ar_Movies_and_TV.filtered)

Movies_and_TV_Postive_reviews <- nrow(ar_Movies_and_TV.filtered)
Movies_and_TV_Postive_reviews 
#number of +ve revoiews received for Movies and TV : 164546

#CDs_and_Vinyl
#-------------
#convert dataframe to rdd
CDs_and_Vinyl.rdd <- SparkR:::toRDD(ar_CDs_and_Vinyl)

#filter the RDD data using +ve key words
ar_CDs_and_Vinyl.rdd.filtered <- SparkR:::filterRDD(CDs_and_Vinyl.rdd, function(s)
{ grepl("good|nice|excellent|happy|satisfied|worth", s$summary, ignore.case = TRUE, perl = TRUE) })

ar_CDs_and_Vinyl.filtered <- as.DataFrame(ar_CDs_and_Vinyl.rdd.filtered)

CDs_and_Vinyl_Postive_reviews <- nrow(ar_CDs_and_Vinyl.filtered)
CDs_and_Vinyl_Postive_reviews
#number of +ve revoiews received for CDs_and_Vinyl : 96649

#Movies_and_TV movies have got more positive reviews

# Analysis outcome
#*****************************************************************
#  MOVIES and TV product line is recommended to invest           #
#   -this product line scores high in all the metrics except one #
#     Hence, movies and TV has been selected                     #
#                                                                #
#  Assumption :                                                  #
#     Since MOVIES and TV product line is famous product,        #
#     So this could be the reason why Amazon has launced         #
#     Amazon Prime video streaming product!                      #
#*****************************************************************






