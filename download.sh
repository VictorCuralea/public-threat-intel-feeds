#!/bin/bash

   function download_feeds() {
     # Loop through each configuration file in the config directory
     for file in config/*.txt; do
       source_name=$(basename "$file" .txt)
       mkdir -p "rawdata/$source_name"

       # Loop through each feed URL in the file
       while IFS=',' read -r url filename; do
	 filename=$(echo "$filename" | xargs)
	 wget -O "rawdata/$source_name/$filename" -nv "$url"
       done < "$file"
     done
   }

   function main() {
     # Create the data and rawdata directories if they don't exist
     mkdir -p data rawdata

     # Download the feeds
     download_feeds
   }

   # Function definitions (as shown above)
   rm -rf rawdata/*	
   main
