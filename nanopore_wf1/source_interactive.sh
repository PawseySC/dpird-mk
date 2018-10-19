#!/bin/bash

#albacore
export albacore_cont="genomicpariscentre/albacore:2.3.3"
export albacore_bash="shifter run $albacore_cont bash"
export read_fast5_basecaller_py="shifter run $albacore_cont read_fast5_basecaller.py"

#nanoplot
export nanoplot_cont="quay.io/biocontainers/nanoplot:1.18.2--py36_1"
export nanoplot_bash="shifter run $nanoplot_cont bash"
export NanoPlot="shifter run $nanoplot_cont NanoPlot"

#filtlong
export filtlong_cont="quay.io/biocontainers/filtlong:0.2.0--he941832_2"
export filtlong_bash="shifter run $filtlong_cont bash"
export filtlong="shifter run $filtlong_cont filtlong"

#pomoxis
export pomoxis_cont="dpirdmk/pomoxis:0.1.11"
export pomoxis_bash="shifter run $pomoxis_cont init.sh bash"
export mini_align="shifter run $pomoxis_cont init.sh mini_align"
export mini_assemble="shifter run $pomoxis_cont init.sh mini_assemble"
export bwa_align="shifter run $pomoxis_cont init.sh bwa_align"
export epi3me="shifter run $pomoxis_cont init.sh epi3me"

#nanopolish
export nanopolish_cont="quay.io/biocontainers/nanopolish:0.10.2--h78a5b34_0"
export nanopolish_bash="shifter run $nanopolish_cont bash"
export nanopolish="shifter run $nanopolish_cont nanopolish"
export nanopolish_makerange_py="shifter run $nanopolish_cont python /usr/local/bin/nanopolish_makerange.py"
export nanopolish_merge_py="shifter run $nanopolish_cont python /usr/local/bin/nanopolish_merge.py"
