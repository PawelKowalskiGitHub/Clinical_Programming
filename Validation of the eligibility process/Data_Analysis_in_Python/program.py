
# =============================================================================
# PACKAGES
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# =============================================================================



data_list = ["//home/pawel/Pulpit/Programowanie/Projects/Clinical-Programming/Data_Analysis_in_Python/randomized.csv",
             "//home/pawel/Pulpit/Programowanie/Projects/Clinical-Programming/Data_Analysis_in_Python/site.csv",
             "/home/pawel/Pulpit/Programowanie/Projects/Clinical-Programming/Data_Analysis_in_Python/country.csv",
             "/home/pawel/Pulpit/Programowanie/Projects/Clinical-Programming/Data_Analysis_in_Python/assessment_of_pi.csv",
             "/home/pawel/Pulpit/Programowanie/Projects/Clinical-Programming/Data_Analysis_in_Python/criteria_of_pi.csv",
             "/home/pawel/Pulpit/Programowanie/Projects/Clinical-Programming/Data_Analysis_in_Python/assessment_of_cm.csv"]

data = [] # list for all imported data frames
for filename in data_list:
    data.append(pd.read_csv(filename))

# =============================================================================
# CREATING ONE DATASET
# =============================================================================
country_site = [data[1], data[2]]                       # it is necessary to create a new dataset
dataset = pd. concat(country_site, axis=1)              # by concatenation
dataset = dataset.iloc[:, lambda dataset: [1, 4, 5]]    # selecting only specific columns
dataset = pd.merge(dataset, data[0], on='subject', how='left')
dataset = dataset[['subject', 'country', 'site']]
dataset = pd.merge(dataset, data[3], on='subject', how='left')
dataset = dataset[['subject','site', 'country', 'pi_assessment']]
dataset = pd.merge(dataset, data[4], on='subject', how='left')
dataset = dataset[['subject','site', 'country', 'pi_assessment', 'pi_crit']]
dataset = pd.merge(dataset, data[5], on='subject', how='left')
dataset = dataset[['subject','site', 'country', 'pi_assessment', 'pi_crit', 'cm_assessment']]

# creating new varabiable to sign of final eligibility for each randomized subject
elibi = []
for index, i in dataset.iterrows():
    if i['pi_assessment'] != "Eligible" or i['pi_crit'] == "Exclusion" or i['cm_assessment'] == "Exclusion":
        elibi.append("Ineligible")
    else: 
        elibi.append("Eligible")

dataset['Eligibility'] = elibi

# REMOVING DUPS
dataset.drop_duplicates(subset ="subject", keep = "first", inplace = True) 


# =============================================================================
# CALCULATIONS
# =============================================================================

# > Study level <
# number of all randomized subjects on study
all_subjects = dataset['subject'].count() # all randomized subjects
print("Number of all randomized subjects on study: " + str(all_subjects))
# number of incorrectly randomized (ineligible) subjects on study
Ineligible_subjects = dataset[(dataset['Eligibility']=="Ineligible")]['subject'].count()
print("Number of incorrectly randomized (ineligible) subjects on study: " + str(Ineligible_subjects))
# ratio of incorrectly randomized (ineligible) subjects on study
study_ratio = Ineligible_subjects/all_subjects
print("Ratio of incorrectly randomized (ineligible) subjects on study: " + str(study_ratio))


# > Country level <
list_country = dataset['country'] # list of data from country variable
list_country = list(set(list_country)) # store only unique values and convert to list
list_country.sort() # sorting of list elements

ineligible_sub_in_country = [] # list of ineligible subjects in each country
for j in range(len(list_country)):
    count = dataset[(dataset['Eligibility']=="Ineligible") & (dataset['country']==list_country[j])]['subject'].count()
    ineligible_sub_in_country.append(count)
#print("umber of incorrectly randomized (ineligible) subjects on country: " + str(ineligible_sub_in_country))

all_sub_in_country = [] # list of all subjects in each country
for j in range(len(list_country)):
    count = dataset[(dataset['country']==list_country[j])]['subject'].count()
    all_sub_in_country.append(count)
#print("Number of all randomized subjects on country: " + str(all_sub_in_country))

# ratio of ineligible subjects in each country
ratio_country = np.divide(ineligible_sub_in_country, all_sub_in_country)
list(ratio_country)

# data frame for country
df_country = pd.DataFrame(list(zip(list_country, all_sub_in_country, ineligible_sub_in_country, ratio_country)), columns=['country', 'all_sub', 'ineli_sub', 'ratio'])
max_ratio_country = df_country.iloc[df_country["ratio"].idxmax(),0] # finding the index of max ratio and checking a country name for this ratio (index)
print("Name of country with max ratio of incorrectly randomized (ineligible) subjects: " + str(max_ratio_country))


# > Site level <
list_site = dataset['site'] # list of data from site variable
list_site = list(set(list_site)) # store only unique values and convert to list
list_site.sort() # sorting of list elements

ineligible_sub_in_site = [] # list of ineligible subjects in each site
for j in range(len(list_site)):
    count = dataset[(dataset['Eligibility']=="Ineligible") & (dataset['site']==list_site[j])]['subject'].count()
    ineligible_sub_in_site.append(count)

all_sub_in_site = [] # list of all subjects in each site
for j in range(len(list_site)):
    count = dataset[(dataset['site']==list_site[j])]['subject'].count()
    all_sub_in_site.append(count)

# ratio of ineligible subjects in each site
ratio_site = np.divide(ineligible_sub_in_site, all_sub_in_site)
list(ratio_site)

# data frame for site
df_site = pd.DataFrame(list(zip(list_site, all_sub_in_site, ineligible_sub_in_site, ratio_site)), columns=['site', 'all_sub', 'ineli_sub', 'ratio'])
max_ratio_site = df_site.iloc[df_site["ratio"].idxmax(),0] # finding the index of max ratio and checking a site name for this ratio (index)
print("Name of site with max ratio of incorrectly randomized (ineligible) subjects: " + str(max_ratio_site))

# =============================================================================
# VISUALIZATION
# =============================================================================

# Figure with eligible and ineligible subjects in each country
dataset.groupby(['country','Eligibility']).size().unstack().plot(kind='bar', stacked=True)
plt.ylabel("Subjects") 
plt.title("Eligible and ineligible subjects in each country") 
plt.show()

# Figure with Ratios of incorrectly randomized on country
fig_country = plt.figure(figsize = (10, 5)) 
plt.bar(list_country, ratio_country, width = 0.4) 
plt.ylabel("Ratio") 
plt.title("Ratios of incorrectly randomized on country") 
plt.show() 


# Figure with eligible and ineligible subjects in each site
df_site2 = df_site[(df_site['ineli_sub'] != 0)] # dataframe for ineligible subjects

df_site3 = df_site2[['site', 'all_sub', 'ineli_sub']]
df_site3.plot.bar(x='site', stacked=True)
plt.xlabel("Site") 
plt.ylabel("Subjects") 
plt.title("Eligible and ineligible subjects in site") 
plt.show()

# Figure with ratios of incorrectly randomized on country
df_site2.plot.bar(x='site', y='ratio', rot=90)
plt.ylabel("Ratio") 
plt.title("Ratios of incorrectly randomized on site") 
plt.show()
