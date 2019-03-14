# Uptake Prokect 18 - DPIRD
### Pawsey: Marco De La Pierre, Yathu Sivarajah
### DPIRD: Monica Kehoe, Sam Hair

This is a project for porting existing workflows into Zeus on an all-open source software stack.

Science: plant/animal pathogen genome sequencing from Illumina and Nanopore.

Computing: containerisation, workflow automation (bash), porting of input parameters, tuning of multi-threading/memory requirements, visualisation tools.

Contents: 
* [illumina](illumina/): scripts for Illumina NGS pipeline
* [nanopore](nanopore/): scripts for Nanopore pipeline
* [dockerfiles](dockerfiles/): for samtools, bcftools, pomoxis
* [cygnet](cygnet/): [maali](https://github.com/PawseySC/maali) recipes for IGV vis tool
* [software_more](software_more/): install instructions for Megan vis tool

**Note**: these scripts have been developed for the the needs of a specific research team, and are a work in progress. Anyone is welcome to take and adapt them to their own workflows, having in mind it is their responsibility to ensure they produce the correct results.

Find us on [GitHub](https://github.com/PawseySC/dpird-mk)
