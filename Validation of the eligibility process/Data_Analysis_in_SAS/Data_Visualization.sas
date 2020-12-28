/* Data visualization */
/* STUDY LEVEL */
title "Number of incorrectly randomized (ineligible) subjects on study";
PROC FREQ data=Analysis.dataset;
	TABLES Eligibility / NOCUM NOPERCENT;
	WHERE Eligibility = "Ineligible";
RUN;

title "Ratio of incorrectly randomized (ineligible) subjects on study";	
PROC SQL;
	CREATE TABLE study_table_plot AS (
		SELECT ratio FROM Ratio_study);
quit;

PROC PRINT data=study_table_plot NOOBS;
RUN;


/* COUNTRY AND SITE LEVEL */

/* Macro to creating plots of numbers in(eligible) subjects for country and site */
%MACRO Num_eligibility_plot(vbar_var, range_from, range_to);
	PROC SGPLOT DATA=Analysis.dataset;
	vbar &vbar_var / group = Eligibility ;
	WHERE &vbar_var BETWEEN &range_from AND &range_to;
	title "Number of randomized (eligible and ineligible) subjects on &vbar_var (for &vbar_var from &range_from to &range_to)";
	RUN;
%MEND Num_eligibility_plot;

/* Macro to creating plots of ratios for country and site */
%MACRO Ratio_eligibility_Plot(vbar_var, tab_name, range_from, range_to);
	PROC SGPLOT DATA=&tab_name;
	vbar &vbar_var / response=ratio;
	WHERE &vbar_var BETWEEN &range_from AND &range_to;
	title "Ratio of incorrectly randomized (ineligible) subjects on &vbar_var (for &vbar_var from &range_from to &range_to)";
	yaxis label='ratio';
	RUN;
%MEND Ratio_eligibility_Plot;

/* COUNTRY LEVEL */
title "Number of incorrectly randomized (ineligible) subjects on country";
PROC FREQ data=Analysis.dataset;
	TABLES country / NOCUM NOPERCENT;
	WHERE Eligibility = "Ineligible";
RUN;

%Num_eligibility_plot(country, 'country01', 'country10');

title "Ratio of incorrectly randomized (ineligible) subjects on country";
PROC SQL;
	CREATE TABLE country_table_plot AS (
		SELECT country, ratio FROM Analysis.summary_country WHERE ratio is NOT NULL);
quit;

PROC PRINT data=country_table_plot;
RUN;

%Ratio_eligibility_Plot(country, country_table_plot, 'country01', 'country10');


/* SITE LEVEL */
title "Number of incorrectly randomized (ineligible) subjects on site";
PROC FREQ data=Analysis.dataset;
	TABLES site / NOCUM NOPERCENT;
	WHERE Eligibility = "Ineligible";
RUN;

%Num_eligibility_plot(site, 500, 524);
%Num_eligibility_plot(site, 525, 549);
%Num_eligibility_plot(site, 550, 574);
%Num_eligibility_plot(site, 575, 599);

title "Ratio of incorrectly randomized (ineligible) subjects on site";
PROC SQL;
	CREATE TABLE site_table_plot AS (
		SELECT site, ratio FROM Analysis.summary_site WHERE ratio is NOT NULL);
quit;

PROC PRINT data=site_table_plot NOOBS;

%Ratio_eligibility_Plot(site, site_table_plot, 500, 524);
%Ratio_eligibility_Plot(site, site_table_plot, 525, 549);
%Ratio_eligibility_Plot(site, site_table_plot, 550, 574);
%Ratio_eligibility_Plot(site, site_table_plot, 575, 599);

