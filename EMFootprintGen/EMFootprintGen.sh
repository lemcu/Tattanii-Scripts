#!/bin/bash
if [ -f ../output/packages.pac ];
then
   rm ../output/packages.pac
fi
perl generateQF.pl QFN24 0.80 0.30 3.60 0.65 0.65 5 5 6 6 5 5 0.12 0.10 1.0 1.0 0.5 >> ../output/packages.pac
perl generateQF.pl QFN32 0.80 0.35 4.40 0.65 0.65 6 6 8 8 6 6 0.12 0.10 1.30 1.30 0.50 >> ../output/packages.pac
perl generateQF.pl QFN64 0.85 0.30 7.20 0.50 0.50 8.90 8.90 16 16 9 9 0.12 0.10 2.70 2.70 0.80 >> ../output/packages.pac
perl generateQF.pl QFP48 1.60 0.30 0 0.50 0.50 8.50 8.50 12 12 7 7 0.12 0.1 0 0 0 >> ../output/packages.pac
perl generateQF.pl QFP64 1.60 0.30 0 0.50 0.50 11.50 11.50 16 16 10 10 0.12 0.1 0 0 0 >> ../output/packages.pac
perl generateQF.pl QFP100 1.45 0.30 0 0.50 0.50 15.40 15.40 25 25 14 14 0.12 0.1 0 0 0 >> ../output/packages.pac
perl generateBGA.pl BGA120 120 13 13 0.25 0.50 6 7 7 0.10 0.0 >> ../output/packages.pac
perl generateBGA.pl BGA112 112 11 11 0.35 0.80 8 10 10 0.13 0.20 >> ../output/packages.pac
perl generateBGA.pl BGA48 48 7 7 0.25 0.50 3 4 4 0.03 0.0 >> ../output/packages.pac
