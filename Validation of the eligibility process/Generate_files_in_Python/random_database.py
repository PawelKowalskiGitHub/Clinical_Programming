import random
import pandas as pd
import  numpy as np

country = []
site = []
subject = []
pi_assessment = []
pi_crit = []
pi_crit_num = []
cm_assessment = []
cm_desciption = []
rand_date = []

country_id = []
site_id = []
subject_id = []
subject_text = []
rand_pi_eli = ""


def random_gen_data(number_of_subjects):
    for i in range (1000):
        country_id = random.randrange(1, 11, 1)
        if country_id < 10:
            country_id = str("0" + str(country_id))
            country_id = str(country_id)
            country_text = str("country" + country_id)
            country.append(country_text)
        else:
            country_id = str(country_id)
            country_text = str("country" + country_id)
            country.append(country_text)
        site_id = random.randrange(500, 599, 1)
        site_id = str(site_id)
        site.append(site_id)
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

        text_pi = ['Eligible', 'Ineligible', '']
        rand_pi_eli = str(np.random.choice(text_pi, 1, p=[0.9, 0.09, 0.01]))
        rand_pi_eli = rand_pi_eli.strip("'[]'")
        pi_assessment.append(rand_pi_eli)

        text_pi_crit = ['Exclusion', 'Inclusion', '']
        rand_pi_crit = str(np.random.choice(text_pi_crit, 1, p=[0.04, 0.01, 0.95]))
        rand_pi_crit = rand_pi_crit.strip("'[]'")
        pi_crit.append(rand_pi_crit)

        text_pi_crit_num = ['1', '2', '3', '4', '5']
        if rand_pi_crit == "Exclusion":
            rand_pi_crit_num = str(np.random.choice(text_pi_crit_num, 1, p=[0.2, 0.2, 0.2, 0.2, 0.2]))
            rand_pi_crit_num = rand_pi_crit_num.strip("'[]'")
            rand_pi_crit_num = int(rand_pi_crit_num)
            pi_crit_num.append(rand_pi_crit_num)
        elif rand_pi_crit == "Inclusion":
            rand_pi_crit_num = '-'
            rand_pi_crit_num = rand_pi_crit_num.strip("'[]'")
            pi_crit_num.append(rand_pi_crit_num)
        else:
            pi_crit_num.append("")

        text_cm = ['Exclusion', 'Inclusion', '']
        rand_cm_eli = str(np.random.choice(text_cm, 1, p=[0.07, 0.03, 0.9]))
        rand_cm_eli = rand_cm_eli.strip("'[]'")
        cm_assessment.append(rand_cm_eli)

        text_cm_des = ['Missing data', 'Lack of data', 'Error in eligibility']
        if rand_cm_eli == 'Exclusion':
            rand_cm_des = str(np.random.choice(text_cm_des, 1, p=[0.34, 0.33, 0.33]))
            rand_cm_des = rand_cm_des.strip("'[]'")
            cm_desciption.append(rand_cm_des)
        elif rand_cm_eli == 'Inclusion':
            rand_cm_des = 'No exclusions'
            rand_cm_des = rand_cm_des.strip("'[]'")
            cm_desciption.append(rand_cm_des)
        else:
            cm_desciption.append('')

        yyyy = str(random.randrange(2019, 2020, 1))
        type(yyyy)
        mm = random.randrange(1, 12, 1)
        if mm < 10:
            mm = str("0" + str(mm))
        dd = random.randrange(1, 28, 1)
        if dd < 10:
            dd = str("0" + str(dd))
        date = str(yyyy) + "-" + str(mm) + "-" + str(dd)
        rand_date.append(date)


    df = pd.DataFrame({"subject": subject,
                        "country": country,
                        "site": site,
                        "pi_assessment": pi_assessment,
                        "pi_crit": pi_crit,
                        "pi_crit_num": pi_crit_num,
                        "cm_assessment": cm_assessment,
                        "cm_desciption": cm_desciption,
                        "rand_date": rand_date})

    return df.to_csv(r'/home/pawel/Pulpit/Programowanie/Python/Clinical Data Project/data.csv')

random_gen_data(1000)


