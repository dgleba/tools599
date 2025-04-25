---
tags: cp-ng-ts.txt.sh, mk6,
---
# cp-ng-ts.sh.txt  -  find and copy pmvis772 ng defects png/xml files by time and serial to tmp folder

rev: 2025-04-02_Wed_08.48-AM

=
vision

1.  find

qualisense@stppmda6760qsvis1:/mnt/data/img/6760/pma_vis_1/2025-03-16$ 

/mnt/data/img/6170/pma_vis_1/2025-03-18


find .  | grep "/ng/" | grep "png" | sort -t'_' -k7

./10R80/C5/ng/6760_10R80_z2_c5_t2_V1_20250316T091854.259_ng.png
./10R80/C4/ng/6760_10R80_z8_c4_t5_V1_20250316T092144.080_ng.png
./10R80/C6/ng/6760_10R80_z9_c6_t10_V1_20250316T094958.298_ng.png
./10R80/C5/ng/6760_10R80_z9_c5_t19_V1_20250316T094959.530_ng.png
./10R80/C4/ng/6760_10R80_z16_c4_t6_V1_20250316T095311.683_ng.png


2. copy so they can be viewed in labelimg


# date below is set to today, but you can override it..
tday=$(date +"%Y-%m-%d");
# edit time on next line..
cutoff_datetime="$tday 12:00:00";

echo $cutoff_datetime
echo $tday;
# you may need to edit the path..
cd /mnt/data/img/6760/pma_vis_1/$tday/;
cd /mnt/data/img/6170/pma_vis_1/$tday/;

# list ng images..
find .  | grep "/ng/" | grep "png" | sort -t'_' -k7

# copy ng img and xmls
target_dir="/ap/tmp/dgleba/$(date +"%Y.%m.%d_%b-%a_%H.%M.%S")_ng-pics" && mkdir -p "$target_dir" && find . -type f  -newermt "$cutoff_datetime" | grep "/ng/" | sort -t'_' -k7| while read -r file; do cp "$file" "$target_dir"; done


# No. 
# Use metabase instead. query the db.
# Make csv. 
python3 /ap/pmvis772/script/xml2csvg21.py
mv output-tmp91.csv $target_dir



==