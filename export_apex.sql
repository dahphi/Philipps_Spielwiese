!git fetch origin;
project export -o apex.2022;
!git add .
!git commit -m "Exporting APEX 2022 project";
!git push
project stage
!git add .
!git commit -m "Staging APEX 2022 project";
!git push
project release -version 2022_2_0001;
!git add .
!git commit -m "Release APEX 2022 project";
!git push
project gen-artifact -version 2022_2_0001;
!git add .
!git commit -m "Generating APEX 2022 artifact";
!git push