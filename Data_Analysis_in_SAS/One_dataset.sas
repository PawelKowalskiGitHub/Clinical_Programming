/* Joining data to one dataset (called dataset) with all essential data, 
without duplicates and with an extra variable that defines finally eligibility of subject */

/* Creating the dataset and adding variables from each dataframe by macro */
DATA Analysis.dataset;
	SET Analysis.randomized;
RUN;

%MACRO Adding_variables(df_to_merge, sort_by);
	PROC SORT data=Analysis.dataset;BY &sort_by;RUN;
	PROC SORT data=Analysis.&df_to_merge;BY &sort_by;RUN;
	DATA Analysis.dataset;
	MERGE Analysis.dataset(in=T1) Analysis.&df_to_merge(in=T2);
	IF T1;
	by &sort_by;
	RUN;
%MEND Adding_variables;

%Adding_variables(SITE, subject);
%Adding_variables(COUNTRY, site);
%Adding_variables(ASSESSMENT_OF_PI, subject);
%Adding_variables(CRITERIA_OF_PI, subject);
%Adding_variables(ASSESSMENT_OF_CM, subject);

/* Keeping only necessary variables */
DATA Analysis.dataset;
	SET Analysis.dataset(keep=subject country site pi_assessment pi_crit cm_assessment);
RUN;

/* Removing duplicates */
PROC SORT DATA = Analysis.dataset
	OUT = Analysis.dataset
	NODUPKEY;
	BY subject ;
RUN;

/* Adding new column "Eligibility" to dataset */
DATA Analysis.dataset;
	SET Analysis.dataset;
	IF pi_assessment="Ineligible" or pi_crit="Exclusion" or cm_assessment="Exclusion" THEN Eligibility="Ineligible";
	ELSE IF pi_assessment=" " and pi_crit=" " and cm_assessment=" " THEN Eligibility="Ineligible";
	ELSE Eligibility="Eligible";
RUN;

/* Changing the order of the columns country with site */
DATA Analysis.dataset;
   RETAIN subject country site pi_assessment pi_crit cm_assessment Eligibility;
   SET Analysis.dataset;
RUN;

PROC SORT DATA=Analysis.dataset;
	BY country site;
RUN;

