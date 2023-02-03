#include <stdio.h>
#include <string.h>

const char* column_names[] = {
  "ID OMM station",
  "Date",
  "Pression au niveau mer",
  "Direction du vent moyen 10 mn",
  "Vitesse du vent moyen 10 mn",
  "Humidite",
  "Pression station",
  "Variation de pression en 24 heures",
  "Precipitations dans les 24 dernieres heures",
  "Coordonnees",
  "Temperature (°C)",
  "Temperature minimale sur 24 heures (°C)",
  "Temperature maximale sur 24 heures (°C)",
  "Altitude",
  "communes (code)",
};

int main() {
  FILE* fp = fopen("meteo.csv", "r");
  if (!fp) {
    printf("Can't open file\n");
    return 1;
  }
    
  FILE* fp_new = fopen("meteo_new.csv", "w");
  if (!fp_new) {
    printf("Can't create new file\n");
    return 1;
  }
  
  char buffer[200000];
  int row = 0;
  while (fgets(buffer, 200000, fp)) {
    if (row++ == 0) {
      fputs(buffer, fp_new);
      continue;
    }

    char* value = strtok(buffer, "; ");
    int column = 0;
    while (value) {
      if (column > 0)
        fputs(";", fp_new);
      fputs(value, fp_new);
      value = strtok(NULL, "; ");
      column++;
    }
    fputs("\n", fp_new);
  }

  fclose(fp);
  fclose(fp_new);
  return 0;
}