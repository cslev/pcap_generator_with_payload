#!/bin/bash

function show_help
{
 echo -e "This script uses curl --doh-url to test a DoH resolver"
 echo -e "Example: ./generate_input.sh -m <MALICOUS_IP_LIST> -b <BENIGN_IP_LIST> -o <OUTPUT_BASE>"
 echo -e "\t\t-m <MALICIOUS_IP_LIST>: .CSV file containing the malicious IPs; one each line"
 echo -e "\t\t-b <BENIGN_IP_LIST>: .CSV file containing the benign IPs; one each line"
 echo -e "\t\t-o <OUTPUT_BASE>: Basename of the intended output file"
 exit
 }


malicious_source_ip_file=""
benign_source_ip_file=""
output=""

while getopts "h?m:b:o:" opt
 do
 	case "$opt" in
 	h|\?)
 		show_help
 		;;
 	m)
 		malicious_source_ip_file=$OPTARG
 		;;
 	b)
 		benign_source_ip_file=$OPTARG
 		;;
 	o)
 		output=$OPTARG
 		;;
 	*)
 		show_help
 		;;
 	esac
done

if [ -z $malicious_source_ip_file ]
then
  echo -e "No MALICIOUS_IP_LIST is set!"
  show_help
fi
if [ -z $benign_source_ip_file ]
then
  echo -e "No BENIGN_IP_LIST is set!"
  show_help
fi
if [ -z $output ]
then
  output="final_trace"
  echo -e "No OUTPUT_BASE is set! Using default ${output}"
fi


num_malicious=$(cat $malicious_source_ip_file|wc -l)
num_benign=$(cat $benign_source_ip_file| wc -l)
echo "$num_malicious"
echo "$num_benign"
SUM=`expr $num_malicious + $num_benign`

echo "$SUM"



M_CSV="${output}_malicious_${num_malicious}.csv"
B_CSV="${output}_benign_${num_benign}.csv"

rm -rf $M_CSV $B_CSV "${output}.csv"


#For Port 0
DST_MAC=00:00:00:00:00:02
SRC_MAC_MALICIOUS=00:00:00:00:00:01
SRC_MAC_BENIGN=22:22:22:00:00:01
SRC_IP=12.34.45.56
DST_IP=10.0.0.2
VLAN=1
IPMODE=ipv4
PROT=udp
PKTSIZE=64
FLOWS=$num_malicious


## PKTGEN SCRIPTING TEST - DID NOT WORK
#echo "set 0 size $PKTSIZE" > $M_CSV
#echo "set ip dst 0 $SRC_IP" > $M_CSV
#echo "set ip src 0 $DEST_IP/24" > $M_CSV
#echo "set ip dst 1 $DEST_IP" > $M_CSV
#echo "set ip src 1 $SRC_IP/24" > $M_CSV
#echo "set 0 rate 100"

echo "Processing ${malicious_source_ip_file}..."
echo -n "${SUM}"
for ip in $(cat $malicious_source_ip_file)
do
  SOURCE_IP=$ip
  SUM=`expr $SUM - 1`
  echo -e "\\r$SUM"
  DST_PORT=$(((RANDOM % 32768) + 28232))
  for i in `seq 1 $(((RANDOM % 5) + 10))`  #somewhere between [10,15]
  do
    echo "src_mac=${SRC_MAC_MALICIOUS},dst_mac=${DST_MAC}, src_ip=$SOURCE_IP, dst_ip=${DST_IP}, src_port=53,dst_port=$DST_PORT,payload=dns_example.payload" >> $M_CSV
  done
done


#for ip in $(cat $benign_source_ip_file)
#do
#  IFS=',' read -r -a benign_array <<< $ip
#  SOURCE_IP = "${array[0]}"
#  DST_PORT  = "${array[1]}"
#done



LIST_OF_PORTS=(443 80 22 139 53)
for ip in $(cat $benign_source_ip_file)
do
  SUM=`expr $SUM - 1`
  echo -e "\\r$SUM"

  SOURCE_IP=$ip
  DST_PORT=$(echo ${LIST_OF_PORTS[$RANDOM % ${#LIST_OF_PORTS[@]} ]})
  SRC_PORT=$(((RANDOM % 32768) + 28232))
 # echo $DEST_PORT
#  if [ $DEST_PORT -eq 53 ]
#  then
#    PAYLOAD=",payload=dns_example.payload"
#    echo "benign DNS"
#  else
#    PAYLOAD=""
#  fi
  for i in `seq 1 $(((RANDOM % 5) + 1))`
  do
    echo "src_mac=${SRC_MAC_BENIGN},dst_mac=${DST_MAC}, src_ip=$SOURCE_IP, dst_ip=${DST_IP}, src_port=${SRC_PORT},dst_port=${DST_PORT}" >> $B_CSV
  done

done


echo "Benign traffic has SRC_MAC=${SRC_MAC_BENIGN}, while malicious has ${SRC_MAC_MALICIOUS}"


cat $M_CSV |shuf > "tmp_${output}.csv"
cat $B_CSV |shuf >> "tmp_${output}.csv"
cat "tmp_${output}.csv" | shuf > "${output}.csv"

#rm -rf $M_CSV $B_CSV "tmp_${output}.csv"

echo "[DONE]"
echo ""
