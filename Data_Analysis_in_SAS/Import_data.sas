/* Importing data to library */

/* Creating a library */
libname Analysis Clear;
libname Analysis '/folders/myfolders/Checking the correctness of eligibility';

PROC CONTENTS data=Analysis._all_ nods; 
RUN; 

/* ------------------------------------------------------ */
/* The second way */
/* Defining variables with general path, names of files to import (files) and names of imported files stored in the Eligibility library (names)*/
libname Analysis '/folders/myfolders/Checking the correctness of eligibility';

%let path  = /folders/myfolders/Checking the correctness of eligibility;
%let library = Analysis.;
%let files=%str(&path/randomized.csv, 
				&path/site.csv,
				&path/country.csv,
				&path/assessment_of_pi.csv,
				&path/assessment_of_cm.csv,
				&path/criteria_of_pi.csv);

%let names=%str(randomized, 
				site,
				country,
				assessment_of_pi,
				assessment_of_cm,
				criteria_of_pi);

/* Importing files using loop */
%MACRO DO_IMPORT(COUNT);
%DO i = 1 %TO (&COUNT);
	%let dset = %scan(&files, &i, ",");
	%let name = %scan(&names, &i, ",");
	PROC IMPORT DATAFILE="&dset"
		DBMS=CSV
		OUT=&library&&name
		REPLACE;
		GETNAMES=YES;
		GUESSINGROWS=900;
	RUN;
%END;
%MEND DO_IMPORT;

%DO_IMPORT(6);

PROC CONTENTS data=Analysis._all_ nods; 
RUN; 

/* ------------------------------------------------------ */
/* The third way */
libname Analysis '/folders/myfolders/Checking the correctness of eligibility';

%let path  = /folders/myfolders/Checking the correctness of eligibility/;
%let library = Analysis.;
%let file1 = randomized.csv;
%let name1 = Randomized;
%let file2 = country.csv;
%let name2 = Country;
%let file3 = site.csv;
%let name3 = Site;
%let file4 = assessment_of_pi.csv;
%let name4 = Assessment_of_pi;
%let file5 = assessment_of_cm.csv;
%let name5 = Assessment_of_cm;
%let file6 = criteria_of_pi.csv;
%let name6 = Criteria_of_pi;

%MACRO DO_IMPORT(COUNT);
%DO I = 1 %TO &COUNT;
	PROC IMPORT DATAFILE="&path&&file&I"
		DBMS=CSV
		OUT=&library&&name&I
		REPLACE;
		GETNAMES=YES;
		GUESSINGROWS=900;
	RUN;
%END;
%MEND DO_IMPORT;

%DO_IMPORT(6);

PROC CONTENTS data=Analysis._all_ nods; 
RUN; 
