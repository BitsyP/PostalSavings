** This files is an attempt to do matching between towns that have post offices and populated places.
* There are two lists use, one from the US Board on Geographic Names from http://geonames.usgs.gov/domestic/download_data.htm ,
* and the other from AniMap.

*set mem 1g

clear all
*Grab the post office data and read it in
insheet using "C:\Users\bitsy\Dropbox\RFD Papers\Postal Savings\Data files\TownMatch\postalsaving_towns_to_match.csv", comma names
*Make the variable names for later matching.
rename state state_alpha
rename town feature_name
replace state_alpha = trim(itrim(state_alpha))
replace feature_name = trim(itrim(feature_name))

save "C:\Users\bitsy\Dropbox\RFD Papers\Postal Savings\Data files\TownMatch\postalsaving_towns_to_match.dta", replace




*This procedure makes matches from the All Names file.
*There will be three files "good" matches, duplicate matches, and non matched.
* The US Board on Geographic Names classifies place into types (e.g. lake, monument).
*Because the file is so large, I chop it up into feature classes for each merge and then append any matches back together.

cd "C:\Users\bitsy\Dropbox\RFD Papers\Postal Savings\Data files\TownMatch\"
*"Airport" "Arch"  "Area"  "Arroyo"  "Bar"  "Basin"  "Bay"  "Beach"  "Bench" "Bend"  "Bridge"  "Building"  "Canal"  "Cape"  "Cemetery"  "Census"  "Channel" "Church"  "Civil"  "Cliff"  "Crater"  "Crossing"  "Dam"  "Falls"  "Flat" "Forest"  "Gap"  "Glacier"  "Gut"  "Harbor"  "Hospital"  "Island"  "Isthmus"  "Lake"  "Lava"  "Levee"  "Locale"  "Military"  "Mine"  "Oilfield"  "Park"  "Pillar"  "Plain"  "Populated Place"    "Range"  "Rapids"  "Reserve"  "Reservoir"  "Ridge"  "School"  "Sea"  "Slope"  "Spring"  "Stream"  "Summit"  "Swamp"  "Tower"  "Trail"  "Tunnel"  "Unknown"  "Valley"  "Well"  "Woods" 
foreach feature_class in "Post Office" {

use "C:\Users\bitsy\Dropbox\RFD Papers\Postal Savings\Data files\TownMatch\NationalFile_AllNames.dta", clear
keep if  feature_class=="`feature_class'"

drop if  feature_name==""

joinby state_alpha feature_name using "C:\Users\bitsy\Dropbox\RFD Papers\Postal Savings\Data files\TownMatch\postalsaving_towns_to_match.dta", update unmatched(both) _merge(_merge)
drop if  _merge!=3
*If any mataches remain keep them.
if _N > 0 {
drop if  feature_name==""
drop _merge
compress
duplicates drop

*Cheak to see if the file exists before trying to append it.
capture confirm file "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta"
if _rc==0 {
append using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta"
}

duplicates drop
save NationalFile_AllNames_Matches.dta, replace

}

}

use C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta, clear
duplicates drop
*I know these don't match, so get rid of them
drop if  feature_name=="Mount Morris" &  feature_class=="Summit"
compress
save NationalFile_AllNames_Matches.dta, replace


*Place names from AniMapPlaces









*This starts on bringing in the names of the places list on the patents





*This procedure makes matches from the All Names file.
*There will be three files "good" matches, duplicate matches, and non matched.

*Because the file is so large, I chop it up into feature classes for each merge and then append any matches back together.
cd "C:\Users\bitsy\Dropbox\Patent\TownMatch"

foreach feature_class in "Airport" "Arch"  "Area"  "Arroyo"  "Bar"  "Basin"  "Bay"  "Beach"  "Bench" "Bend"  "Bridge"  "Building"  "Canal"  "Cape"  "Cemetery"  "Census"  "Channel" "Church"  "Civil"  "Cliff"  "Crater"  "Crossing"  "Dam"  "Falls"  "Flat" "Forest"  "Gap"  "Glacier"  "Gut"  "Harbor"  "Hospital"  "Island"  "Isthmus"  "Lake"  "Lava"  "Levee"  "Locale"  "Military"  "Mine"  "Oilfield"  "Park"  "Pillar"  "Plain"  "Populated Place"  "Post Office"  "Range"  "Rapids"  "Reserve"  "Reservoir"  "Ridge"  "School"  "Sea"  "Slope"  "Spring"  "Stream"  "Summit"  "Swamp"  "Tower"  "Trail"  "Tunnel"  "Unknown"  "Valley"  "Well"  "Woods" {

use C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames.dta, clear
keep if  feature_class=="`feature_class'"

drop if  feature_name==""

joinby state_alpha feature_name using "C:\Users\bitsy\Dropbox\Patent\TownMatch\patentLocations17901836.dta", update unmatched(both) _merge(_merge)
drop if  _merge!=3
*If any mataches remain keep them.
if _N > 0 {
drop if  feature_name==""
drop _merge
compress
duplicates drop

*Cheak to see if the file exists before trying to append it.
capture confirm file "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta"
if _rc==0 {
append using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta"
}

duplicates drop
save NationalFile_AllNames_Matches.dta, replace

}

}

use C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta, clear
duplicates drop
*I know these don't match, so get rid of them
drop if  feature_name=="Mount Morris" &  feature_class=="Summit"
compress
save NationalFile_AllNames_Matches.dta, replace





*Match places for AniMap
use "C:\Users\bitsy\Dropbox\Patent\TownMatch\patentLocations17901836.dta", clear
joinby state_alpha feature_name using "C:\Users\bitsy\Dropbox\Patent\TownMatch\AniMapPlaces.dta", update unmatched(both) _merge(_merge)
*This paticular observation can cause no end of trouble
drop if name=="Baltimore v-Vienna"
drop if _merge!=3
drop _merge
rename name_official feature_name_official
duplicates drop
compress
save AniMapPlaces_Matches.dta, replace







*Create a master file of matches
use "C:\Users\bitsy\Dropbox\Patent\TownMatch\AniMapPlaces_Matches.dta", clear
joinby  state_alpha feature_name feature_name_official patent halfpatent ///
 using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta", update unmatched(both) _merge(_merge)
drop _merge
duplicates drop
compress
duplicates tag patent halfpatent, generate(duplicate_maches)

*Pull out duplicates or bad matches
drop if duplicate_maches==0 & (feature_class == "Populated Place" | feature_class == "Civil" | feature_class == "")
sort state_alpha feature_name  patent halfpatent
egen group_num = group(patent halfpatent)
compress
save "C:\Users\bitsy\Dropbox\Patent\TownMatch\DuplicateMatch.dta", replace


*Create a "good matches" file
*As above
use "C:\Users\bitsy\Dropbox\Patent\TownMatch\AniMapPlaces_Matches.dta", clear
joinby  state_alpha feature_name feature_name_official patent halfpatent ///
 using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta", update unmatched(both) _merge(_merge)
drop _merge
duplicates drop
compress
duplicates tag patent halfpatent, generate(duplicate_maches)

*Create a "good matches" file
keep if duplicate_maches==0 & (feature_class == "Populated Place" | feature_class == "Civil" | feature_class == "")
sort state_alpha feature_name  patent halfpatent
drop duplicate_maches
compress
save "C:\Users\bitsy\Dropbox\Patent\TownMatch\Matched.dta", replace
outsheet using "C:\Users\bitsy\Dropbox\Patent\TownMatch\Matched.csv", comma replace


*Create a file of Nonmatches
use "C:\Users\bitsy\Dropbox\Patent\TownMatch\AniMapPlaces_Matches.dta", clear
joinby  state_alpha feature_name feature_name_official patent halfpatent ///
 using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta", update unmatched(both) _merge(_merge)
drop _merge
duplicates drop
compress

merge m:1 patent halfpatent using ///
 "C:\Users\bitsy\Dropbox\Patent\TownMatch\patentLocations17901836.dta"
drop if _merge==3
drop _merge

drop  name county2000 lat longw fid_temp ///
 feature_id is_feature_name_official feature_name_official ///
 feature_class state_numeric county_name county_numeric ///
 primary_lat_dms prim_long_dms prim_lat_dec prim_long_dec
 
duplicates drop
compress
sort state_alpha feature_name  patent halfpatent
save "C:\Users\bitsy\Dropbox\Patent\TownMatch\NotMatched.dta"

drop if state_alpha==""
drop if feature_name==""
duplicates drop
compress
sort state_alpha feature_name  patent halfpatent
save "C:\Users\bitsy\Dropbox\Patent\TownMatch\NotMatchedClean.dta"
outsheet using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NotMatchedClean.csv", comma replace

*Keep just a list of these places.
keep residence country state_alpha county1 feature_name
duplicates drop
compress
sort state_alpha feature_name
save "C:\Users\bitsy\Dropbox\Patent\TownMatch\NotMatchedTown.dta"
outsheet using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NotMatchedTown.csv", comma replace


*Make a list with more data for my RA
use C:\Users\bitsy\Dropbox\Patent\TownMatch\DuplicateMatch.dta
merge m:1 patent halfpatent using "C:\Users\bitsy\Dropbox\Patent\TownMatch\patent17901836.dta"
drop if _merge!=3
drop _merge
duplicates drop
duplicates tag state_alpha feature_name, generate(NumberAffected)
replace  NumberAffected =  NumberAffected+1
compress
sort state_alpha feature_name  patent halfpatent
save "C:\Users\bitsy\Dropbox\Patent\TownMatch\DuplicateMatchPatentInfo.dta", replace
outsheet using "C:\Users\bitsy\Dropbox\Patent\TownMatch\DuplicateMatchPatentInfo.csv", comma replace





*One might match by soundex, but it is awful. Don't use this.
/*
cd "C:\Users\bitsy\Dropbox\Patent\TownMatch"

*Matching by soundex
*Only use these two feature classes because there are so many matches on the first four letters that are crazy.

*You'll have to go back and soundex the names
*One way to deal with misspellings is to soundex names.
*gen soundex_feature_name = soundex(feature_name)
*gen soundex_county1 = soundex(county1)

foreach feature_class in "Populated Place" "Civil" {
use C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames.dta, clear
keep if  feature_class=="`feature_class'"

drop if  feature_name==""
gen soundex_feature_name = soundex(feature_name)

joinby state_alpha feature_name using "C:\Users\bitsy\Dropbox\Patent\TownMatch\patentLocations17901836.dta", update unmatched(both) _merge(_merge)
drop if  _merge!=3

*If any mataches remain keep them.
if _N > 0 {
drop if  feature_name==""
drop _merge
compress
duplicates drop

*Cheak to see if the file exists before trying to append it.
capture confirm file "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_MatchesSoundex.dta"
if _rc==0 {
append using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_MatchesSoundex.dta"
}

duplicates drop
save NationalFile_AllNames_MatchesSoundex.dta, replace

}

}

use C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_MatchesSoundex.dta
duplicates drop

*Drop off any potental matches that also have an exact match, those are all set.
joinby patent halfpatent using "C:\Users\bitsy\Dropbox\Patent\TownMatch\NationalFile_AllNames_Matches.dta", update unmatched(both) _merge(_merge)
drop if  exact_match==1
drop  two_maches exact_match _merge 

duplicates tag patent halfpatent, generate(two_maches)
compress

save NationalFile_AllNames_MatchesSoundex.dta, replace
*/


*At first I was working with the populated places data from the US Board on Geographic Names.  While I have moved from doing that I want to keep the documentation.
/*
*Start with a csv taken from the data table of USA_Populated_Places.lpk
*	Export the data of the layer to a new shapefile, by right clicking on the layer and going to 'Data' and then 'Export Data'. Add this layer to the map.
*		This will allow you add new fields.
*	Go to 'Geoprocessing' then 'Search for Tools', in the search window that appears type "XY".
*		Click on Add XY Coordinates, under Environments change XY Resolution to 0.001 DecimalDegrees
*		This will add fields labeled POINT_Y = Lat and POINT_X = Long
*	Export the table of this shapefile by right clicking on the layer, opening the attribute table, then exporting the data. Or just copying the .dbf file of this layer.
*	Change the extension to .csv, open in excel and save as a CSV.

insheet using "C:\Users\bitsy\Dropbox\Patent\Data\Shapefiles\PlaceNames\USA_Populated_Places.csv", comma
drop elev_meter
rename stctyfips fips2010
rename point_y Lat
rename point_x Long

*Get state names and codes.
gen statefip = floor(fips2010/1000)
merge m:1 statefip using "C:\Users\bitsy\Dropbox\Patent\Data\NicholasData\states.dta"

*Places like Guam and Puerto Rico aren't in the state list, and I don't have data from them
drop if _merge!=3
drop  name_upper statecen _merge

compress

save "C:\Users\bitsy\Dropbox\Patent\TownMatch\USA_Populated_Places.dta", replace
*/
