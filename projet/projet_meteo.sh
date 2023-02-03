#!/bin/bash

function usage() {
	echo "Usage: `basename $0` [OPTION]... FICHIER...
Afficher des graphiques en fonctions des options rentrées en sortie standard.

Option obligatoire :
-f <fichier> , permet de définir le fichier d'entrée des données (.csv avec délimiteur ';') 

[Options utilitaires] :
-m, produit en sortie l’humidité maximale pour chaque station, ces valeurs seront triées dans l'ordre décroissant.   
-h, produit en sortie l’altitude pour chaque station, elles seront triées par ordre décroissant.

-t <mode>, mode OBLIGATOIRE entre 1 et 3 : 
	-t 1, produit en sortie les températures minimales, maximales et moyennes par station
	dans l’ordre croissant du numéro de station.
	-t 2, produit en sortie les températures moyennes par date/heure, triées dans l’ordre chronologique, 	
	la moyenne se fait sur toutes les stations.
	-t 3, produit en sortie les températures pardate/heure par station. 
	Elles seront triées par ordre chronologique, puis par ordre croissant de l’ID station

-p <mode>, mode OBLIGATOIRE entre 1 et 3 : 
	-p 1, produit en sortie les pressions minimales, maximales et moyennes par station
	dans l’ordre croissant du numéro de station.
	-p 2, produit en sortie les pressions moyennes par date/heure, triées dans l’ordre chronologique, 	
	la moyenne se fait sur toutes les stations.
	-p 3, produit en sortie les pressions pardate/heure par station. 
	Elles seront triées par ordre chronologique, puis par ordre croissant de l’ID station

[Option géographiques] : Limite les recherches suivant une certaine zone géographique.
-F, (F)rance métropolitaine et la Corse.
-G, (G)uyane française.
-S, (S)aint-Pierre et Miquelon
-A, (A)ntilles française
-O, (O)céan Indien
-Q, Antarcti(Q)ue

[Option datée] : Limite les recherches sur cet interval de temps.
-d [YYYY-MM-DD:YYYY-MM-DD], avec en premier argument la date de début de sélection et en deuxième argument la date de fins
"
}


#Define if --help is call.

if [ "$1" == "--help" ]; then
	usage
	exit 0
else

	#We use getopts to read all the options given at the execution of the program.

	while getopts ":mhwt:p:FOGQASf:d:" opt; do
	case $opt in
		f)
		file="$OPTARG"
		;;
		m)  
		moisture='true'
		;;
		h)
		height='true'
		;;
		t) 
		temperature='true'
		argt="$OPTARG"  
		;;
		p)
		pressure='true'
		argp="$OPTARG"
		;;
		F)
		france='true'
		;;
		O)
		indian_ocean='true'
		;;
		G)
		guyana='true'
		;;
		Q)
		antarctic='true'
		;;
		A)
		antille='true'
		;;
		S)
		st_pierre='true'
		;;
		d)
		lim="$OPTARG"
		tri_date='true'
		echo "$lim"
		;;
		w)
		wind='true'
		;;
		\?)
		echo "Invalid option: -$OPTARG. Refer to --help for more informations" >&2
		;;
	esac
	done
fi

#Check if -f have a file. If not, display error message.

if [ -z "$file" ]; then
    echo "No file specified, please enter the input file name with the -f <file_name> option"
	exit 1
fi

#We find just after all the conditions of filter on places :

if [[ ${france} == true  ]]; then
    awk -F';' '{if($1 ~ /^07/) print $1 ";" $2 ";" $3 ";" $4 ";" $5 ";" $6 ";" $7 ";"$8 ";"$9 ";" $10 ";" $11 ";" $12 ";" $13 ";" $14}' $file > filter_france.csv
	file=filter_france.csv
fi

if [[ ${indian_ocean} == true  ]]; then
    awk -F';' '{if($1 ~ /^61/) print $1 ";" $2 ";" $3 ";" $4 ";" $5 ";" $6 ";" $7 ";"$8 ";"$9 ";" $10 ";" $11 ";" $12 ";" $13 ";" $14}' $file > filter_indian_ocean.csv
	file=filter_indian_ocean.csv
fi

if [[ ${guyana} == true  ]]; then
    awk -F';' '{if($1 ~ /^81/) print $1 ";" $2 ";" $3 ";" $4 ";" $5 ";" $6 ";" $7 ";"$8 ";"$9 ";" $10 ";" $11 ";" $12 ";" $13 ";" $14}' $file > filter_guyana.csv
	file=filter_guyana.csv
fi

if [[ ${antarctic} == true  ]]; then
    awk -F';' '{if($1 ~ /^89/) print $1 ";" $2 ";" $3 ";" $4 ";" $5 ";" $6 ";" $7 ";"$8 ";"$9 ";" $10 ";" $11 ";" $12 ";" $13 ";" $14}' $file > filter_antarctic.csv
	file=filter_antarctic.csv
fi

if [[ ${antille} == true  ]]; then
    awk -F';' '{if($1 ~ /^78/) print $1 ";" $2 ";" $3 ";" $4 ";" $5 ";" $6 ";" $7 ";"$8 ";"$9 ";" $10 ";" $11 ";" $12 ";" $13 ";" $14}' $file > filter_antille.csv
	file=filter_antille.csv
fi

if [[ ${st_pierre} == true  ]]; then
    awk -F';' '{if($1 ~ /^71/) print $1 ";" $2 ";" $3 ";" $4 ";" $5 ";" $6 ";" $7 ";"$8 ";"$9 ";" $10 ";" $11 ";" $12 ";" $13 ";" $14}' $file > filter_st_pierrecsv
	file=filter_st_pierre.csv
fi

if [[ ${moisture} == true  ]]; then

	#Filter and format the content of a file using awk. The field separator is defined as ";" the code between braces defines the actions to perform on each line of the file.
	#Here it will retrieve the max value of column 6 to fill it in the table of IDs.

    awk -F";" 'NR > 1 {
	  id[$10]++;
	  sum[$10] += $6;
	  if ($11 > max[$10] || !max[$10]) {
	    max[$10] = $6;
	  }
	}
	END {
	  for (i in id) {
	    print i "," max[i];
	  }
	}' $file > tmp.csv
	
	sort -t";" -rn -k2 tmp.csv > max_moisture_by_ID.csv
    rm tmp.csv
	gen_graph/./moisture_graph.sh
fi

if [[ ${height} == true  ]]; then

	#Filter and format the content of a file using awk. The field separator is defined as ";" the code between braces defines the actions to perform on each line of the file.

	awk -F";" 'NR > 1 {
	  id[$10] = $14;
	}
	END {
	  for (i in id) {
	    print i "," id[i];
	  }
	}' $file > tmp.csv
		
	sort -t";" -nr -k2 tmp.csv > height_by_ID_station.csv
	rm tmp.csv
	gen_graph/./alt_graph.sh
fi

if [[ ${temperature} == true ]]; then
	if [[ ${argt} -eq 1 ]]; then	

	#Filter and format the content of a file using awk. The field separator is defined as ";" the code between braces defines the actions to perform on each line of the file.
	#Here we will sum the values found in column 11 for the value of the ID put in the table

		awk -F";" 'NR>1 {
		id[$1]++;
		sum[$1] += $11;
		}
		END {
		for (i in id) {
			avg = sum[i] / id[i];
			print i ";" avg;
		}
		}' $file > tmp.csv
		
		sort -t";" -n -k1 tmp.csv > avg_temp_by_ID.csv
		rm tmp.csv
			
	#Filter and format the content of a file using awk. The field separator is defined as ";" the code between braces defines the actions to perform on each line of the file.
	#Here it will retrieve the min value of column 11 to fill it in the table of IDs.


		awk -F";" 'NR > 1 {
		id[$1]++;
		sum[$1] += $11;
		if ($11 < min[$1] || !min[$1]) {
			min[$1] = $11;
		}
		if ($11 > max[$1] || !max[$1]) {
			max[$1] = $11;
		}
		}
		END {
		for (i in id) {
			print i ";" min[i] ";" max[i];
		}
		}' $file > tmp.csv
			
		sort -t";" -n -k1 tmp.csv > min_max_temp_by_ID.csv
		rm tmp.csv
				
	elif [[ ${argt} -eq 2 ]]; then
			
	#Output file definition and if already exists then delete to avoid conflicts

		output="avg_temp_by_date.csv"
		rm -f $output

	#Filter and format the content of a file using awk. The field separator is defined as ";" the code between braces defines the actions to perform on each line of the file.

		awk -F";" 'NR > 1 { date=substr($2,1,16); sum[date]+=$11; count[date]++; } END { for (date in sum) { printf "%s;%.2f\n", date, sum[date]/count[date] } }' $file | sort -k1,2 -t\; >> $output
		gen_graph/./t2_graph.sh
		
				
	elif [[ ${argt} -eq 3 ]]; then
			
		output="avg_temp_by_date_and_ID.csv"
		tail -n +2 $file | 

		awk -F ";" '{print $1 ";" $2 ";" $11}' | 

		sort -t ";" -k2 | 

		awk -F ";" '{key=$1 ";" $2; sum[key]+=$3; count[key]++} END {for (key in sum) {print key ";" sum[key]/count[key]}}' | 

		sort -t ";" -n -k2,3 -k1 > $output
			
	elif [ -z "$argt" ]; then
		echo "Erreur ! Le mode pour -t a besoin d'un argument !"
		exit 1

	else
		echo "Erreur ! Le mode pour -t doit être compris entre 1 et 3."
		exit 1
	fi
fi

# /!\ All the commands below are similar to the -t command, see below if you need more information /!\

if [[ ${pressure} == true ]]; then
	if [[ ${argp} -eq 1 ]]; then	
		awk -F";" 'NR>1 {
		id[$1]++;
		sum[$1] += $7;
		}
		END {
		for (i in id) {
			avg = sum[i] / id[i];
			print i ";" avg;
		}
		}' $file > tmp.csv
			
		sort -t";" -n -k1 tmp.csv > avg_pressure_by_ID.csv
		rm tmp.csv
			
		awk -F";" 'NR > 1 {
		id[$1]++;
		sum[$1] += $7;
		if ($11 < min[$1] || !min[$1]) {
			min[$1] = $7;
		}
		if ($11 > max[$1] || !max[$1]) {
			max[$1] = $7;
		}
		}
		END {
		for (i in id) {
			print i ";" min[i] ";" max[i];
		}
		}' $file > tmp.csv
			
		sort -t";" -n -k1 tmp.csv > min_max_pressure_by_ID.csv
		rm tmp.csv
			
	elif [[ ${argp} -eq 2 ]]; then      	
		output="avg_pressure_by_date.csv"
		rm -f $output

		awk -F";" 'NR > 1 { date=substr($2,1,16); sum[date]+=$7; count[date]++; } END { for (date in sum) { printf "%s;%.2f\n", date, sum[date]/count[date] } }' $file | sort -k1 -t\; >> $output
		gen_graph/./p2_graph.sh	
		
	elif [[ ${argp} -eq 3 ]]; then
		output="avg_pressure_by_date_and_ID.csv"
		tail -n +2 $file | 

		awk -F ";" '{print $1 ";" $2 ";" $7}' | 
		sort -t ";" -k2 | 
		awk -F ";" '{key=$1 ";" $2; sum[key]+=$3; count[key]++} END {for (key in sum) {print key ";" sum[key]/count[key]}}' | 
		sort -t ";" -n -k2,3 -k1 > $output

	elif [ -z "$argp" ]; then
		echo "Erreur ! Le mode pour -p a besoin d'un argument !"
		exit 1
	else
		echo "Erreur ! Le mode pour -p doit être compris entre 1 et 3."
		exit 1
	fi  
fi

if [[ ${wind} == true ]]; then
	

	#If output files already exists then delete them to avoid conflicts

	if [ -e wind_direction.csv ]; then
		rm wind_direction.csv
	fi
		
	if [ -e wind_speed.csv ]; then
		rm wind_speed.csv
	fi

	cut -d ';' -f 1 $file | sort > sorted_station.csv
	cut -d ';' -f 1,4 $file | sort > wind_direction_sorted.csv
	cut -d ';' -f 1,5 $file | sort > wind_speed_sorted.csv
	station=$(head -n 1 sorted_station.csv)
		
	while [[ "$station" !=  *ID* ]] && [ -n "$station" ]
	do
		station=$(head -n 1 sorted_station.csv)
		grep -e "$station" wind_direction_sorted.csv | cut -d ';' -f 2 | awk '{ sum += $1; count++ } END { print sum/count >> "wind_direction.csv" }'
		grep -e "$station" wind_speed_sorted.csv | cut -d ';' -f 2 | awk '{ sum += $1; count++ } END { print sum/count >> "wind_speed.csv" }'
		sed -i "/${station}/d" sorted_station.csv
	done
		
	sed -i '$d' wind_direction.csv
	sed -i '$d' wind_speed.csv
	rm wind_direction_sorted.csv
	rm wind_speed_sorted.csv
	rm sorted_station.csv
fi
