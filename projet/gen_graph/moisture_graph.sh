#!/bin/bash

gnuplot << EOF
set terminal png
set title 'Humidité par stations'
set xlabel 'Longitude'
set ylabel 'Latitude'
set output "max_moisture_by_ID.png"
set datafile separator ","
set view map
set dgrid3d
set pm3d interpolate 10,10
splot "max_moisture_by_ID.csv" using 2:1:3 with pm3d title "humidite"
EOF
