#!/bin/bash

# This is a static source that has already been imported in full, so there's no
# need to keep running the comparison

cd $(dirname $0)

qsv join --left position whogov.csv raw reconciled-positions.csv |
  qsv select "name,position[1],position,birthyear,deadyear,gender,year,year" |
  sed -e 's/,NA,/,,/g' -e 's/,NA,/,,/g' -e 's/A (2020)//' -e 's/,Male,/,male,/' -e 's/,Female,/,female,/' |
  qsv rename name,positionItem,position,dob,dod,gender,start,end |
  qsv join --left name - name reconciled-people.csv |
  qsv select id,name,positionItem,position,start,end,dob,dod,gender > scraped.csv

# wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv search -s start . > wikidata.csv

# bundle exec ruby diff.rb | qsv sort -s name,position | tee diff.csv

cd ~-
