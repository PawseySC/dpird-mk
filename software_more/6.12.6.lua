help("Sets up the paths you need to use megan version 6.12.6")
local version = '6.12.6'
local tool = 'megan'
whatis( [[MEGAN6 is a comprehensive toolbox for interactively analyzing microbiome data. 
All the interactive tools you need in one application.

For further information see http://ab.inf.uni-tuebingen.de/software/megan6]] )
load("java")
if (mode() ~= "whatis") then
prepend_path("PATH","/group/director2091/software/sles12sp3/apps/binary/megan/6.12.6")
end
