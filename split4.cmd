
ffmpeg -i %1 -threads 3 -acodec copy -f segment -segment_time 20:00 -segment_start_number 1 -metadata album="%~n1" "%%04d %~n1.m4a"