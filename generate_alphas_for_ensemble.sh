while getopts r:o: flag
do
    case "${flag}" in
        r) rounds=${OPTARG};;
        o) output_dir=${OPTARG};;
    esac
done

declare -A best_valid_returns_=()
declare -A best_test_returns_=()

best_valid_returns_[1]="0.001224 -0.001608 -0.001391 -0.000672 0.000167 0.004311 0.002309 0.000706 0.002827 -0.000202 -0.001828 0.000779 0.001701 -0.002960 -0.002118 -0.000290 0.000997 0.001104 0.000500 0.000987 -0.000345 -0.001451 -0.000304 -0.000354 0.000171 -0.002191 0.006876 -0.000870 -0.001405 -0.000080 0.000818 0.001910 -0.002808 0.005351 0.007376 -0.007819 0.005116 -0.000451 0.000083 -0.006025 -0.001118 -0.000759 -0.000163 0.000819 -0.000431 -0.002831 0.002468 -0.006197 0.000165 0.003467 -0.001596 -0.000673 -0.006541 -0.000549 -0.005515 0.001711 -0.001739 0.006246 -0.001597 0.000007 -0.002548 0.001163 -0.006527 0.000296 0.002426 -0.001292 0.001962 -0.001304 -0.000724 0.001967 -0.000708 0.001031 -0.000681 -0.004833 0.000857 -0.002176 -0.002628 -0.002875 -0.004236 0.002247 -0.002525 -0.005086 -0.007315 -0.002520 0.003511 0.004163 0.003474 0.001585 0.003983 0.001598 -0.003088 -0.002285 0.000868 0.001198 0.002424 0.001169 -0.001485 0.000964 -0.003366 0.002195 -0.000218 -0.002492 0.003624 -0.004654 -0.003878 -0.002047 -0.000415 0.001502 0.004320 -0.000999 -0.003655 -0.000149 -0.001642 -0.008301 -0.005541 -0.002447"
best_test_returns_[1]="-0.001599 -0.000963 -0.004110 0.000290 -0.003303 0.006604 -0.000512 -0.004431 0.001947 -0.003298 0.001147 -0.003483 0.001902 -0.002309 0.002586 -0.004156 -0.001108 0.001460 0.002033 -0.005519 -0.003722 -0.003996 -0.001980 0.002942 -0.001990 0.006957 0.001399 -0.006340 -0.000551 -0.000345 0.002708 0.000006 -0.001902 0.001816 0.002528 0.001461 0.001595 0.001221 0.003618 -0.002809 -0.001231 -0.007098 -0.004042 -0.000532 0.003360 0.002274 -0.002574 -0.006822 -0.001745 -0.002829 -0.010261 -0.003414 -0.000613 -0.002542 -0.004989 0.002362 -0.003858 -0.001314 -0.001282 -0.001294 0.001792 -0.002720 -0.002812 -0.003088 -0.006543 0.003307 -0.002025 -0.004060 0.000821 -0.000701 -0.001232 0.000728 0.006457 -0.001944 0.002227 0.004321 0.003057 0.002156 -0.003656 -0.002231 0.000770 -0.004623 0.002438 -0.001151 0.001699 -0.001660 0.000810 -0.000366 -0.001277 -0.000355 0.004241 -0.000744 -0.005438 0.004717 0.000816 -0.009150 -0.006324 0.001075 0.002367 0.003602 -0.004215 -0.007240 -0.001721 0.001578 -0.001861 0.001590 0.003218 -0.002555 -0.006567 -0.001343 -0.000147 -0.003605 0.003136 0.002115 -0.002631 -0.000428"

best_valid_returns_[2]="-0.001883 -0.004164 -0.006156 -0.000723 -0.000825 -0.002015 -0.000632 -0.003243 -0.003910 0.003308 0.000792 0.002087 -0.003378 0.005663 -0.001174 0.001720 0.001232 0.000757 -0.003863 -0.003073 -0.000633 0.002073 -0.003278 0.000753 0.001118 0.001735 -0.004002 -0.001350 -0.000317 -0.002799 0.003504 -0.003172 0.000608 0.001685 -0.006826 -0.001381 -0.001753 0.004187 -0.004757 -0.004196 0.001598 -0.000740 0.000190 0.001127 0.002685 -0.005228 0.000215 -0.000128 0.000079 -0.002302 0.000538 -0.000879 -0.002178 0.003965 0.002216 0.000141 0.007763 0.003497 0.003843 -0.004704 0.002375 -0.005188 -0.001633 -0.003044 0.000029 0.004647 0.002163 0.001272 0.000245 -0.001880 -0.002365 -0.003260 -0.003719 -0.001339 -0.002481 0.000575 -0.001353 -0.003012 0.000328 0.003821 -0.002624 -0.001443 -0.000475 0.001466 0.000329 -0.000518 0.001251 -0.004228 -0.001035 0.002957 -0.000495 0.007179 -0.000867 0.000040 0.000502 0.000480 -0.004651 -0.004409 -0.002326 -0.006420 -0.000302 0.001331 -0.000605 0.001344 -0.001356 0.004333 0.000163 0.002953 -0.000440"
best_test_returns_[2]="0.001883 -0.000168 -0.001233 -0.008903 -0.000190 -0.002226 -0.001363 -0.002779 0.000221 -0.001752 -0.002399 0.001524 -0.003077 0.002494 0.000170 0.003929 0.000366 0.004866 0.002436 0.002544 -0.000586 -0.000198 -0.001823 0.003771 -0.000912 0.004233 -0.001814 -0.000543 -0.003658 0.002878 -0.000038 0.000492 0.001439 0.000853 -0.002887 0.000208 0.002399 -0.007973 0.000920 -0.002209 -0.003768 0.001465 -0.002088 0.000704 -0.005493 0.001465 0.002010 -0.000487 0.002145 -0.002397 0.002540 0.000213 -0.004127 0.002831 -0.000071 -0.001030 0.001294 0.002630 0.000194 -0.004437 0.000733 -0.000638 -0.001333 0.001072 0.001584 0.002991 0.001479 0.004084 -0.000618 0.000289 0.003202 0.002302 -0.008450 0.000985 -0.000001 -0.000397 -0.001335 -0.001445 0.005921 0.001771 0.000894 -0.010542 0.000522 0.001130 0.003289 0.000355 0.001103 -0.007805 -0.003135 -0.007460 0.000321 -0.002080 0.001830 0.001601 -0.001003 0.000425 -0.000107 0.000876 -0.003948 -0.003380 0.005800 0.004265 0.008672 -0.004443 0.001586 0.004149 -0.006370 0.005204 -0.005072 -0.005982"

best_valid_returns_[3]="0.000000 0.000996 0.005810 0.001938 0.004838 0.001349 0.004129 -0.002328 0.002332 0.001349 0.002789 0.000459 0.004275 0.005610 0.005839 0.010633 0.012400 -0.002561 0.001238 0.004556 0.004205 -0.000561 0.001207 0.002411 -0.001629 0.003842 -0.000276 0.007930 0.003751 0.001098 0.001995 0.007071 0.002794 0.001261 -0.002651 0.008355 -0.002822 -0.000389 0.002424 0.006228 0.000010 0.008488 0.004101 0.000661 0.007039 0.003213 0.005136 0.008039 0.007899 0.001179 0.000104 0.000346 0.003013 0.000127 0.000337 0.000693 0.001151 0.001002 0.004882 0.003844 0.001864 0.000555 -0.001499 -0.000278 -0.000455 0.001472 0.004381 0.003914 0.004423 0.003816 0.001980 0.005225 0.004845 0.000771 0.010243 0.005289 0.002162 0.007169 0.004747 0.005430 0.008685 0.003879 0.009971 0.007706 0.006059 0.006542 0.002298 0.002726 -0.003176 0.004193 0.004447 0.002970 0.001620 0.002125 0.000659 0.000749 0.000369 0.002472 0.002112 0.001695 0.000556 0.001992 0.002230 0.003090 0.004406 0.001973 0.001056 0.000098 0.000571 0.004778 0.006007 -0.000356 0.003619 0.002653 0.003842 0.000524" 
best_test_returns_[3]="0.001250 0.002782 -0.000779 0.001649 0.000508 0.002558 0.000138 0.002681 0.004757 0.001635 0.002812 0.002991 0.002732 0.002794 0.006887 0.002794 0.002335 0.001737 0.000870 0.005134 0.004168 0.003142 0.003888 0.002514 0.003374 0.005096 0.008249 0.009558 0.002894 0.007235 0.006962 0.000113 0.000472 0.001790 0.000827 0.002128 -0.001719 0.002756 0.000963 0.003424 0.000215 0.003417 0.001978 0.007216 0.001786 0.004674 0.003526 0.004989 0.002272 0.003282 -0.000553 0.000558 0.005754 0.003677 0.003600 0.002926 0.003408 0.005909 0.002166 0.002074 0.003434 0.006721 0.003634 0.004644 0.009817 0.005543 0.001918 0.003861 0.001406 0.002334 0.000531 0.002973 -0.000970 -0.001851 0.002705 0.001924 0.001868 -0.000643 0.004210 0.002784 0.004263 0.003749 0.005839 0.004605 -0.001560 0.008045 0.008386 0.004860 0.002668 0.006251 0.002669 0.013193 0.003009 0.003011 0.007103 0.006148 0.003307 0.002379 0.003067 0.006108 0.001914 0.003999 0.004814 0.002551 0.003416 -0.001254 0.003909 0.005212 0.018763 -0.000817 0.008274 0.010592 0.000859 0.003324 0.001219 -0.000517"

best_valid_returns_[4]="0.0040756 0.0031563 0.000129051 0.00373519 -0.000202312 0.00158072 0.00538197 0.00100945 0.00332539 0.0024705 0.00210515 0.00295206 0.002621 -0.000790793 -0.00168755 0.00751675 0.00288368 0.00311604 0.000808149 0.00377772 -0.00352965 -0.00163943 -0.00455195 0.00208286 -0.0034128 0.00221667 0.00245747 0.00551712 0.00368253 0.00104424 0.00118564 0.00359743 -0.00273357 0.00226265 0.00603837 0.00218229 0.00289919 -0.00300532 0.0029417 0.00119422 0.00062219 0.000247094 0.00411388 -0.000347996 0.000822655 0.000743444 -0.000333629 0.00672859 0.000540362 0.0024341 5.27486e-05 0.00262916 0.00499986 0.000204389 -0.0027676 -0.000453751 -9.19366e-05 0.00223643 0.000648946 0.00183285 -0.0010633 0.00027096 0.000891729 -0.000132679 0.00329658 0.00219543 -0.000815209 0.00031807 -0.00380936 -0.000548591 -0.000909178 -0.00219513 0.00101414 0.00100196 0.00239809 0.00233066 0.0011846 -0.000552008 0.00217169 -0.00205833 0.0025243 0.00350743 0.00151811 5.77816e-05 0.00293952 0.000792696 0.000330212 0.00399359 0.00134878 -0.00127587 0.00186386 0.00345011 0.00215696 0.00216855 -0.000666104 -0.000620272 0.00248596 0.00236709 0.00056133 0.0025395 0.000756568 0.00383931 -0.00126461 0.00139459 -0.00127253 0.00107539 0.00159618 -0.00149992 0.00010252 0.0010096 0.000521808 0.00230177 0.000694147 -0.000348349 -0.0022005 -0.000207427"
best_test_returns_[4]="0.00119999 0.000301742 0.00302722 0.00173234 0.00111756 -0.00218288 -0.00101641 -0.000318455 0.0024683 0.00661973 0.000850705 0.0010818 -0.00235552 0.0027329 -0.0021186 0.00014327 0.00468092 0.000622064 0.00183986 0.0011201 0.000779347 0.00179028 0.0065174 0.00107612 0.000783914 -0.00430983 0.00182168 0.000998737 0.00162662 0.000603166 -0.000575616 0.00130931 -0.000291927 -0.00044126 0.00335834 -0.00236152 -3.48376e-05 0.00165223 -0.00050383 -0.00120481 0.00346838 0.00151728 0.00228353 0.000352406 0.00211582 -0.000921195 -0.0010169 -0.000187047 0.00548542 0.00108787 0.0124939 0.00214241 -0.000187598 -2.5773e-05 0.00510192 0.003419 0.000525343 0.00141914 -0.000610481 -0.00058619 -0.00244232 -0.000129933 0.00309982 0.000550199 -0.00137139 -0.000291977 -0.00234732 -0.000692767 0.00292385 0.0027203 0.000373473 -0.000782622 -0.000250607 0.000295233 0.000224251 0.000489861 -0.00317021 -0.00164023 0.000833466 0.00236122 -8.35385e-05 0.00208497 3.83559e-05 0.000550012 -0.00454016 0.000271052 -0.00170992 0.00303823 -0.0024213 0.00168468 0.00100232 0.00384892 0.00326069 -0.00235716 0.000161643 0.00911055 0.000332738 -0.000423506 -0.00178251 -0.000635346 -0.00215373 0.00562947 0.00171501 -0.00949365 0.00268461 -0.00253421 0.00199781 0.00129538 0.00290936 0.00239678 0.0015036 0.00709739 -0.00208643 -0.000887032 0.000533674 0.00168763"
     

home=$(pwd)

if [ -z "$output_dir" ]
then
	echo "No output_dir argument supplied"
else
	echo "delete repeated experiment results"
	rm -rf ${home}/${output_dir}
fi

mkdir -p ${home}/${output_dir}

path=$home/$output_dir/

best_alpha_files="$(ls $path)"

for k in $(seq 1002293 1002294)
do
	for j in $(seq 0 1)
	do
		best_valid_returns=""
		best_test_returns=""
		round=0		
		for i in $(seq 1 5)
		do
		    round=$(($round + 1))
			if [ $round -lt 5 ]
			then
		    	ith_best_valid_returns=${best_valid_returns_[${round}]}
		    	best_valid_returns+="${ith_best_valid_returns};"
		    	ith_best_test_returns=${best_test_returns_[${round}]}
		    	best_test_returns+="${ith_best_test_returns};"
			fi
		done
		timeout 10m bash ./run_baseline.sh -a RANDOM_ALGORITHM -p $path  -m $home/generated_alphas/best_alphas/alpha${j}.txt -s 100000000000000 -v "${best_valid_returns}" -t "${best_test_returns}" -d ${k} &
	done
done
wait
# timeout 10m bash 
