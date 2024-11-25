#!/bin/bash

# copy files to a target folder given a list of filenames in a txt file.

#  usage: 
#     bash /ap/script/tools599/mlutil599/find.list.copy.sh



src=/mnt/data/6760/vis1/2024-11-18
cd  ${src}

# Directory to copy files to..
target_dir="/ap/tmp/1118c/qsnok"
target_dir="/ap/tmp/1118d/qs-ok"

# Path to the text file containing filenames
file_list="/ap/tmp/filelist.txt"
csv_file="/ap/tmp/qsnok_6760_vis1___qs_ng___shadow_model_mismatch_2024-11-19T09_10.csv"
csv_file="/ap/tmp/qs.ok_6760_vis1_qs_ok_shadow_model_mismatch_2024-11-19T09_16_42.704308-05_00.csv"


mkdir -p $target_dir
# Enable debugging
set -x

#################################################################



# Function to copy a file and handle duplicates
copy_file() {
    local src_file="$1"
    local base_name=$(basename "$src_file")
    local dest_file="$target_dir/$base_name"

    echo "Copying $src_file to $dest_file"

    if [ ! -f "$dest_file" ]; then
        cp "$src_file" "$dest_file"
    else
        local i=1
        local new_dest_file="$target_dir/${base_name%.*}.dup$i.${base_name##*.}"
        while [ -f "$new_dest_file" ]; do
            ((i++))
            new_dest_file="$target_dir/${base_name%.*}.dup$i.${base_name##*.}"
        done
        cp "$src_file" "$new_dest_file"
        echo "Renamed and copied $src_file to $new_dest_file"
    fi
}

# Extract filenames from the CSV file
file_names=$(awk -F, 'NR==1 {for (i=1; i<=NF; i++) if ($i == "file_name") col=i} NR>1 {print $col}' "$csv_file")

# Process each filename
while IFS= read -r filename; do
    echo "Searching for $filename"
    while IFS= read -r -d '' file; do
        copy_file "$file"
    done < <(find . -type f -name "$filename" -print0)
done <<< "$file_names"

# Disable debugging
set +x