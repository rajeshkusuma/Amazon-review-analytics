# Amazon-review-analytics
Data Source: http://jmcauley.ucsd.edu/data/amazon/

**Problem Statment:**

Bases on the market research identify the best product catergory to launch a new product in order to boost revenue.

**Approach Taken:**


Since we are dealing with customer reviews data. It is important to understand what customers are expressing about the products they are buying. 
To identify the best product category for a new product, some of the question I tried to answers is:

* Which product category has a larger market size?
* Which product category is likely to be purchased heavily?
* Which product category is likely to make the customers happy after the purchase?
* What is the helpful ratio for each product category? (helpful ratio: helful reviews/total no of reviews)

**Implementation:**

**Data Preparation:**

Performed data ingestion to Amazon S3 bucket on JSON data using AWS CLI commands.
Checked for data quality issues like missing data, spelling corrections, special charaters in words.

**Data Analysis:**

Performed data aggregations and summarisation to understand means, measures of spread, and frequencies.
Performed statistical aggregations to understand different metrics of each product category like market share, size, no of reviews etc...
Written lambda functions to extract postive key words from review strings.
Dervied new columns using SprakR data manipulation fuctions.
Compared all the metrics across the product categories. Based on the data recommended the best product category.

**Results and Outcomes:**

Recommended “movies and tv” is the best product category based on best customer reviews, the helpful ratio from customer with an average of 8%, and 44 % percent market share in the data.

**Resources and References:**

* https://www.youtube.com/watch?v=T_P-AXR-YCk
* https://aws.amazon.com/blogs/big-data/running-sparklyr-rstudios-r-interface-to-spark-on-amazon-emr/
* https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark-configure.html
* https://gist.github.com/cosmincatalin/a2e2b63fcb6ca6e3aaac71717669ab7f/eefdb19af6d3afdcb0506a797c2a5927fac72d5f#file-install-rstudio-server-sh
* https://gist.github.com/cosmincatalin/a2e2b63fcb6ca6e3aaac71717669ab7f/eefdb19af6d3afdcb0506a797c2a5927fac72d5f

