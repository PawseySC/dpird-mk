#!/bin/bash

#albacore
export albacore_cont='genomicpariscentre/albacore:2.3.3'
alias albacore_bash='shifter run $albacore_cont bash'
alias read_fast5_basecaller_py='shifter run $albacore_cont read_fast5_basecaller.py'

#nanoplot
export nanoplot_cont='quay.io/biocontainers/nanoplot:1.18.2--py36_1'
alias nanoplot_bash='shifter run $nanoplot_cont bash'
alias NanoPlot='shifter run $nanoplot_cont NanoPlot'

#filtlong
export filtlong_cont='quay.io/biocontainers/filtlong:0.2.0--he941832_2'
alias filtlong_bash='shifter run $filtlong_cont bash'
alias filtlong='shifter run $filtlong_cont filtlong'

#pomoxis
export pomoxis_cont='dpirdmk/pomoxis:0.1.11'
alias pomoxis_bash='shifter run $pomoxis_cont init.sh bash'
alias mini_align='shifter run $pomoxis_cont init.sh mini_align'
alias mini_assemble='shifter run $pomoxis_cont init.sh mini_assemble'
alias bwa_align='shifter run $pomoxis_cont init.sh bwa_align'
alias epi3me='shifter run $pomoxis_cont init.sh epi3me'

#nanopolish
export nanopolish_cont='quay.io/biocontainers/nanopolish:0.10.2--h78a5b34_0'
alias nanopolish_bash='shifter run $nanopolish_cont bash'
alias nanopolish='shifter run $nanopolish_cont nanopolish'
alias nanopolish_makerange_py='shifter run $nanopolish_cont python /usr/local/bin/nanopolish_makerange.py'
alias nanopolish_merge_py='shifter run $nanopolish_cont python /usr/local/bin/nanopolish_merge.py'
