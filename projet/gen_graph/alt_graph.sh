#!/bin/bash

gnuplot << EOF
set terminal png
set title 'Altitude par stations'
set xlabel 'Longitude'
set ylabel 'Latitude'
set output "height_by_ID_station.png"
set datafile separator ","
set view map
set dgrid3d
set pm3d interpolate 10,10
splot "height_by_ID_station.csv" using 2:1:3 with pm3d title "altitude"
EOF
