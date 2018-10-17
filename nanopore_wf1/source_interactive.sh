#!/bin/bash

#albacore
export albacore_cont="genomicpariscentre/albacore:2.3.3"
export albacore_bash="shifter run $albacore_cont bash"
export read_fast5_basecaller_py="shifter run $albacore_cont read_fast5_basecaller.py"

#pomoxis

#nanopolish
export nanopolish_cont="quay.io/biocontainers/nanopolish:0.10.2--h78a5b34_0"
export nanopolish_bash="shifter run $nanopolish_cont bash"
export nanopolish="shifter run $nanopolish_cont nanopolish"
export nanopolish_makerange_py="shifter run $nanopolish_cont python /usr/local/bin/nanopolish_makerange.py"
export nanopolish_merge_py="shifter run $nanopolish_cont python /usr/local/bin/nanopolish_merge.py"
