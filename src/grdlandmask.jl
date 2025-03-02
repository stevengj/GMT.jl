"""
	grdlandmask([monolithic::String="";] area=, resolution=, bordervalues=, save=, maskvalues=, registration=, verbose=, cores=)

Create a grid file with set values for land and water.

Read the selected shoreline database and create a grid to specify which nodes in the specified grid
are over land or over water. The nodes defined by the selected region and lattice spacing will be
set according to one of two criteria: (1) land vs water, or (2) the more detailed (hierarchical)
ocean vs land vs lake vs island vs pond.

Full option list at [`grdlandmask`]($(GMTdoc)grdlandmask.html)

Parameters
----------

- $(GMT.opt_R)
- $(GMT.opt_I)
    ($(GMTdoc)grdlandmask.html#i)
- **A** | **area** :: [Type => Str | Number]

    Features with an area smaller than min_area in km^2 or of hierarchical level that is lower than min_level
    or higher than max_level will not be plotted.
    ($(GMTdoc)grdlandmask.html#a)
- **D** | **res** | **resolution** :: [Type => Str]

    Selects the resolution of the data set to use ((f)ull, (h)igh, (i)ntermediate, (l)ow, and (c)rude).
    ($(GMTdoc)grdlandmask.html#d)
- **E** | **bordervalues** :: [Type => Str | List]    ``Arg = cborder/lborder/iborder/pborder or bordervalue``

    Nodes that fall exactly on a polygon boundary should be considered to be outside the polygon
    [Default considers them to be inside].
    ($(GMTdoc)grdlandmask.html#e)
- **G** | **save** | **outgrid** | **outfile** :: [Type => Str]

    Output grid file name. Note that this is optional and to be used only when saving
    the result directly on disk. Otherwise, just use the G = grdlandmask(....) form.
    ($(GMTdoc)grdlandmask.html#g)
- **N** | **maskvalues** | **mask** :: [Type => Str | List]    ``Arg = wet/dry or ocean/land/lake/island/pond``

    Sets the values that will be assigned to nodes. Values can be any number, including the textstring NaN
    ($(GMTdoc)grdlandmask.html#n)
- $(GMT.opt_V)
- $(GMT.opt_r)
- $(GMT.opt_x)
"""
function grdlandmask(cmd0::String=""; kwargs...)

	length(kwargs) == 0 && return monolitic("grdlandmask", cmd0, nothing)

	d = init_module(false, kwargs...)[1]		# Also checks if the user wants ONLY the HELP mode
	cmd, = parse_common_opts(d, "", [:G :RIr :V_params :x])
	cmd  = parse_these_opts(cmd, d, [[:A :area], [:D :res :resolution], [:E :bordervalues], [:N :mask :maskvalues]])
	return common_grd(d, "grdlandmask " * cmd, nothing)		# Finish build cmd and run it
end