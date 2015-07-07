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
