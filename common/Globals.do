*STEP 1: SET CURRENT DIRECTORY & DROPBOX LOCAL*
	*Type -creturn list- to get your `c(username)' value*
	*Must be set for each user*
	
if "`c(username)'"=="dwolfson" {
	cd "Y:\Classen_Sanitation"
	global DB ""
	}
*

	**CHECK THAT DIRECTORY IS SET** 
	if substr("`c(pwd)'",-18,.)!="Classen_Sanitation" {
		di as error  	"Set your working directory to the Github Classen_Sanitation Folder" _n ///
						"For example: C:/Users/dw/documents/github/Classen_Sanitation" _n ///
						"Be sure to include this global in your user-specific path in STEP 1 of globals.do"
						exit
	}
