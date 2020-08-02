set -a # Export everything you see here

# I'm lazy piping to less :)
# In some cases like sudo this doesn't work because of shell-subshell problem.
toless ()
{
	local COLORIZED=1
	args=( $@ )

	$1 ${args[@]:1} | less $( [ $COLORIZED -eq 1 ] && echo "-r")
}

# This is a python module that compiles other python modules in cpython style.
alias pycompile="python -m compileall"

# This sometimes returns no result.
ipresolve()
{
	dig +noall +answer $1 | cut -f 6

}

# Installing such packages with pip and using pycompile is much more convenient.
# However, I'm not sure about CFLAGS, LDFLAGS and other compile related flags in this case.
alias tldr="python -m tldr" 

set +a # Stop exporting
