"""
	grdsample(cmd0::String="", arg1=nothing, kwargs...)

Reads a grid file and interpolates it to create a new grid file with either: a
different registration; or a new grid-spacing or number of nodes, and perhaps
also a new sub-region

Full option list at [`grdsample`]($(GMTdoc)grdsample.html)

Parameters
----------

- **G** | **save** | **outgrid** | **outfile** :: [Type => Str]

    Output grid file name. Note that this is optional and to be used only when saving
    the result directly on disk. Otherwise, just use the G = grdsample(....) form.
    ($(GMTdoc)grdsample.html#g)
- $(GMT.opt_I)
    ($(GMTdoc)grdsample.html#i)
- $(GMT.opt_R)
- **T** | **toggle** :: [Type => Bool]

    Toggle the node registration for the output grid so as to become the opposite of the input grid
    ($(GMTdoc)grdsample.html#t)
- $(GMT.opt_V)
- $(GMT.opt_f)
- $(GMT.opt_n)
- $(GMT.opt_r)
- $(GMT.opt_x)
"""
function grdsample(cmd0::String="", arg1=nothing; kwargs...)

	length(kwargs) == 0 && return monolitic("grdsample", cmd0, arg1)

	d = init_module(false, kwargs...)[1]		# Also checks if the user wants ONLY the HELP mode
	cmd, = parse_common_opts(d, "", [:G :RIr :V_params :f :n :x])
	cmd  = parse_these_opts(cmd, d, [[:T :toggle]])

	common_grd(d, cmd0, cmd, "grdsample ", arg1)		# Finish build cmd and run it
end

# ---------------------------------------------------------------------------------------------------
grdsample(arg1, cmd0::String=""; kw...) = grdsample(cmd0, arg1; kw...)