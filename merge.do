/*This code does the following: assigns 1910 counties to postal savings data,
merges demographic data*/

use all_states_v3.dta, clear

egen ID1 = concat( var1 var15), punc(-)
*deal with Kamiah-ID* 
drop _merge
save merge.dta, replace


use postalsaving_matched_Final.dta, clear

*creating a unique ID variable for merging
egen ID1 = concat(  feature_name  state_alpha), punc(-)


/*there are two repeats (Kamaih, ID and Washington, CT). 
Kamaih is due to a error in the merge. Washington included Washington and 
Washington Depot. */

gen num = _n
sort ID1
bysort ID1: egen rank = rank(num)
drop if rank==2
drop  num rank 
merge 1:1 ID1 using merge.dta
drop _merge
gen num = _n

*dropping if missing county data 
drop if missing( store_feature_name)

egen ID2 = concat(  feature_name_official  state_alpha), punc(-)
sort ID2
bysort ID2: egen rank = rank(num)
drop if rank==2
drop  num rank 

save merge.dta, replace

*1910 Counties from the spreadsheet postoffice_counties1910.csv
use 1910_counties.dta, clear

egen ID2 = concat(  feature_name state_alpha), punc(-)

*same repeats as before, with the addition of Grass Valley, CA
*I don't know why this is a repeat
gen num = _n
sort ID2
bysort ID2: egen rank = rank(num)
drop if rank==2
drop  num rank 

merge 1:1 ID2 using merge.dta

*3 obs didn't merge. 2 are Paia, HI. These commands fix that
replace  nhgisst=155 if  feature_id==362968
replace   nhgiscty=95 if  feature_id==362968
replace    icpsrst="82" if  feature_id==362968
*this drops the redundent Paia
drop if _merge ==1
/*the other is Nargansette Pier, RI. It was and is 
in Washtington County, as the only changes were the switch of 
Block Island into Washington County*/
replace  nhgisst=440 if  feature_id==1219895
replace   nhgiscty=50 if  feature_id==1219895
replace    icpsrst="5" if  feature_id==1219895
drop _merge var15

egen ID3 = concat( icpsrst county_numeric), punc(-)
save merge.dta, replace


*********1910 Variables Being kept*****************
/*variables being kept: State Code, County Code, State Name, Census Region 9,
Census Region 5, Population, Urban Pop 25K, Urban Pop 2.5K, area 
Rural, "Other" Races, Total Foreign Born White, Total Native White with Foreign Parents
Total Female, Total Male, White Male, White Female, Black Male, 
Black Female,, Total Pop Over Age 10, Total Illiterate Pop Over Age 10, Dwellings,
Families, Value of Crops, Value of Cereals, Number of Farms, Owner-operated farms, 
Total Homes, Total Farmhomes, Mortgaged Farmhomes, Nonfarm Homes, 
Mortgaged Nonfarm Homes, Total White Pop */
clear all

insheet using Export_US_county_1910_conflated_b1910_Int.csv, comma

rename icpsrfip fips1910
rename area_sqmi  area_sqmi1910

collapse (sum) area_sqmii, by(fips1910  area_sqmi1910 fips1910)
gen percent =  area_sqmii/area_sqmi1910

drop if fips1910 == 0 | fips1910 == 0 | fips1910 == . | fips1910 == .
*drop if percent < 0.01 \\\ Don't bother to do this because if it is small anyway who cares

gen fips = fips1910
sort fips

merge m:m fips using 1910Data.dta
keep if _merge == 3 | floor(fips) == 11001
drop _merge

foreach var of varlist totpop  urb25 area urb1910 rur1910 ///
othraces nwfptot fbwtot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothomes tfarmhom fhencumb tothhome ohencumb whtot  {
	*I am not replacing the ID variables if they are missing.
	if !inlist("`var'", "state", "county", "name", "fips", "statefip", "year") {
		replace `var' = -100000000000000000000000 if `var'==. & percent>=0.01
		replace `var' = 0 if `var'==. & percent<0.01
}
}

foreach var of varlist totpop  urb25 area urb1910 rur1910 ///
othraces nwfptot fbwtot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothomes tfarmhom fhencumb tothhome ohencumb whtot {
	if !inlist("`var'", "state", "county", "name", "fips", "statefip", "year") {
		replace `var' = `var'*percent
}
}
replace county = county/10
egen ID3 = concat(state county), punc(-)
drop if ID3=="40-510"

replace fips1910 = round(fips1910, 0.1)
*Assume all of DC is one place
replace fips1910 = 11001 if floor(fips1910)==11001
replace fips1910 = 11001 if floor(fips1910)==11001
*Assume all of Alexandria, VA is one place.
replace fips1910 = 51013 if fips1910 == 51510

collapse (sum) totpop  urb25 area urb1910 rur1910 ///
othraces nwfptot fbwtot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothomes tfarmhom fhencumb tothhome ohencumb whtot  ///
	, by(fips1910 ID3 state)

*Change back to missing if it use to be missing.	
foreach var of varlist totpop  urb25 area urb1910 rur1910 ///
othraces nwfptot fbwtot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothomes tfarmhom fhencumb tothhome ohencumb whtot  {
replace `var' = . if `var' < 0
}

compress

rename urb1910 urb_1910 
rename rur1910 rur_1910

*relabeling each variable so it is identidied as 1910
foreach var of varlist area urb25 totpop ///
othraces nwfptot fbwtot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothomes tfarmhom fhencumb tothhome ohencumb whtot {
rename `var' `var'_1910
}

save 1910trimmed.dta, replace

clear all
insheet using Export_US_county_1920_conflated_b1910_Int.csv, comma
rename area_sqmi  area_sqmi1920
rename icpsrfip fips1920
rename icpsrfip_1 fips1910
collapse (sum) area_sqmii, by(fips1920  area_sqmi1920 fips1910)
gen percent =  area_sqmii/area_sqmi1920
drop if fips1910 == 0 | fips1920 == 0 | fips1910== . | fips1920 == .
gen fips = fips1920
sort fips
merge m:m fips using 1920Data.dta
keep if _merge == 3 | floor(fips) == 11001
drop _merge

*1920

/*keeping only the variables outlined above, witt the following exceptions:
fbwtot is not present, but  fbwmtot fbwftot (male and female) allows us to create this
tothomes is now tothom
tfarmhom fhencumb tothhome ohencumb are missing, only  tothom ownmort (total homes and mortgaged homes)
manufacturing output is present,  mfgout
the # of manufacturing establishments is present,  mfgestab
the totl manufacturing wages are present, mfgwages */
foreach var of varlist totpop  urb25 area urb920 rur920 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothom ownmort whtot  mfgwages mfgestab mfgout {
	*I am not replacing the ID variables if they are missing.
	if !inlist("`var'", "state", "county", "name", "fips", "statefip", "year") {
		replace `var' = -100000000000000000000000 if `var'==. & percent>=0.01
		replace `var' = 0 if `var'==. & percent<0.01
}
}

foreach var of varlist totpop  urb25 area urb920 rur920 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothom ownmort whtot  mfgwages mfgestab mfgout {
	if !inlist("`var'", "state", "county", "name", "fips", "statefip", "year") {
		replace `var' = `var'*percent
}
}

replace fips1910 = round(fips1910, 0.1)
*Assume all of DC is one place
replace fips1920 = 11001 if floor(fips1920)==11001
replace fips1910 = 11001 if floor(fips1910)==11001
*Assume all of Alexandria, VA is one place.
replace fips1910 = 51013 if fips1910 == 51510

collapse (sum)  totpop  urb25 area urb920 rur920 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothom ownmort whtot  mfgwages mfgestab mfgout ///
	, by(fips1910)
	
foreach var of varlist totpop  urb25 area urb920 rur920 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothom ownmort whtot  mfgwages mfgestab mfgout {
replace `var' = . if `var' < 0
}

*renaming variables to align with 1910
rename tothom tothomes_1920
rename urb920 urb_1920
rename rur920 rur_1920
*there are 12 missing values for either fbwmtot or fbwftot
gen fbwtot_1920 = fbwmtot + fbwftot

foreach var of varlist urb25 area totpop ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothom ownmort whtot mfgwages mfgestab mfgout {
rename `var' `var'_1920
}

compress
merge 1:1 fips1910 using 1910trimmed.dta
drop _merge
save 1910trimmed.dta, replace

*year 1930
clear
insheet using Export_US_county_1930_conflated_b1910_Int.csv, comma
rename area_sqmi  area_sqmi1930
rename icpsrfip fips1930
rename icpsrfip_1 fips1910
collapse (sum) area_sqmii, by(fips1930  area_sqmi1930 fips1910)
gen percent =  area_sqmii/area_sqmi1930
drop if fips1910 == 0 | fips1930 == 0 | fips1910== . | fips1930 == .
gen fips = fips1930
sort fips
merge m:m fips using 1930Data.dta
keep if _merge == 3 | floor(fips) == 11001
drop _merge

/*keeping only the variables outlined above, witt the following exceptions:
rur1930 must be constructed from totpop and urb1930
no number of dwelling, no number of families, or data about homes */


foreach var of varlist totpop  urb25 area urb930 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  cropval cerealva farms farmfown ///
whtot mfgwages mfgestab mfgout  {
	*I am not replacing the ID variables if they are missing.
	if !inlist("`var'", "state", "county", "name", "fips", "statefip", "year") {
		replace `var' = -100000000000000000000000 if `var'==. & percent>=0.01
		replace `var' = 0 if `var'==. & percent<0.01
}
}


foreach var of varlist totpop  urb25 area urb930 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  cropval cerealva farms farmfown ///
whtot mfgwages mfgestab mfgout {
	if !inlist("`var'", "state", "county", "name", "fips", "statefip", "year") {
		replace `var' = `var'*percent
}
}

replace fips1910 = round(fips1910, 0.1)
*Assume all of DC is one place
replace fips1930 = 11001 if floor(fips1930)==11001
replace fips1910 = 11001 if floor(fips1910)==11001
*Assume all of Alexandria, VA is one place.
replace fips1910 = 51013 if fips1910 == 51510

collapse (sum)   totpop  urb25 area urb930 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  cropval cerealva farms farmfown  ///
	, by(fips1910)
	
foreach var of varlist  totpop  urb25 area urb930 ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  cropval cerealva farms farmfown  {
replace `var' = . if `var' < 0
}


rename farmfown farmown_1930
rename urb930 urb_1930
gen rur_1930 = totpop-urb_1930

foreach var of varlist totpop  urb25 area  ///
othraces nwfptot fbwmtot fbwftot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  cropval cerealva farms ///
{
rename `var' `var'_1930
}
merge 1:1 fips1910 using 1910trimmed.dta
compress

drop _merge
rename tothomes_1920_1920 tothomes_1920
save 1910trimmed.dta, replace

merge 1:m ID3 using merge.dta

keep if _merge==3

drop _merge var1 var11 ID1 ID2 ID3

rename  people1919 people_1919
rename  depo1919 depo_1919
rename  people1920 people_1920
rename  depo1920 depo_1920
rename  depo1921 depo_1921
rename  people1921 people_1921
gen   fbwtot_1930 = fbwmtot_1930+fbwftot_1930

reshape long area_ cerealva_ cropval_ depo_ dwell_ families_ farmown_  ///
farms_ fbwftot_ fbwtot_ fhencumb_ ftot_ mfgestab_ mfgout_ mfgwages_ ///
 mtot_ negftot_ negmtot_ nwfptot_ ohencumb_ othraces_  ownmort_ ///
 people_ rur_ t10tot_ tfarmhom_ tillit10_ tothhomes_ totpop_ urb_ ///
 urb25_ wftot_ whtot_ wmtot_ tothomes_ , ///
 i(fips1910  feature_id state_numeric  feature_name) j(year)

foreach var of varlist area_ cerealva_ cropval_ depo_ dwell_ families_ farmown_  ///
farms_ fbwftot_ fbwtot_ fhencumb_ ftot_ mfgestab_ mfgout_ mfgwages_ ///
 mtot_ negftot_ negmtot_ nwfptot_ ohencumb_ othraces_  ownmort_ ///
 people_ rur_ t10tot_ tfarmhom_ tillit10_ tothhomes_ totpop_ urb_ ///
 urb25_ wftot_ whtot_ wmtot_ {
 replace `var' = 0 if missing(`var')
 }
 
 foreach var of varlist area_ cerealva_ cropval_ depo_ dwell_ families_ farmown_  ///
farms_ fbwftot_ fbwtot_ fhencumb_ ftot_ mfgestab_ mfgout_ mfgwages_ ///
 mtot_ negftot_ negmtot_ nwfptot_ ohencumb_ othraces_  ownmort_ ///
 people_ rur_ t10tot_ tfarmhom_ tillit10_ tothhomes_ totpop_ urb_ ///
 urb25_ wftot_ whtot_ wmtot_ {
 gen `var'1910 = `var' if year==1910
 gen `var'1920 = `var' if year==1920
 gen `var'1930 = `var' if year==1930
 }
 
  foreach var of varlist  area_1910- wmtot_1930{
 replace `var' = 0 if missing(`var')
 }

   foreach var of varlist  area_1910- wmtot_1930{
   egen `var'max = max(`var'), by( feature_id)
drop `var' 
 }
 
 
 foreach string in area rur totpop urb25  cerealva cropval farmown farms mtot ///
  t10tot  othraces   fbwftot {
gen `string' =  `string'_1910max if year==1910
replace `string' =  3*(`string'_1920max- `string'_1910max)/10 +  `string'_1910max if year==1913
replace `string' =  4*(`string'_1920max- `string'_1910max)/10 +  `string'_1910max if year==1914
replace `string' =  5*(`string'_1920max- `string'_1910max)/10 +  `string'_1910max if year==1915
replace `string' =  6*(`string'_1920max- `string'_1910max)/10 +  `string'_1910max if year==1916
replace `string' =  7*(`string'_1920max- `string'_1910max)/10 +  `string'_1910max if year==1917
replace `string' =  8*(`string'_1920max- `string'_1910max)/10 +  `string'_1910max if year==1918
replace `string' =  9*(`string'_1920max- `string'_1910max)/10 +  `string'_1910max if year==1919
replace `string' =  `string'_1920max if year==1920
replace `string' =  (`string'_1930max- `string'_1920max)/10 +  `string'_1920max if year==1921
}

*deposit Insurance
gen insurance = 0
replace insurance = 1 if state_alpha=="MS" & year>1914
replace insurance = 1 if state_alpha=="ND" & year>1916
replace insurance = 1 if state_alpha=="SD" & year>1914

gen interest_rate = .
replace interest_rate = 7.3 if state_alpha=="ME" & year==1913
replace interest_rate = 7.2 if state_alpha=="ME" & year==1914
replace interest_rate = 7.1 if state_alpha=="ME" & year==1915
replace interest_rate = 7.0 if state_alpha=="ME" & year==1916
replace interest_rate = 6.8 if state_alpha=="ME" & year==1917
replace interest_rate = 6.5 if state_alpha=="ME" & year==1918
replace interest_rate = 6.4 if state_alpha=="ME" & (year==1919|year==1920|year==1921)
replace interest_rate = 6.5 if state_alpha=="ME" & year==1922
replace interest_rate = 6.6 if state_alpha=="ME" & (year==1923|year==1924)

replace interest_rate = 5.1 if state_alpha=="NH" & (year==1913|year==1914|year==1915|year==1919 ///
|year==1916|year==1920|year==1921|year==1923)
replace interest_rate = 5.0 if state_alpha=="NH" & (year==1917|year==1918)
replace interest_rate = 5.2 if state_alpha=="NH" & (year==1922|year==1924)

replace interest_rate = 5.3 if state_alpha=="VT" & (year==1913|year==1915|year==1916|year==1917 ///
|year==1921|year==1923|year==1924)
replace interest_rate = 5.2 if state_alpha=="VT" & (year==1914|year==1918|year==1919|year==1920 ///
|year==1922)

replace interest_rate = 5.3 if state_alpha=="MA" & year>1912 & year<1918
replace interest_rate = 5.4 if state_alpha=="MA" & year>1917 & year<1920
replace interest_rate = 5.5 if state_alpha=="MA" & year==1920
replace interest_rate = 5.6 if state_alpha=="MA" & year==1921
replace interest_rate = 5.7 if state_alpha=="MA" & year==1922
replace interest_rate = 5.8 if state_alpha=="MA" & year==1923
replace interest_rate = 5.9 if state_alpha=="MA" & year==1924


replace interest_rate = 5.6 if state_alpha=="RI" & year==1913
replace interest_rate = 5.7 if state_alpha=="RI" & (year==1914|year==1915|year==1916|year==1919)
replace interest_rate = 5.8 if state_alpha=="RI" & (year==1917|year==1918|year==1920|year==1921)
replace interest_rate = 6.0 if state_alpha=="RI" & (year==1922|year==1923|year==1924)

replace interest_rate = 5.5 if state_alpha=="NY" & year>1912 & year<1919
replace interest_rate = 5.6 if state_alpha=="NY" & year>1918 & year<1923
replace interest_rate = 5.7 if state_alpha=="NY" & year>1922 & year<1925

replace interest_rate = 5.5 if state_alpha=="NJ" & (year==1913|year==1919|year==1920)
replace interest_rate = 5.4 if state_alpha=="NJ" & (year==1914|year==1915)
replace interest_rate = 5.6 if state_alpha=="NJ" & (year==1916|year==1918)
replace interest_rate = 5.7 if state_alpha=="NJ" & (year==1917|year==1921)
replace interest_rate = 5.8 if state_alpha=="NJ" & year==1922
replace interest_rate = 5.9 if state_alpha=="NJ" & (year==1923|year==1924)

replace interest_rate = 5.4 if state_alpha=="PA" &  year>1912 & year<1920
replace interest_rate = 5.5 if state_alpha=="PA" &  (year==1920|year==1921)
replace interest_rate = 5.6 if state_alpha=="PA" &  year==1922
replace interest_rate = 5.7 if state_alpha=="PA" &  year==1923
replace interest_rate = 5.8 if state_alpha=="PA" &  year==1924

replace interest_rate = 5.8 if state_alpha=="OH" & (year==1913|year==1916|year==1918|year==1919)
replace interest_rate = 5.9 if state_alpha=="OH" & (year==1914|year==1915|year==1917|year==1920)
replace interest_rate = 6.0 if state_alpha=="OH" & year==1921
replace interest_rate = 6.1 if state_alpha=="OH" & year==1922
replace interest_rate = 6.2 if state_alpha=="OH" & (year==1923|year==1924)

replace interest_rate = 5.8 if state_alpha=="IN" & (year==1913|year==1914|year==1915|year==1916 ///
|year==1918|year==1920)
replace interest_rate = 5.7 if state_alpha=="IN" & (year==1917|year==1919)
replace interest_rate = 5.9 if state_alpha=="IN" & year==1921
replace interest_rate = 6.0 if state_alpha=="IN" & year==1922
replace interest_rate = 6.1 if state_alpha=="IN" & (year==1923|year==1924)

replace interest_rate = 5.4 if state_alpha=="IL" & (year==1913|year==1914)
replace interest_rate = 5.5 if state_alpha=="IL" & year>1914 & year<1919
replace interest_rate = 5.6 if state_alpha=="IL" & year==1919
replace interest_rate = 5.7 if state_alpha=="IL" & (year==1920|year==1921)
replace interest_rate = 5.9 if state_alpha=="IL" & year==1922
replace interest_rate = 6.0 if state_alpha=="IL" & (year==1923|year==1924)

replace interest_rate = 5.4 if state_alpha=="WI" & (year==1913|year==1914)
replace interest_rate = 5.5 if state_alpha=="WI" & year>1914 & year<1921
replace interest_rate = 5.6 if state_alpha=="WI" & (year==1921|year==1922)
replace interest_rate = 5.8 if state_alpha=="WI" & (year==1923|year==1924)

replace interest_rate = 5.7 if state_alpha=="MN" & year==1913
replace interest_rate = 5.6 if state_alpha=="MN" & year==1914
replace interest_rate = 5.7 if state_alpha=="MN" & year>1914 & year<1922
replace interest_rate = 5.9 if state_alpha=="MN" & year>1921 & year<1924
replace interest_rate = 6.0 if state_alpha=="MN" & year==1924

replace interest_rate = 5.5 if state_alpha=="IA" & (year==1913 |year==1916|year==1917|year==1918 ///
|year==1919)
replace interest_rate = 5.4 if state_alpha=="IA" & year>1913 & year<1916
replace interest_rate = 5.6 if state_alpha=="IA" & year>1919 & year<1922
replace interest_rate = 5.7 if state_alpha=="IA" & year==1922
replace interest_rate = 5.8 if state_alpha=="IA" & (year==1923|year==1924)

replace interest_rate = 6.1 if state_alpha=="MO" & (year==1913|year==1920)
replace interest_rate = 6.0 if state_alpha=="MO" & year>1913 & year==1920
replace interest_rate = 6.2 if state_alpha=="MO" & year==1921
replace interest_rate = 6.3 if state_alpha=="MO" & year==1922
replace interest_rate = 6.4 if state_alpha=="MO" & (year==1923|year==1924)

replace interest_rate = 7.2 if state_alpha=="ND" & (year==1913|year==1914|year==1916)
replace interest_rate = 7.3 if state_alpha=="ND" & year==1915
replace interest_rate = 7.1 if state_alpha=="ND" & year==1917
replace interest_rate = 6.9 if state_alpha=="ND" & year==1918
replace interest_rate = 6.8 if state_alpha=="ND" & year==1919
replace interest_rate = 6.6 if state_alpha=="ND" & year==1920
replace interest_rate = 6.5 if state_alpha=="ND" & year==1921
replace interest_rate = 6.7 if state_alpha=="ND" & year>1921 & year<1925

replace interest_rate = 6.2 if state_alpha=="SD" & (year==1913|year==1916)
replace interest_rate = 6.1 if state_alpha=="SD" & (year==1914|year==1915|year==1917|year==1918)
replace interest_rate = 6.0 if state_alpha=="SD" & year>1918 & year<1922
replace interest_rate = 6.3 if state_alpha=="SD" & (year==1922|year==1924)
replace interest_rate = 6.4 if state_alpha=="SD" & year==1923

replace interest_rate = 5.6 if state_alpha=="NE" & (year==1913|year==1914|year==1915)
replace interest_rate = 5.7 if state_alpha=="NE" & (year==1916|year==1918|year==1919)
replace interest_rate = 5.8 if state_alpha=="NE" & (year==1917|year==1920)
replace interest_rate = 5.9 if state_alpha=="NE" & year==1921
replace interest_rate = 6.0 if state_alpha=="NE" & year==1922
replace interest_rate = 6.0 if state_alpha=="NE" & (year==1923|year==1924)

replace interest_rate = 5.7 if state_alpha=="KS" & (year==1913|year==1914)
replace interest_rate = 5.8 if state_alpha=="KS" & (year==1915|year==1916)
replace interest_rate = 5.9 if state_alpha=="KS" & (year==1917|year==1918|year==1919)
replace interest_rate = 6.0 if state_alpha=="KS" & year==1920
replace interest_rate = 6.1 if state_alpha=="KS" & year==1921
replace interest_rate = 6.3 if state_alpha=="KS" & year==1922
replace interest_rate = 6.4 if state_alpha=="KS" & (year==1923|year==1924)

replace interest_rate = 5.6 if state_alpha=="DE" & year>1912 & year<1919
replace interest_rate = 5.7 if state_alpha=="DE" & (year==1919| year==1920)
replace interest_rate = 5.8 if state_alpha=="DE" & (year==1921| year==1922)
replace interest_rate = 5.9 if state_alpha=="DE" & (year==1923| year==1924)

replace interest_rate = 5.7 if state_alpha=="MD" & year==1913
replace interest_rate = 5.8 if state_alpha=="MD" & (year==1914|year==1915)
replace interest_rate = 5.9 if state_alpha=="MD" & year>1915 & year<1925

replace interest_rate = 5.9 if state_alpha=="VA" & year==1913
replace interest_rate = 5.9 if state_alpha=="VA" & year>1918 & year<1925
replace interest_rate = 6.0 if state_alpha=="VA" & year>1913 & year<1919

replace interest_rate = 6.1 if state_alpha=="WV" & year>1912 & year<1918
replace interest_rate = 6.0 if state_alpha=="WV" & year==1918
replace interest_rate = 5.9 if state_alpha=="WV" & year>1918 & year<1925

replace interest_rate = 6.0 if state_alpha=="NC" & year>1912 & year<1919
replace interest_rate = 6.0 if state_alpha=="NC" & year>1920 & year<1924
replace interest_rate = 5.9 if state_alpha=="NC" & (year==1919|year==1920|year==1924)

replace interest_rate = 7.8 if state_alpha=="SC" & year>1912 & year<1916
replace interest_rate = 7.7 if state_alpha=="SC" & year==1916
replace interest_rate = 7.6 if state_alpha=="SC" & year==1917
replace interest_rate = 7.4 if state_alpha=="SC" & year==1918
replace interest_rate = 7.1 if state_alpha=="SC" & (year==1919|year==1920|year==1924)
replace interest_rate = 7.2 if state_alpha=="SC" & (year==1921|year==1922|year==1923)

replace interest_rate = 7.7 if state_alpha=="GA" & (year==1913|year==1914)
replace interest_rate = 7.6 if state_alpha=="GA" & (year==1915|year==1917)
replace interest_rate = 7.5 if state_alpha=="GA" & year==1916
replace interest_rate = 7.4 if state_alpha=="GA" & year==1918
replace interest_rate = 7.2 if state_alpha=="GA" & (year==1919|year==1920|year==1922|year==1923)
replace interest_rate = 7.1 if state_alpha=="GA" & (year==1920|year==1924)

replace interest_rate = 7.7 if state_alpha=="FL" & year==1913
replace interest_rate = 7.3 if state_alpha=="FL" & (year==1914|year==1915|year==1919|year==1920|year==1924)
replace interest_rate = 7.4 if state_alpha=="FL" & (year==1916|year==1918|year==1922)
replace interest_rate = 7.2 if state_alpha=="FL" & (year==1917|year==1923)
replace interest_rate = 7.5 if state_alpha=="FL" & (year==1921)

replace interest_rate = 5.9 if state_alpha=="KY" & year>1912& year<1919
replace interest_rate = 5.9 if state_alpha=="KY" & (year==1921| year==1924)
replace interest_rate = 6.0 if state_alpha=="KY" & (year==1919| year==1920|year==1922|year==1923)

replace interest_rate = 5.8 if state_alpha=="TN" & (year==1913| year==1914)
replace interest_rate = 5.9 if state_alpha=="TN" & (year>1914| year<1922)
replace interest_rate = 5.9 if state_alpha=="TN" & year==1924
replace interest_rate = 6.0 if state_alpha=="TN" & (year==1922|year==1923)

replace interest_rate = 7.9 if state_alpha=="AL" & (year==1913|year==1914|year==1916)
replace interest_rate = 7.8 if state_alpha=="AL" & year==1915
replace interest_rate = 6.8 if state_alpha=="AL" & year==1924
replace interest_rate = 7.1 if state_alpha=="AL" & year==1923
replace interest_rate = 7.3 if state_alpha=="AL" & (year==1922|year==1919)
replace interest_rate = 7.3 if state_alpha=="AL" & (year==1920|year==1921)
replace interest_rate = 7.6 if state_alpha=="AL" & year==1918
replace interest_rate = 7.7 if state_alpha=="AL" & year==1917


replace interest_rate = 8.2 if state_alpha=="MS" & year==1913
replace interest_rate = 7.5 if state_alpha=="MS" & year==1914
replace interest_rate = 7.2 if state_alpha=="MS" & (year==1915|year==1916|year==1917)
replace interest_rate = 6.9 if state_alpha=="MS" & year==1918
replace interest_rate = 6.6 if state_alpha=="MS" & (year==1919|year==1922|year==1924)
replace interest_rate = 6.4 if state_alpha=="MS" & (year==1920|year==1921)
replace interest_rate = 6.7 if state_alpha=="MS" & year==1923

replace interest_rate = 7.8 if state_alpha=="AR" & (year==1913|year==1917)
replace interest_rate = 7.9 if state_alpha=="AR" & year==1914
replace interest_rate = 8.0 if state_alpha=="AR" & (year==1915|year==1916)
replace interest_rate = 7.3 if state_alpha=="AR" & (year==1918|year==1922)
replace interest_rate = 7.0 if state_alpha=="AR" & (year==1919|year==1920)
replace interest_rate = 7.1 if state_alpha=="AR" & (year==1921|year==1924)
replace interest_rate = 7.2 if state_alpha=="AR" & year==1923

replace interest_rate = 7.6 if state_alpha=="LA" & (year==1913|year==1916)
replace interest_rate = 7.8 if state_alpha=="LA" & (year==1914|year==1915)
replace interest_rate = 7.4 if state_alpha=="LA" & year==1917
replace interest_rate = 7.2 if state_alpha=="LA" & year==1918
replace interest_rate = 7.1 if state_alpha=="LA" & (year==1919|year==1920|year==1922)
replace interest_rate = 7.0 if state_alpha=="LA" & (year==1921|year==1923)
replace interest_rate = 6.9 if state_alpha=="LA" & year==1924

replace interest_rate = 6.3 if state_alpha=="OK" & (year==1913|year==1914)
replace interest_rate = 6.4 if state_alpha=="OK" & year==1915
replace interest_rate = 6.8 if state_alpha=="OK" & (year==1916|year==1920)
replace interest_rate = 7.0 if state_alpha=="OK" & year==1917
replace interest_rate = 6.7 if state_alpha=="OK" & (year==1918|year==1919)
replace interest_rate = 6.9 if state_alpha=="OK" & year==1921
replace interest_rate = 7.2 if state_alpha=="OK" & year==1922
replace interest_rate = 7.3 if state_alpha=="OK" & year==1923
replace interest_rate = 7.4 if state_alpha=="OK" & year==1924

replace interest_rate = 7.9 if state_alpha=="TX" & year==1913
replace interest_rate = 7.8 if state_alpha=="TX" & year>1913 & year<1917
replace interest_rate = 7.7 if state_alpha=="TX" & (year==1917|year==1918)
replace interest_rate = 7.5 if state_alpha=="TX" & (year==1919|year==1921|year==1923)
replace interest_rate = 7.4 if state_alpha=="TX" & (year==1920|year==1924)
replace interest_rate = 7.6 if state_alpha=="TX" & year==1922

replace interest_rate = 7.6 if state_alpha=="MT" & (year==1913|year==1918)
replace interest_rate = 7.7 if state_alpha=="MT" & (year==1914|year==1917)
replace interest_rate = 7.8 if state_alpha=="MT" & (year==1915|year==1916)
replace interest_rate = 7.4 if state_alpha=="MT" & (year==1919|year==1923|year==1924)
replace interest_rate = 7.3 if state_alpha=="MT" & (year==1920|year==1921|year==1922)

replace interest_rate = 8.2 if state_alpha=="ID" & year==1913
replace interest_rate = 8.1 if state_alpha=="ID" & (year==1914|year==1915)
replace interest_rate = 7.9 if state_alpha=="ID" & year==1916
replace interest_rate = 7.8 if state_alpha=="ID" & year==1917
replace interest_rate = 7.6 if state_alpha=="ID" & year==1918
replace interest_rate = 7.4 if state_alpha=="ID" & (year==1919|year==1924)
replace interest_rate = 7.3 if state_alpha=="ID" & (year==1920|year==1921)
replace interest_rate = 7.5 if state_alpha=="ID" & (year==1922|year==1923)

replace interest_rate = 8.6 if state_alpha=="WY" & year==1913
replace interest_rate = 8.3 if state_alpha=="WY" & year==1914
replace interest_rate = 8.0 if state_alpha=="WY" & year==1915
replace interest_rate = 7.8 if state_alpha=="WY" & (year==1916|year==1923)
replace interest_rate = 7.7 if state_alpha=="WY" & (year==1917|year==1924)
replace interest_rate = 7.6 if state_alpha=="WY" & (year==1918|year==1921)
replace interest_rate = 7.5 if state_alpha=="WY" & year==1919
replace interest_rate = 7.3 if state_alpha=="WY" & year==1920
replace interest_rate = 7.9 if state_alpha=="WY" & year==1922

replace interest_rate = 7.0 if state_alpha=="CO" & (year==1913|year==1916|year==1922|year==1923)
replace interest_rate = 7.1 if state_alpha=="CO" & (year==1914|year==1915|year==1924)
replace interest_rate = 6.9 if state_alpha=="CO" & year==1917
replace interest_rate = 6.8 if state_alpha=="CO" & year==1918
replace interest_rate = 6.7 if state_alpha=="CO" & (year==1919|year==1920|year==1921)

replace interest_rate = 8.4 if state_alpha=="NM" & (year==1913|year==1915|year==1916)
replace interest_rate = 8.3 if state_alpha=="NM" & (year==1914|year==1917)
replace interest_rate = 8.2 if state_alpha=="NM" & (year==1918|year==1919)
replace interest_rate = 8.0 if state_alpha=="NM" & year==1920
replace interest_rate = 7.8 if state_alpha=="NM" & year==1921
replace interest_rate = 7.7 if state_alpha=="NM" & year==1922
replace interest_rate = 7.5 if state_alpha=="NM" & year==1923
replace interest_rate = 7.5 if state_alpha=="NM" & year==1924

replace interest_rate = 8.0 if state_alpha=="AZ" & year==1913
replace interest_rate = 8.5 if state_alpha=="AZ" & (year==1914|year==1915)
replace interest_rate = 8.4 if state_alpha=="AZ" & year==1916
replace interest_rate = 8.3 if state_alpha=="AZ" & year==1917
replace interest_rate = 7.8 if state_alpha=="AZ" & (year==1918|year==1921|year==1923)
replace interest_rate = 7.7 if state_alpha=="AZ" & year==1919
replace interest_rate = 7.6 if state_alpha=="AZ" & year==1920
replace interest_rate = 7.5 if state_alpha=="AZ" & year==1924
replace interest_rate = 7.9 if state_alpha=="AZ" & year==1922

replace interest_rate = 7.9 if state_alpha=="UT" & year==1913
replace interest_rate = 7.8 if state_alpha=="UT" & year==1914
replace interest_rate = 7.6 if state_alpha=="UT" & year==1915
replace interest_rate = 7.5 if state_alpha=="UT" & year==1916
replace interest_rate = 7.3 if state_alpha=="UT" & year==1917
replace interest_rate = 7.2 if state_alpha=="UT" & year==1918
replace interest_rate = 7.0 if state_alpha=="UT" & (year==1919|year==1920|year==1921|year==1923)
replace interest_rate = 7.1 if state_alpha=="UT" & year==1922
replace interest_rate = 6.9 if state_alpha=="UT" & year==1924

replace interest_rate = 7.8 if state_alpha=="NV" & year==1913
replace interest_rate = 8.1 if state_alpha=="NV" & (year==1914|year==1916)
replace interest_rate = 8.2 if state_alpha=="NV" & year==1915
replace interest_rate = 8.4 if state_alpha=="NV" & year==1917
replace interest_rate = 7.6 if state_alpha=="NV" & year==1918
replace interest_rate = 7.3 if state_alpha=="NV" & year==1919
replace interest_rate = 6.9 if state_alpha=="NV" & year==1920
replace interest_rate = 6.8 if state_alpha=="NV" & (year==1921|year==1924)
replace interest_rate = 7.0 if state_alpha=="NV" & (year==1922|year==1923)

replace interest_rate = 7.4 if state_alpha=="WA" & (year==1913|year==1914|year==1915)
replace interest_rate = 7.3 if state_alpha=="WA" & (year==1916|year==1917)
replace interest_rate = 7.1 if state_alpha=="WA" & year==1918
replace interest_rate = 6.9 if state_alpha=="WA" & (year==1919|year==1922)
replace interest_rate = 6.8 if state_alpha=="WA" & (year==1921|year==1920)
replace interest_rate = 7.0 if state_alpha=="WA" & (year==1923|year==1924)

replace interest_rate = 7.5 if state_alpha=="OR" & (year==1913|year==1915)
replace interest_rate = 7.6 if state_alpha=="OR" & year==1914
replace interest_rate = 7.4 if state_alpha=="OR" & (year==1916|year==1917)
replace interest_rate = 7.1 if state_alpha=="OR" & year==1918
replace interest_rate = 7.0 if state_alpha=="OR" & year==1919
replace interest_rate = 6.8 if state_alpha=="OR" & (year==1920|year==1921|year==1922|year==1923)
replace interest_rate = 6.7 if state_alpha=="OR" & year==1924

replace interest_rate = 6.5 if state_alpha=="CA" & (year==1913|year==1914|year==1915|year==1920)
replace interest_rate = 6.6 if state_alpha=="CA" & (year==1916|year==1918|year==1919|year==1921)
replace interest_rate = 6.7 if state_alpha=="CA" & (year==1917|year==1922|year==1923|year==1924)


*Regressions
*logging dependent variables
gen log_depo = log(depo_ +1)
gen log_people = log(people_ +1)

*logging independent
gen log_pop = log(totpop+1)
*creating ratios
gen percent_rural = 100*rur/totpop
gen percent_foreign = fbwftot*100/totpop
gen percent_male= 100*mtot/totpop
gen log_val = log(cropval +1)

areg log_depo percent_rural percent_foreign percent_male log_pop log_val interest_rate insurance ///
, absorb(fips1910) cluster(state)
areg log_people percent_rural percent_foreign percent_male log_pop log_val interest_rate insurance ///
, absorb(fips1910) cluster(state)
