
import random
import pandas as pd
import numpy as np


country = []
site = []
subject = []
pi_assessment = []
pi_crit = []
pi_crit_num = []
cm_assessment = []
cm_desciption = []
rand_date = []

def database_generator():
    global database
    country_id = input("Enter the country ID of the subject: ")
    country_text = str("country" + country_id)
    country.append(country_text)

    site_id = input("Enter the site ID of the subject: ")
    site_text = str("site" + site_id)
    site.append(site_text)

    subject_id = random.randint(0, 99)
    if subject_id < 10:
        subject_id = str("0" + str(subject_id))
    subject_text = str("E" + country_id + site_id + str(subject_id))
    while subject_text in subject:
        subject_id = random.randint(0, 99)
        if subject_id < 10:
            subject_id = str("0" + str(subject_id))
        subject_text = str("E" + country_id + site_id + str(subject_id))
    else:
        subject.append(subject_text)

    pi_assessment_text = "."
    while pi_assessment_text != "Eligible" and pi_assessment_text != "Ineligible" and pi_assessment_text != "":
        pi_assessment_text = input("Enter the PI assessment of subject eligibility (Eligible/Ineligible/nothing): ")
        if pi_assessment_text != "Eligible" and pi_assessment_text != "Inclusion" and pi_assessment_text != "":
            print("ATTENTION: You must type Eligible or Ineligible or press enter if nothing!")
    pi_assessment.append(pi_assessment_text)

    pi_crit_text = "."
    while pi_crit_text != "Exclusion" and pi_crit_text != "Inclusion" and pi_crit_text != "":
        pi_crit_text = input("Enter the assessment criterion according to the PI (Exclusion/Inclusion/nothing): ")
        if pi_crit_text != "Exclusion" and pi_crit_text != "Inclusion" and pi_crit_text != "":
            print("ATTENTION: You must type Exclusion or Inclusion or press enter if nothing!")
    pi_crit.append(pi_crit_text)

    pi_crit_num_text = input("Enter the number of criterion from PI about eligibility: ")
    pi_crit_num.append(pi_crit_num_text)

    cm_assessment_text = "."
    while cm_assessment_text != "Exclusion" and cm_assessment_text != "Inclusion" and cm_assessment_text != "":
        cm_assessment_text = input("Enter the CM assessment of subject eligibility (Exclusion/Inclusion/nothing): ")
        if cm_assessment_text != "Exclusion" and cm_assessment_text != "Inclusion" and cm_assessment_text != "":
            print("ATTENTION: You must type Exclusion or Inclusion or press enter if nothing!")
    cm_assessment.append(cm_assessment_text)

    cm_desciption_text = input("Enter the description from CM about eligibility criterion: ")
    cm_desciption.append(cm_desciption_text)

    rand_date_text = input("Enter the randomization date: ")
    rand_date.append(rand_date_text)

    #Create a Database
    database = pd.DataFrame({"subject": subject,
                             "country": country,
                             "site": site,
                             "pi_assessment": pi_assessment,
                             "pi_crit": pi_crit,
                             "pi_crit_num": pi_crit_num,
                             "cm_assessment": cm_assessment,
                             "cm_desciption": cm_desciption,
                             "rand_date": rand_date})

    database.to_csv(r'/home/pawel/Pulpit/Programowanie/Python/Clinical Data Project/main_database.csv')

    return subject, country, site, pi_assessment, pi_crit, pi_crit_num, cm_assessment, cm_desciption, rand_date, database
database_generator()

def creating_files(filename, columns=[], col_names = []):
    data = []
    for i in columns:
        data.append(database[i])
    df = pd.concat(data, axis=1, keys=col_names)
    df[i].replace('', np.nan, inplace=True)
    df.dropna(subset=[i], inplace=True)
    path = str(r'/home/pawel/Pulpit/Programowanie/Python/Clinical Data Project/' + filename + '.csv')
    return df.to_csv(path)

creating_files('randomized', ['subject', 'rand_date'], ['subject', 'rand_date'])
creating_files('country', ['country', 'site'], ['country', 'site'])
creating_files('site', ['subject', 'site'], ['subject', 'site'])
creating_files('assessment_of_pi', ['subject', 'pi_assessment'], ['subject', 'pi_assessment'])
creating_files('criteria_of_pi', ['subject', 'pi_crit', 'pi_crit_num'], ['subject', 'pi_crit', 'pi_crit_num'])
creating_files('assessment_of_cm', ['subject', 'cm_assessment', 'cm_desciption'], ['subject', 'cm_assessment', 'cm_desciption'])

database = pd.read_csv (r'/home/pawel/Pulpit/Programowanie/Python/Clinical Data Project/data.csv')