#!/bin/bash

# Fichier csv en entrée
file="avg_temp_by_date.csv"

# Utilise gnuplot pour générer la courbe
gnuplot <<- EOF
  set terminal png
  set output "Temperature2.png"
  set datafile separator ";"
  set xdata time
  set timefmt "%Y-%m-%dT%H:%M"
  set format x "%Y-%m-%d\n%H:%M"
  set xtics rotate
  set ytics nomirror
  set grid
  set title "Températures journalières"
  set xlabel "Date"
  set ylabel "Température (en °C)"
  plot "$file" using 1:2 with lines linetype rgb 'orange' title "temp"
EOF

