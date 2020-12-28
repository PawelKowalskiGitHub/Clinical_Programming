/* STUDY LEVEL */
/* number and ratio of incorrectly randomized (ineligible) subjects on study */
PROC SQL;
	CREATE TABLE All_subjects_study AS (
		SELECT count(*) AS Number_of_all_subject FROM Analysis.dataset);
	CREATE TABLE Ineligible_subjects_study AS (	
		SELECT count(*) AS Number_of_ineligible_subject FROM Analysis.dataset WHERE Eligibility="Ineligible");
	title "Ratio of incorrectly randomized (ineligible) subjects on study";
	CREATE TABLE Ratio_study AS (
		SELECT Number_of_ineligible_subject/Number_of_all_subject as Ratio FROM Ineligible_subjects_study, All_subjects_study);
	SELECT Ratio as ratio FROM Ratio_study;
quit;


/* COUNTRY LEVEL */
/* number and ratio of incorrectly randomized (ineligible) subjects on country */
PROC SQL;
	CREATE TABLE country_all_subject AS (
		SELECT country, count(subject) AS country_all_subject FROM Analysis.dataset
		GROUP BY country);
	CREATE TABLE country_ineligible_subject AS (
		SELECT country, count(subject) AS country_ineligible_subject FROM Analysis.dataset WHERE Eligibility="Ineligible"
		GROUP BY country);
	CREATE TABLE Summary_country AS (	
	SELECT a.country, country_all_subject, country_ineligible_subject FROM country_all_subject as a
		LEFT JOIN country_ineligible_subject as b ON a.country=b.country);
	CREATE TABLE Analysis.Summary_country AS (
		SELECT  country, country_all_subject as all_subjects, country_ineligible_subject as ineligible_subjecst, country_ineligible_subject/country_all_subject AS ratio FROM Summary_country);	
	title "Name and ratio of country with the most ratio of incorrectly randomized (ineligible) subjects";
	SELECT country, max(ratio) as max_ratio FROM Analysis.Summary_country
		HAVING ratio=max(ratio);
quit;

title "Numbers and ratios for all countries";
PROC PRINT data=Analysis.summary_country; run;


/* SITE LEVEL */
/* number and ratio of incorrectly randomized (ineligible) subjects on site */
PROC SQL;
	CREATE TABLE site_all_subject AS (
		SELECT site, count(subject) AS site_all_subject FROM Analysis.dataset
		GROUP BY site);
	CREATE TABLE site_ineligible_subject AS (
		SELECT site, count(subject) AS site_ineligible_subject FROM Analysis.dataset WHERE Eligibility="Ineligible"
		GROUP BY site);
	CREATE TABLE Summary_site AS (
		SELECT a.site, site_all_subject, site_ineligible_subject FROM site_all_subject as a
		LEFT JOIN site_ineligible_subject as b ON a.site=b.site);
	CREATE TABLE Analysis.Summary_site AS (
		SELECT  site, site_all_subject as all_subjects, site_ineligible_subject as ineligible_subjects, site_ineligible_subject/site_all_subject AS ratio FROM Summary_site);	
	title "Name and ratio of site with the most ratio of incorrectly randomized (ineligible) subjects.";
	SELECT site, max(ratio) as max_ratio FROM Analysis.Summary_site
		HAVING ratio=max(ratio);
quit;

title "Numbers and ratios for all sites";
PROC PRINT data=Analysis.summary_site; WHERE ineligible_subjects IS NOT NULL; run;

