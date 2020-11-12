# Amazon-review-analytics
Reviewing the amazon user review data for advance database project

clone the master repo in your local using the command
git clone https://github.com/rajeshkusuma/Amazon-review-analytics.git

create respective branches to work on using the following command.
git checkout -b <brach-name>
eg. git checkout -b rajesh-work.
Note: 
	naming convention: please use your name followed by work as your branch name. 

Added Rima as colloborator to the repo, so that she can directly make commits and pull requests from the repo.

Created a new branch rima-work from the main branch...

Making the amazon web serives environment ready.
	create ec2 instance with spark
	create s3
	configure R studio
	load the data using spark r.

Setting up the EMR cluster
go to advance options
select emr 5.29
select spark
s3://adb-amazon-review/Amazon-Review/rstudio_sparklyr_emr5.sh


/usr/lib/spark/bin/


Some of the git commands extensively used as part of this project.
git status
git add
git commit -m "message"

git show <commit code>
git checkout <branch name>
git pull // pulls all the changes from the master to your working branch
git pull origin main // pulls all changes from other collaborators
git push origin rajesh-work


Some useful link which helped.

https://www.youtube.com/watch?v=T_P-AXR-YCk

https://aws.amazon.com/blogs/big-data/running-sparklyr-rstudios-r-interface-to-spark-on-amazon-emr/

https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark-configure.html

https://gist.github.com/cosmincatalin/a2e2b63fcb6ca6e3aaac71717669ab7f/eefdb19af6d3afdcb0506a797c2a5927fac72d5f#file-install-rstudio-server-sh

https://gist.github.com/cosmincatalin/a2e2b63fcb6ca6e3aaac71717669ab7f/eefdb19af6d3afdcb0506a797c2a5927fac72d5f

