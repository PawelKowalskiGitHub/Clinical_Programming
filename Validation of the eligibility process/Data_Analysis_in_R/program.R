library(tidyverse)

#<!-- Importing csv files -->
randomized = read.csv("randomized.csv", header = TRUE)
site = read.csv("site.csv", header = TRUE)
country = read.csv("country.csv", header = TRUE)
assessment_of_pi = read.csv("assessment_of_pi.csv", header = TRUE)
criteria_of_pi = read.csv("criteria_of_pi.csv", header = TRUE)
assessment_of_cm = read.csv("assessment_of_cm.csv", header = TRUE)
data = read.csv("data.csv", header = TRUE)


#<!-- Creating one dataset with all essential data for all randomized subjects -->
country_site <- data.frame(site["subject"], country["country"], country["site"])
dataset <- merge(x=randomized, y=country_site, by="subject", all.x=TRUE)[ ,c("subject", "country", "site")]
dataset <- merge(x=dataset, y=assessment_of_pi, by="subject", all.x=TRUE)[ ,c("subject","site", "country","pi_assessment")]
dataset <- merge(x=dataset, y=criteria_of_pi, by="subject", all.x=TRUE)[ ,c("subject","site", "country","pi_assessment", "pi_crit")]
dataset <- merge(x=dataset, y=assessment_of_cm, by="subject", all.x=TRUE)[ ,c("subject","site", "country","pi_assessment", "pi_crit", "cm_assessment")]
rm(country_site)
# Removing duplicates 
clear_dataset <- dataset %>% distinct(subject, .keep_all = TRUE)

# Adding new column "Eligibility"
clear_dataset$Eligibility <- NA

#<!-- Assignment of final eligibility for each randomized subject -->
add = character(0)
eligi = character(0)

for (i in 1:nrow(clear_dataset)){
  if ((clear_dataset$pi_assessment[i] %in% "Ineligible") || (clear_dataset$pi_assessment[i] %in% NA) || (clear_dataset$pi_crit[i] %in% "Exclusion") || (clear_dataset$cm_assessment[i] %in% "Exclusion")) {add = paste("Ineligible")} else {add = paste("Eligible")}
  add = add
  eligi = append(eligi, add)
}

clear_dataset$Eligibility <- eligi
rm(eligi); rm(add)


#<!-- CALCULATIONS -->

#<!-- - Study level -->

# number and ratio of incorrectly randomized (ineligible) subjects on study
all.subjects <- nrow(clear_dataset) # all randomized subjects
paste('Number of all subjects on study:' , all.subjects)
all.Ineligible <- nrow(clear_dataset[clear_dataset$Eligibility == "Ineligible",]) # all randomized ineligible subjects
paste('Number of incorrectly randomized (ineligible) subjects on study:' , all.Ineligible)
study.ratio <- all.Ineligible/all.subjects # ratio of incorrectly randomized (ineligible) subjects on study
paste('Ratio of incorrectly randomized (ineligible) subjects on study:' , study.ratio)


#<!-- - Country level -->

# number of subjects on country
all_sub_country <- apply(clear_dataset[3], 2, table)
all_sub_country <- data.frame(all_sub_country)

# renaming of columns
all_sub_country <- setNames(cbind(rownames(all_sub_country), all_sub_country, row.names = NULL), c("country", "freq_of_all"))


# creating a dataset storing only ineligible subjects
dataset.ineligi.only <- clear_dataset[clear_dataset$Eligibility == "Ineligible", ]

# number of incorrectly randomized (ineligible) subjects on country
ineligi_sub_country <- apply(dataset.ineligi.only[3], 2, table)
ineligi_sub_country <- data.frame(ineligi_sub_country)

# renaming of columns
ineligi_sub_country <- setNames(cbind(rownames(ineligi_sub_country), ineligi_sub_country, row.names = NULL), c("country", "freq_of_ineligible"))

# merging both tables
summary.country <- merge(x=all_sub_country, y=ineligi_sub_country, by="country", all.x=TRUE)

# adding ratio variable
summary.country$ratio <- summary.country$freq_of_ineligible/summary.country$freq_of_all


#<!-- - Site level -->

# number of subjects on site
all_sub_site <- apply(clear_dataset[2], 2, table)
all_sub_site <- data.frame(all_sub_site)

# renaming of columns
all_sub_site <- setNames(cbind(rownames(all_sub_site), all_sub_site, row.names = NULL), c("site", "freq_of_all"))


# creating a dataset storing only ineligible subjects
dataset.ineligi.only <- clear_dataset[clear_dataset$Eligibility == "Ineligible", ]

# number of incorrectly randomized (ineligible) subjects on site
ineligi_sub_site <- apply(dataset.ineligi.only[2], 2, table)
ineligi_sub_site <- data.frame(ineligi_sub_site)

# renaming of columns
ineligi_sub_site <- setNames(cbind(rownames(ineligi_sub_site), ineligi_sub_site, row.names = NULL), c("site", "freq_of_ineligible"))

# merging both tables
summary.site <- merge(x=all_sub_site, y=ineligi_sub_site, by="site", all.x=TRUE)

# adding ratio variable
summary.site$ratio <- summary.site$freq_of_ineligible/summary.site$freq_of_all


#<!-- TABLES AND FIGURES -->

# Table with summary of country level
summary.country

# Country with the greatest ratio 
the_country <- summary.country$country[which.max(summary.country$ratio)]
paste('The country with the max ratio is' , the_country)
plot.country <- ggplot(data=summary.country,
                       aes(x=country, y=ratio, fill = ratio,
                       )) + 
  geom_bar(stat = "identity") + scale_fill_continuous(type = "gradient") +
  xlab(colnames(summary.country)[1]) +
  ylab(colnames(summary.country)[3]) +
  ggtitle("Ratios of countries") 
plot.country

# Table with summary of site level
summary.site

# Site with the greatest ratio
the_site <- summary.site$site[which.max(summary.site$ratio)]
paste('The site with the max ratio is' , the_site)
plot.site <- ggplot(data=summary.site,
                    aes(x=site, y=ratio, fill = ratio,
                    )) + 
  geom_bar(stat = "identity") + scale_fill_continuous(type = "gradient") +
  xlab(colnames(summary.site)[1]) +
  ylab(colnames(summary.site)[3]) +
  ggtitle("Ratios of sites") 
plot.site

