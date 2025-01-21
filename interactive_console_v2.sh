#!/bin/bash
arguemnts=()
files_array=()
path=""
max_lines=20
is_wc_method=false
output_orientation="tail"

for a in $@; do
    arguemnts+=($a)
done

for index in ${!arguemnts[@]}; do	
    # echo ${arguemnts[$index]}

    if [ ${arguemnts[$index]} = "--help" ] | [ ${arguemnts[$index]} = "-h" ]; then
        echo "--path: Establece la ruta de donde se alojan los archivos a leer de forma dinamica."
        echo ""

        echo "------------------------------------------------------------------------"
        echo "-wc: Te proporciona una consola interactiva solo arrojando los ultimos cambios que afecten los archivos del directorio seleccionado"
        echo "Nota este argumento es mas lento a mayor cantidad de lineas poseean los archivos. no usar con el parametro -l"
        echo ""

        echo "------------------------------------------------------------------------"
        echo "-l: Cantidad de lineas a mostras, de no establecer nada mostrara las ultimas 20 lineas de cada archivo modificado."
        echo ""

        echo "------------------------------------------------------------------------"
        echo "--head: Muestra las primeras lineas de cada archivo que sea modificado."
        echo ""
        exit 1
    fi

    if [ ${arguemnts[$index]} = "--path" ]; then

        arg_value=$((index+1))
        path=$(echo "${arguemnts[$arg_value]}/" | tr -s '/')
        continue
    fi

    if [ ${arguemnts[$index]} = "-l" ]; then

        arg_value=$((index+1))
        max_lines=${arguemnts[$arg_value]}
        continue
    fi

    if [ ${arguemnts[$index]} = "--head" ]; then

        output_orientation="head"
        continue
    fi

    if [ ${arguemnts[$index]} = "-wc" ]; then
        is_wc_method=true
        continue
    fi
done

files_list=$(echo $(ls $path))
echo $files_list

use_wc_method () {
    if [ "$is_wc_method" = true ] ; then

        path="$path*"
        files_array=()

        if [[ ${#files_array[@]} -eq 0 ]]; then
                
            for f in $path; do
                file=$(echo $f | tr -s '/')
                wc_char_list=$(wc -l $file | cut -d ' ' -f 1)
                files_array+=("$file|$wc_char_list")  
            done

            echo ${files_array[@]}
        fi

        while true
        do
            for index in ${!files_array[@]}; do

                selected_file=$(echo ${files_array[$index]} | cut -d '|' -f 1)
                selected_file_wc_from_array=$(echo ${files_array[$index]} | cut -d '|' -f 2)
                new_wc_of_file=$(wc -l $selected_file | cut -d ' ' -f 1)

                if [[ $new_wc_of_file > $selected_file_wc_from_array ]]; then

                    files_array[$index]="$selected_file|$new_wc_of_file"
                    qty_lines=$((new_wc_of_file-selected_file_wc_from_array))

                    tail -n $qty_lines -v $selected_file
                fi
            done

        done

    fi
}

set_date_for_array () {
    modify_file_date_all=$(stat -c %y "$path$file")
    modify_file_date=$(echo $modify_file_date_all | cut -d ' ' -f 1)
    modify_file_time=$(echo $modify_file_date_all | cut -d ' ' -f 2)
}

use_wc_method

if [[ ${#files_array[@]} -eq 0 ]]; then
		
	for file in $files_list; do
		
        set_date_for_array
        files_array+=("$file|$modify_file_date|$modify_file_time")

	done
fi

while true
do
    for index in ${!files_array[@]}; do	

        file=$(echo ${files_array[$index]} | cut -d '|' -f 1)
        modify_file_date_in_array=$(echo ${files_array[$index]} | cut -d '|' -f 2)
        modify_file_time_in_array=$(echo ${files_array[$index]} | cut -d '|' -f 3)

        set_date_for_array
        if [[ "$modify_file_date $modify_file_time" > "$modify_file_date_in_array $modify_file_time_in_array" ]];
        then

            files_array[$index]="$file|$modify_file_date|$modify_file_time"
			qty_lines=$max_lines
			$output_orientation -n $qty_lines -v "$path$file"
        fi

    done
done