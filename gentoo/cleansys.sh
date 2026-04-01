emerge -aqc

EXIT_STATUS=$(echo $?)

if [[ $EXIT_STATUS != 0 ]]
then
	exit $EXIT_STATUS
fi

eclean-dist -d && eclean-pkg -d

echo "> Finishing..."

emaint cleanconfmem --fix
emaint movebin --fix
emaint moveinst --fix
emaint world --fix

