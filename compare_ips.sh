#!/bin/bash

#COLORIZING
none='\033[0m'
bold='\033[01m'
disable='\033[02m'
underline='\033[04m'
reverse='\033[07m'
strikethrough='\033[09m'
invisible='\033[08m'

black='\033[30m'
red='\033[31m'
green='\033[32m'
orange='\033[33m'
blue='\033[34m'
purple='\033[35m'
cyan='\033[36m'
lightgrey='\033[37m'
darkgrey='\033[90m'
lightred='\033[91m'
lightgreen='\033[92m'
yellow='\033[93m'
lightblue='\033[94m'
pink='\033[95m'
lightcyan='\033[96m'

function show_help
{
  echo -e "${red}${bold}Arguments not set properly!${none}"
  echo -e "${green}Example: ./compare_tcp.sh <input_file1> <input_file2>${none}"
  echo -e "Input files are plain text files, each line containing an element to compare"
  echo -e "The intersection (if there is any) will be printed out to <input_file1___VS___input_file2> as well as to STDOUT"
  echo -e "${yellow}Ensure your input files contain only the name and nothing more!${none}"
  exit
}

function calc
{
  awk "BEGIN { print "$*" }";
}

if [ $# -ne 2 ]
then
  show_help
fi


INPUT1=$1
INPUT2=$2
ENTRY_NUM_INPUT1=$(cat $INPUT1 | wc -l)
ENTRY_NUM_INPUT2=$(cat $INPUT2 | wc -l)

OUTPUT="${INPUT1}___VS___${INPUT2}"

echo -en "${bold}Cleaning up..."
rm -rf $OUTPUT
echo -e "${green}[DONE]${none}"

echo -e "Reading input file ${INPUT1} and comparing to input file ${INPUT2}"
cat $INPUT1 | while read line
do
  #empty line check
  if [ -z "$line" ]
  then
    continue
  fi

  #echo -e "Checking PC member's ${line} of ${INPUT1} appearance in ${INPUT2}"
  grep -i "${line}" $INPUT2 >>/dev/null
  retval=$(echo $?)
  #check the return value of command 'grep'
  if [ $retval -eq 0 ]
  then
    #we had a match
    echo -e "${lightblue}Match logged:  ${line} ${none}"
    echo $line >> $OUTPUT
  fi
done

MATCH_NUM=$(cat $OUTPUT|wc -l)
echo -e "${green}We have found ${MATCH_NUM} matching elements in the intersection of ${INPUT1} and ${INPUT2}"
echo -e "\n"
PERCENTAGE=$(calc "($MATCH_NUM/$ENTRY_NUM_INPUT1)*100")
echo -e "${green}${PERCENTAGE}% of ${INPUT1} has appeared in ${INPUT2}${none}"
echo -e "${green}[DONE]\n${none}"
