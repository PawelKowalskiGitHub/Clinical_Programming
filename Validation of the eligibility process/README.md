# Validation of the eligibility process

This project consists of assessing the correctness of the subject's clinical study eligibility for the randomization process. The Principal Investigator (PI) and sponsor (CM) determine the eligibility of subjects for a clinical study. Each patient is assigned to a given country and site and has a unique id. His eligibility for randomization is assessed by the PI and/or CM.

Validation is a randomization process correctness analysis. All subjects (who have with randomization date) have been randomized, but in some cases, they have an ineligible status assigned by PI or CM, so this is an error that needs to be caught.

In the Generate_files_in_Python folder, there are two programs for creating a database and files containing information about subjects and their eligibility. The create_files.py program allows us to enter all data into the dataset and create separate CSV files. The random_database.py program allows us to generate the data randomly.

In the Data_Analysis_in_SAS folder there are SAS programs with which the randomization process correctness analysis was performed.
In the Data_Analysis_in_R/Python folders is analogical analysis in R/Python. 
