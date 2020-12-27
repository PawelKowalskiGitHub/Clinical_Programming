/*Listings: */
******************************************************************************************
*Program name: listing.sas
*Output name: sas_listing01.txt
*Title: Eligibility information - listing
*******************************************************************************************/;
option ls=120 nocenter nodate nonumber; title;

PROC PRINTTO 
	print='/folders/myfolders/Checking the correctness of eligibility/sas_listing01.txt' 
	log='/folders/myfolders/Checking the correctness of eligibility/sas_listing01_log.txt';
RUN;

PROC REPORT DATA=Analysis.dataset headskip headline split='*';
	column ('--' subject country site pi_assessment pi_crit cm_assessment Eligibility);
	define country / width=10 order;
	define site / width=15 order;
	define subject / 'subject_id' width=15;
	define pi_assessment / width=15; 
	define pi_crit / width=15; 
	define cm_assessment / width=15;
	define Eligibility / width=15;  
	break after country / skip;
	compute before _page_;
	line @10 'NR0000-000'  @95 'sas_listing01';
	line '';
	line '';
	line @40 'Eligibility information - listing';
	line '';
	endcomp;
	compute after _page_;
	line @1 120*'-';
	line '';
	endcomp;
RUN;
