# Validation of the eligibility process

This project consists of assessing the correctness of the subject's clinical trial eligibility for the randomization process. The Principal Investigator (PI) and Sponsor (CM) decide on eligibility for a clinical trial. Each patient has a unique id, is assigned to a given country and site, and his eligibility for randomization is assessed by the PI and/or CM.

Validation is that all subjects (who have with randomization date) have been randomized, but in some cases, they have an ineligible status assigned by PI or CM, so this is an error that needs to be caught.

In the Generate_files_in_Python folder, there are two programs for creating a database and files containing information about subjects and their eligibility. The create_files.py program allows us to enter all data into the dataset and create separate CSV files. The random_database.py program allows us to generate the data randomly.
In the Data_Analysis_in _SAS folder there are SAS programs with which the randomization process correctness analysis was performed.
