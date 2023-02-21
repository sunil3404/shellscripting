#!/bin/bash

pipelineName=$(cat test.txt | grep -iE 'pipelineName' | grep -v null | uniq | cut -d ":" -f 2)

my_arr=()
for each in $pipelineName
do	
	if [[ ! "${my_arr[*]}" =~ " ${each} " ]]; then
		echo "Insided the if loop ${each}"
		my_arr+=($each)
		echo "This is my array ${my_arr[@]}"
	fi
done

echo "${my_arr[0]}"
echo "${my_arr[1]}"
echo "${my_arr[2]}"A

echo "the lenght of my array is ${#my_arr[@]}"
