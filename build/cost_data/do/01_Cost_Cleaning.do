/*****************************************************************
PROJECT: 	ODISHA SANITATION (AKA ORISSA)

PURPOSE: 	CLEAN COST DATA

AUTHORS: 	DEREK WOLFSON (IPA) 

INPUTS: 	endline cost survey
				dropbox/Cost Data/HH level/data
					sections a-e
					section d
								
OUTPUTS: 	TBD

*******************************************************************/

/************************************
PART 0 - SETTING GLOBALS
************************************/
if "`c(username)'"=="dwolfson"{
	gl data "X:\Sanitation - Orissa, India\Cost Data\HH level\data"
}


/*******************************
PART 2 - LOAD/CLEAN DATA
********************************/
use "$data\sections a-e.dta", clear
	*LABELS*
	label define YNMISS 1 "Yes" 2 "No" -999 "Don't know/refuse" -888 "N/A", modify


**SURVEY INFORMATION**
rename h1 enum_id
rename h2 survey_date
rename h3 svy_start_time
rename h4 svy_end_time
rename h5 hhid
rename h6 visit_result
rename h6a visit_result_specify

	note: N=388 but only 252 households complete the survey

*SECTION A - IDENTIFICATION**
*NO CLEANING NEEDED*

*SECTION B - COSTS OF BUILDING A LATRINE*
la values b1 YNMISS






* visit result - what are the different categories ? 
ta h6, m
note: 388 households - but only 252 continue

* respondent availability
ta a2, 

ta h6 a2, m

* someone else available 
ta a3

note: 206 + 48 =252 

* household owning a latrine
ta b1
note: all own a latrine 

* construction date
gen month_begin=""
replace month_begin=substr(b2,1,index(b2,"/"))

destring month_begin, replace ignore("/")
label var month_begin "Month: construction of latrine began"

gen splitat=strpos(b2, "/")

gen year_begin=""
replace year_begin=substr(b2, splitat, .)
ta year_begin

destring year_begin, ignore("/") replace

replace year_begin=2011 if year_begin==.&b2=="2011"
label var year_begin "Year: construction of latrine began"

drop splitat
ta year_begin		/* mostly built in 2011 */

* defining date
destring month_begin, replace
destring year_begin, replace

gen date_begin=ym(year_begin,month_begin)
format date_begin %tm

label var date_begin "Date: construction of latrine began"

foreach var in year_begin month_begin  {
	replace `var'=-999 if b2a==-999&`var'==.|b2=="-999"
	}

* is construction complete?
ta b3

* when was construction complete?
ta b4

gen month_finish=""
replace month_finish=substr(b4,1,index(b2,"/"))

ta month_finish
destring month_finish, ignore("/") replace

label var month_finish "Month: construction of latrine finished"

gen splitat=strpos(b4, "/")

gen year_finish=""
replace year_finish=substr(b4, splitat, .)
ta year_finish

destring year_finish, ignore("/") replace

replace year_finish=-999 if b4=="-999"
replace year_finish=-999 if b4=="02"
replace year_finish=2011 if b4=="2011"&year_finish==.
label var year_finish "Year: construction of latrine finished"

drop splitat

gen date_finish=ym(year_finish,month_finish)
format date_finish %tm


replace date_finish=. if year_finish==-999 | month_finish==-999
label var date_finish "Date: construction of latrine finished"

replace month_finish=-999 if b4=="-999"
replace month_finish=-999 if b4=="2011"& month_finish==.

* checking the dates
ed b2 b4 date_finish date_begin if date_finish<date_begin

note: 1 instance

gen flag_date=(date_finish<date_begin)
 replace flag_date=. if b2==""
 
label var flag_date "=1 if incorrect date of construction entry"

ed flag_date b2 b4

* average length of construction
gen constr_mths=date_finish-date_begin if flag_date==0
sum constr_mths, d

note: typically finish building the same month when started; median is 0 and mean is .8
label var constr_mths "Lengh of latrine construction: months"

* does latrine have a roof
ta b5

* received cash from NGO?
ta b6

note: mostly have not received cash

ta b7

ta b7a	/* no obs */

* purchased building materials?

ta b8

note: all purchased building materials

* bricks

ta b9aa		/* pretty much all bought bricks - 195 */

ta b9ba

sum b9ba, d

ta b10aa

ta b10ba 

ta b10ba if b10aa==.	/* note 3 obs have missing per unit price but not total price */
gen check= b10aa*b9ba
list check b10ba if check!=b10ba&check<.

note: very few cases


* stone

ta b9ab

ta b9bb

sum b9bb, d

ta b10ab

ta b10bb

ta b10bb if b10ab==.	/* note 4 obs have missing per unit price but not total price */

gen check=b9bb*b10ab
list check b10bb if check!=b10bb&check!=.

note: only 4 cases
drop check

* sand
ta b9ac			/* there are 2 measures here, E & D */

ta  b9bc






STOP HERE




note: need to create averages for village for missing unit prices; need to get village ids

egen ave_brick_price=mean(b10aa), by(village)











