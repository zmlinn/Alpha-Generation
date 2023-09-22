# for market NYSE num_stocks is 1402; for NASDAQ num_stocks is 1076
while getopts r:o:b:t:m:n: flag
do
    case "${flag}" in
        r) rounds=${OPTARG};;
        o) output_dir=${OPTARG};;
	b) the_round_use_previous_best_alphas=${OPTARG};;
        t) time=${OPTARG};;
        m) market=${OPTARG};;
		n) num_stocks=${OPTARG};;
    esac
done

home=$(pwd)

if [ -z "$output_dir" ]
then
	echo "No output_dir argument supplied"
else
	echo "delete repeated experiment results"
	rm -rf ${home}/${output_dir}
fi

mkdir -p ${home}/${output_dir}

mkdir -p ${home}/${output_dir}/best_in_each_round

mkdir -p ${home}/${output_dir}/evolution_process

mkdir -p ${home}/${output_dir}/figures

mkdir -p ${home}/${output_dir}/candidate_best

declare -A best_valid_returns_=()
declare -A best_test_returns_=()

for i in $(seq 1 $((rounds - 1)))
do
	best_valid_returns_[$i]=""
        best_test_returns_[$i]=""        
done

for round in $(seq 1 $((rounds)))
do 
        best_ic=1.1E-22
        if [ $round -eq $the_round_use_previous_best_alphas ]
        then
                for round_p in $(seq 1 $((the_round_use_previous_best_alphas - 1)))
		do
                        if test -d "$(pwd)/${output_dir}/candidate_best/best_alpha_${round_p}_${round}"; then
				rm -r $(pwd)/${output_dir}/candidate_best/best_alpha_${round_p}_${round}
			fi
			mkdir $(pwd)/${output_dir}/candidate_best/best_alpha_${round_p}_${round}
			for file_next in $(ls ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_${round_p})
			do
				for file in $(ls ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_${round_p}/$file_next/*th_Alpha.txt)
				do
	                                best_valid_returns=""
        	                        best_test_returns=""
                	                for i in  $(seq 1 $((rounds - 1)))
                        	        do
                                	        ith_best_valid_returns=${best_valid_returns_[${i}]}
                                        	best_valid_returns+="${ith_best_valid_returns};"
	                                        ith_best_test_returns=${best_test_returns_[${i}]}
        	                                best_test_returns+="${ith_best_test_returns};"
                	                done
					sed "s/^[ \t]*//" -i $file
					timeout ${time}m bash ./run.sh -a MY_ALPHA -p $(pwd)/${output_dir}/candidate_best/best_alpha_${round_p}_${round}/  -m $file -s 100000000000 -v "${best_valid_returns}" -t "${best_test_returns}" -b ${market} -f ${num_stocks} &
				done
			done
		done
		wait
                for round_p in $(seq 1 $((the_round_use_previous_best_alphas - 1)))
                do
                        cd $(pwd)/${output_dir}/candidate_best/best_alpha_${round_p}_${round}
                        echo
                        echo "printing results for round${round} using the best alpha from the previous round${round_p} as initialization"
 			python $home/draw_a_graph_for_alpha.py --path "$(pwd)" --name "$(pwd)/figure_best_alpha_${round_p}_${round}"

                        evolved_alpha_return_file=""
                        current_valid_return_substring=""
                        current_test_return_substring=""
			return_files=$(ls -t *Return.txt)
                        if [[ $? != 0 ]]; then
				echo "no valid returns"
			elif [[ $return_files ]]; then
                                evolved_alpha_return_file="$(ls -t *Return.txt | head -1)"
                                current_valid_return_substring="$(tr -s ' ' <${evolved_alpha_return_file} | cut -d':' -f2)"
                                current_test_return_substring="$(tr -s ' ' <${evolved_alpha_return_file} | cut -d'v' -f1)"
                        fi

                        best_alpha_index=${evolved_alpha_return_file:0:5}
                        best_alpha_files="$(ls ${best_alpha_index}*)"
                        current_ic=1E-22
                        
                        if test -d "${home}/${output_dir}/best_alpha_${round_p}_${round}"; then
				rm -r ${home}/${output_dir}/best_alpha_${round_p}_${round}
			fi
			mkdir -p ${home}/${output_dir}/best_alpha_${round_p}_${round}
                        for file in $best_alpha_files
                        do
                                cp ${file} ${home}/${output_dir}/best_alpha_${round_p}_${round}
                                if [[ "$file" == *"mance.txt"* ]]
                                then
                                        evolved_alpha_performance_file="$(ls -t *mance.txt | head -1)"
                                        current_ic_substring="$(tr -s ' ' <${evolved_alpha_performance_file} | cut -d'=' -f8)"
                                        current_ic=${current_ic_substring:1:8}
                                        echo "current_ic: ${current_ic}"
                                fi
                        done
			cp $(pwd)/figure_best_alpha_${round_p}_${round}.png ${home}/${output_dir}/best_alpha_${round_p}_${round}
                        echo "best_ic_before_update: $best_ic"

                        if (( $(echo "${best_ic} < ${current_ic}" |bc -l) )); then
                        #if [ "$best_ic" -le "$current_ic" ]
                                if test -d "${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round"; then
                                	rm -rf ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round
				fi
                                mkdir ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round
                                cp -r ${home}/${output_dir}/best_alpha_${round_p}_${round} ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round
                                best_ic=$current_ic
                                echo "best_ic_after_update: $best_ic"
                                best_valid_returns_[$round]=$current_valid_return_substring
                                best_test_returns_[$round]=$current_test_return_substring
                        fi
                        cd $home
                done				
	else
		for init in 1000011 1000020 1000030 1000040 1000050 1000060 1000070 1000080 1000090 1000100
	        do  
                        if test -d "$(pwd)/${output_dir}/evolution_process/${init}_${round}"; then
				rm -r $(pwd)/${output_dir}/evolution_process/${init}_${round}
			fi
        		mkdir -p $(pwd)/${output_dir}/evolution_process/${init}_${round} 
        		alpha_num="$((round-1))"
               		if [ $round -eq 1 ]
			then
				timeout ${time}m bash ./run.sh -a MY_ALPHA -p $(pwd)/${output_dir}/evolution_process/${init}_${round}/  -m $(pwd)/generated_alphas/best_alphas_${market}/alpha${alpha_num}.txt -s 100000000000 -v "" -t "" -d $init -b ${market} -f ${num_stocks} & # | xargs --max-procs=2
                	else
				best_valid_returns=""
                        	best_test_returns=""
				for i in  $(seq 1 $((rounds - 1)))
                		do
                               		ith_best_valid_returns=${best_valid_returns_[${i}]}
                                	best_valid_returns+="${ith_best_valid_returns};"
                                	ith_best_test_returns=${best_test_returns_[${i}]}
                                	best_test_returns+="${ith_best_test_returns};"
                        	done
                         		timeout ${time}m bash ./run.sh -a MY_ALPHA -p $(pwd)/${output_dir}/evolution_process/${init}_${round}/  -m $(pwd)/generated_alphas/best_alphas_${market}/alpha${alpha_num}.txt -s 100000000000 -v "${best_valid_returns}" -t "${best_test_returns}" -b ${market} -f ${num_stocks} &
                	fi
        	done
		wait
        	for init in 1000011 1000020 1000030 1000040 1000050 1000060 1000070 1000080 1000090 1000100
        	do
        		cd $(pwd)/${output_dir}/evolution_process/${init}_${round}
                        echo
                	echo "printing results for round${round} using ${init} as initialization"

			python $home/utils/draw_a_graph_for_alpha.py --path "$(pwd)" --name "$(pwd)/figure_${init}_${round}"

                        evolved_alpha_return_file=""
                        current_valid_return_substring=""
                        current_test_return_substring=""
                        return_files=$(ls -t *Return.txt)
                        if [[ $? != 0 ]]; then
                                echo "no valid returns"
                        elif [[ $return_files ]]; then
                                evolved_alpha_return_file="$(ls -t *Return.txt | head -1)"
                                current_valid_return_substring="$(tr -s ' ' <${evolved_alpha_return_file} | cut -d':' -f2)"
                                current_test_return_substring="$(tr -s ' ' <${evolved_alpha_return_file} | cut -d'v' -f1)"
                        fi
              
			best_alpha_index=${evolved_alpha_return_file:0:5}
			best_alpha_files="$(ls ${best_alpha_index}*)"
			current_ic=1E-22

                        if test -d "${home}/${output_dir}/${init}_${round}"; then
				rm -r ${home}/${output_dir}/${init}_${round}
                        fi
			mkdir -p ${home}/${output_dir}/${init}_${round}
 			for file in $best_alpha_files
			do
				cp ${file} ${home}/${output_dir}/${init}_${round}
				if [[ "$file" == *"mance.txt"* ]]
				then
		                	evolved_alpha_performance_file="$(ls -t *mance.txt | head -1)"                
			                current_ic_substring="$(tr -s ' ' <${evolved_alpha_performance_file} | cut -d'=' -f8)"
        	        		current_ic=${current_ic_substring:1:8}			
					echo "current_ic: ${current_ic}"
				fi	
			done
			cp $(pwd)/figure_${init}_${round}.png ${home}/${output_dir}/${init}_${round}
                	echo "best_ic_before_update: $best_ic"

	                if (( $(echo "${best_ic} < ${current_ic}" |bc -l) )); then
        	        #if [ "$best_ic" -le "$current_ic" ] 
                                if test -d "${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round"; then
                                	rm -rf ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round
                                fi
				mkdir ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round
				cp -r ${home}/${output_dir}/evolution_process/${init}_${round}  ${home}/${output_dir}/best_in_each_round/best_alpha_in_round_$round
				best_ic=$current_ic
                	        echo "best_ic_after_update: $best_ic"
                        	best_valid_returns_[$round]=$current_valid_return_substring
	                      	best_test_returns_[$round]=$current_test_return_substring
			fi
                	cd $home
	        done
	fi
done
