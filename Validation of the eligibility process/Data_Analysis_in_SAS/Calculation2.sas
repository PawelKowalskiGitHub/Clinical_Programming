/* STUDY LEVEL */
/* number and ratio of incorrectly randomized (ineligible) subjects on study */
PROC SQL;
	CREATE TABLE All_subjects_study AS (
		SELECT count(*) AS Number_of_all_subject FROM Analysis.dataset);
	CREATE TABLE Ineligible_subjects_study AS (	
		SELECT count(*) AS Number_of_ineligible_subject FROM Analysis.dataset WHERE Eligibility="Ineligible");
	CREATE TABLE Ratio_study AS (
		SELECT Number_of_ineligible_subject/Number_of_all_subject as Ratio FROM Ineligible_subjects_study, All_subjects_study);
quit;


PROC SORT DATA=Analysis.dataset; BY Eligibility; RUN;
PROC FREQ data=Analysis.dataset NOPRINT;
	title "Frequency of all randomized (eligible and ineligible) subjects.";
	TABLE Eligibility / OUT=study_sum_up NOPERCENT NOCUM;
	WHERE Eligibility="Ineligible" OR Eligibility="Eligible";
RUN;

DATA study_sum_up;
	RENAME COUNT=Number_of_subjects;
	SET study_sum_up (drop=Percent);
RUN;

PROC PRINT DATA=study_sum_up NOOBS;
	title "Number of incorrectly randomized (ineligible) subjects on study";
	SUM Number_of_subjects;
RUN;
	
title "Ratio of incorrectly randomized (ineligible) subjects on study";
PROC PRINT DATA=Ratio_study NOOBS; RUN;


/* COUNTRY AND SITE LEVEL */
/* MACRO for find frequency and rename a COUNT column */
%MACRO SUB_FREQ(var_by, output, new_var_name, condition1 = "Eligible", condition2 = "Ineligible");
	PROC SORT DATA=Analysis.dataset;
	BY &var_by;
	PROC FREQ DATA=Analysis.dataset NOPRINT;
	TABLE &var_by / Out=&output NOPERCENT NOCUM;
	WHERE Eligibility=&condition1 or Eligibility=&condition2;
	RUN;
	DATA &output;
	RENAME COUNT=&new_var_name;
	SET &output (drop=Percent);
	RUN;
%MEND SUB_FREQ;

/* Frequency of all subjects in each country */
%SUB_FREQ(country, country_all_subjects, Numbers_of_all_subjects);
/* Frequency of ineligible subjects in each country */
%SUB_FREQ(country, country_inelig_subjects, Numbers_of_ineligible_subjects, condition1 = "Ineligible");
/* Frequency of all subjects in each country */
%SUB_FREQ(site, site_all_subjects, Numbers_of_all_subjects);
/* Frequency of ineligible subjects in each country */
%SUB_FREQ(site, site_inelig_subjects, Numbers_of_ineligible_subjects, condition1 = "Ineligible");

/* Computing the ratio only for observations with ineligible subjects. First, combining datasets. */
DATA country_sum_up; SET country_all_subjects; RUN;
DATA site_sum_up; SET site_all_subjects; RUN;
%MACRO CAL_RATIO(output, left_df, right_df, var_by, ratio_fun, ineli_col);
	DATA &output;
		MERGE &left_df(in=T1) &right_df(in=T2);
		IF T1;
		BY &var_by;
	RUN;
	DATA &output;
		SET &output;
		Ratio = &ratio_fun;
		WHERE &ineli_col is NOT NULL;
	RUN;
%MEND CAL_RATIO;

%CAL_RATIO(country_sum_up, country_all_subjects, country_inelig_subjects, country, Numbers_of_ineligible_subjects/Numbers_of_all_subjects, Numbers_of_ineligible_subjects);
%CAL_RATIO(site_sum_up, site_all_subjects, site_inelig_subjects, site, Numbers_of_ineligible_subjects/Numbers_of_all_subjects, Numbers_of_ineligible_subjects);

/* Printing summary for country */
title "Numbers and ratios for countries";
PROC PRINT data=country_sum_up; run;

/* Country with max ratio */
PROC SQL;
	title "Name and ratio of country with the most ratio of incorrectly randomized (ineligible) subjects.";
	SELECT country, max(Ratio) as max_ratio FROM country_sum_up
		HAVING Ratio=max(Ratio);
quit;
/* Printing summary for site */
title "Numbers and ratios for sites";
PROC PRINT data=site_sum_up; run;

/* Site with max ratio */
PROC SQL;
	title "Name and ratio of site with the most ratio of incorrectly randomized (ineligible) subjects.";
	SELECT site, max(Ratio) as max_ratio FROM site_sum_up
		HAVING Ratio=max(Ratio);
quit;

