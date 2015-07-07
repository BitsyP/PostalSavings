
*********1910 Variables Being kept*****************
/*variables being kept: State Code, County Code, State Name, Census Region 9,
Census Region 5, Population, Urban Pop 25K, Urban Pop 2.5K, area 
Rural, "Other" Races, Total Foreign Born White, Total Native White with Foreign Parents
Total Female, Total Male, White Male, White Female, Black Male, 
Black Female,, Total Pop Over Age 10, Total Illiterate Pop Over Age 10, Dwellings,
Families, Value of Crops, Value of Cereals, Number of Farms, Owner-operated farms, 
Total Homes, Total Farmhomes, Mortgaged Farmhomes, Nonfarm Homes, 
Mortgaged Nonfarm Homes, Total White Pop */

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
	, by(fips1910 state)

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

rename urb1910 urb_1910 
rename rur1910 rur_1910

*relabeling each variable so it is identidied as 1910
foreach var of varlist area urb25 totpop ///
othraces nwfptot fbwtot mtot ftot  wmtot wftot negmtot negftot ///
t10tot  tillit10  dwell families cropval cerealva farms farmown ///
tothomes tfarmhom fhencumb tothhome ohencumb whtot {
rename `var' `var'_1910
}

save 1910Trimmed.dta, replace

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
merge 1:1  fips1910 using 1910trimmed.dta
keep if _merge ==3
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
save 1910trimmed.dta, replace




