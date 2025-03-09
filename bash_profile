# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
## Tecplot environment
PATH="$PATH:/opt/tecplot/360ex_2019r1/bin"

TECHOME="opt/tecplot/360ex_2019r1"
TECPHYFILE={$HOME/.tecplot.phy}
#LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/tecplot/360ex_2019r1/bin:/opt/tecplot/360ex_2019r1/bin/sys-util"
export TECHOME
export TECPHYFILE
#export LD_LIBRARY_PATH
