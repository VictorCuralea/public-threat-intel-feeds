#!/bin/bash

SEARCH_INPUT="$1"
SEARCH_DIR="$2"
FULLTEXT=false

# Check if the second argument is -fulltext
if [[ $3 == "-fulltext" ]]
then
  FULLTEXT=true
fi

function search_string() {
  SEARCH_STRING="$1"
  RESULTS_FOUND=false
  OUTPUT=""

  # Search in each file in the directory and its subdirectories
  while IFS= read -r -d '' file
  do
    if $FULLTEXT
    then
      MATCHES=$(grep -n "$SEARCH_STRING" "$file")
    else
      MATCHES=$(grep -Pn "\b$SEARCH_STRING\b" "$file")
    fi

    # If there are matches in the file
    if [[ $MATCHES != "" ]]
    then
      RESULTS_FOUND=true
      FILE_NAME=$(echo "$file" | sed "s|$SEARCH_DIR||")
      LINE_NUMBERS=$(echo "$MATCHES" | cut -d: -f1 | paste -sd "," -)
      OUTPUT+=",{\"source\":\"$FILE_NAME\", \"line-number\":\"$LINE_NUMBERS\"}"
    fi
  done < <(find "$SEARCH_DIR" -type f -print0)

  # If no results were found
  if ! $RESULTS_FOUND
  then
    echo "{\"search-term\":\"$SEARCH_STRING\", \"results\":[], \"comment\":\"No results\"}"
  else
    # Remove leading comma and print
    echo "{\"search-term\":\"$SEARCH_STRING\", \"results\":[${OUTPUT:1}], \"comment\":\"\"}"
  fi
}

# If SEARCH_INPUT is a file, read each line from the file and use it as a search string
if [[ -f $SEARCH_INPUT ]]
then
  echo "["
  FIRST=true
  while IFS= read -r line
  do
    if $FIRST; then
      FIRST=false
    else
      echo ","
    fi
    search_string "$line"
  done < "$SEARCH_INPUT"
  echo
  echo "]"
# If SEARCH_INPUT is not a file, use it as a search string
else
  echo "["
  search_string "$SEARCH_INPUT"
  echo
  echo "]"
fi
