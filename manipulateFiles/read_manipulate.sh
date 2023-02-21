#!/bin/bash

:> output.txt
#pipeline_name=$(cat test.txt | grep -i 'pipelineName' | grep -v null | uniq | cut -d ":" -f 2)
pipeline_name=$(cat test.txt | grep -i 'pipelineName' | grep -v null | awk '!seen[$0]++' | cut -d ":" -f 2)
pipeline_status=$(cat test.txt | grep -i 'status' | cut -d ":" -f 2)

echo $pipeline_name
#Adding pipelineName to name_arr
#name_arr=()
#for each in $pipeline_name
#do 	
#	if [[ ! " ${pipeline_name} " == " ${each} " ]]; then
#		name_arr+=($each)
#	fi
#done
#echo ${name_arr[@]}

#Adding status to the stat_arr
status_arr=()
for each in $pipeline_status
do	
	status_arr+=("$each")
done

currTime=$(date -u +"%m-%d-%y %r")
forwardTime=$(date -u -d '+1 hour' '+%m-%d-%y %r')

echo "		 Pipeline Run Stats from ${currTime} to ${forwardTime}" >> output.txt
echo -e "===============================================================================================================\n\n" >> output.txt



#Adding format to the file and creating sections
echo -e "[Succeded]\n" >> output.txt
echo -e "[Failed]\n" >> output.txt
echo -e "[InProgress]\n" >> output.txt
echo -e "[Cancelled]\n" >> output.txt


i=0
for pname in $pipeline_name
do	
	pipeline=$(echo ${pname} | sed 's/[",]//g')
	stat=$(echo "${status_arr["$i"]}" | sed 's/[",]//g')

	if [[ "${stat}" = "failed" ]]; then 
		#sed -i '/\[Failed\]/a '${pipeline}' \| '${stat}'' output.txt
		sed -i '/\[Failed\]/a '${pipeline}'' output.txt
	elif [[ "${stat}" = "succeded" ]]; then
		sed -i '/\[Succeded\]/a '${pipeline}'' output.txt
		#sed -i '/\[Succeded\]/a '${pipeline}' \| '${stat}'' output.txt
	elif [[ "${stat}" = "InProgress" ]]; then
		#sed -i '/\[InProgress\]/a '${pipeline}' \| '${stat}'' output.txt
		sed -i '/\[InProgress\]/a '${pipeline}'' output.txt
	elif [[ "${stat}" = "cancelled" ]]; then
		#sed -i '/\[Cancelled\]/a '${pipeline}' \| '${stat}'' output.txt
		sed -i '/\[Cancelled\]/a '${pipeline}'' output.txt
	else
		echo -e "The following status ${stat} not found for the \npipeline ${pipeline} "
	fi
	i=$((i+1))
done

sed -i '/\[Succeded\]/a ___________\n' output.txt
sed -i '/\[InProgress\]/a _____________\n' output.txt
sed -i '/\[Failed\]/a _________\n' output.txt
sed -i '/\[Cancelled\]/a ___________\n' output.txt


