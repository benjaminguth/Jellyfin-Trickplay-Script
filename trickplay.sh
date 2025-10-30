#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_or_folder>"
    exit 1
fi

# Creates Trickpal images for a file
create_trickplay() {
    input_file="$1"
    directory="$(dirname "$input_file")/${input_file%.*}.trickplay/320 - 10x10"

    if [ -d "$directory" ]; then
        echo "Directory exists not overriding."
        exit 1
    else
    	# Create the folder structure
        mkdir -p "$directory/tmp"
        
        echo "creating stills ..."

        ffmpeg -i "$input_file" -an -sn -vf "fps=0.1,setparams=color_primaries=bt709:color_trc=bt709:colorspace=bt709,scale=trunc(min(max(iw\,ih*(a*sar))\,320)/2)*2:trunc(ow/(a*sar)/2)*2,format=yuv420p" -c:v mjpeg -qscale:v 4 -fps_mode passthrough -f image2 "$directory/tmp/%08d.jpg"
        
        if [[ $? -ne 0 ]]; then
            echo "stills creation failed"
            return 1
        fi
        echo "creating grids..."

        total_images=$(ls -1 "$directory/tmp" | grep '^[0-9]\{8\}\.jpg$' | wc -l)
        tile_size=100
        index=0

        while [ $index -lt $total_images ]; do
            ffmpeg -loglevel error -start_number $index -i "$directory/tmp/%08d.jpg" -vf "tile=10x10" -frames:v 1 "$directory/$((index / tile_size)).jpg"  
            if [[ $? -ne 0 ]]; then
                echo "grid creation failed"
                return 1
            fi
            index=$(( index + tile_size + 1))
        done

        echo "cleaning up..."
        rm -r "$directory/tmp"
        echo "successfully created trickplay files for $input_file"
    fi

}



# Check if the argument is a file or a directory
if [ -d "$1" ]; then
    # If it's a directory, process all video files
    for file in "$1"/*; do
        if [[ $file == *.mp4 || $file == *.mkv || $file == *.avi || $file == *.MTS || $file == *.mov ]]; then
            create_trickplay "$file"
        fi
    done
elif [ -f "$1" ]; then
    # If it's a file, process it directly
    create_trickplay "$1"

else
    echo "Error: $1 is not a valid file or directory."
    exit 1
fi
