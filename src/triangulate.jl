"""
	triangulate(cmd0::String="", arg1=nothing; kwargs...)

Reads one or more ASCII [or binary] files (or standard input) containing x,y[,z] and performs Delaunay
triangulation, i.e., it find how the points should be connected to give the most equilateral
triangulation possible. 

Full option list at [`triangulate`]($(GMTdoc)triangulate.html)

Parameters
----------
- **C** | **slope_grid** :: [Type => Number]

    Read a slope grid (in degrees) and compute the propagated uncertainty in the
    bathymetry using the CURVE algorithm
    ($(GMTdoc)triangulate.html#a)
- **D** | **derivatives** :: [Type => Str]

    Take either the x- or y-derivatives of surface represented by the planar facets (only used when G is set).
    ($(GMTdoc)triangulate.html#d)
- **E** | **empty** :: [Type => Str | Number]

    Set the value assigned to empty nodes when G is set [NaN].
    ($(GMTdoc)triangulate.html#e)
- **G** | **save** | **outgrid** | **outfile** :: [Type => Str]

    Use triangulation to grid the data onto an even grid (specified with R I).
    Append the name of the output grid file.
    ($(GMTdoc)triangulate.html#g)
- $(GMT.opt_I)
    ($(GMTdoc)triangulate.html#i)
- $(GMT.opt_J)
- **M** | **network** :: [Type => Bool]

    Output triangulation network as multiple line segments separated by a segment header record.
    ($(GMTdoc)triangulate.html#m)
- **N** | **ids** :: [Type => Bool]

    Used in conjunction with G to also write the triplets of the ids of all the Delaunay vertices
    ($(GMTdoc)triangulate.html#n)
- **Q** | **voronoi** :: [Type => Str | []]

    Output the edges of the Voronoi cells instead [Default is Delaunay triangle edges]
    ($(GMTdoc)triangulate.html#q)
- $(GMT.opt_R)
- **S** | **triangles** :: [Type => Bool]  

    Output triangles as polygon segments separated by a segment header record. Requires Delaunay triangulation.
    ($(GMTdoc)triangulate.html#s)
- **T** | **edges** :: [Type => Bool]

    Output edges or polygons even if gridding has been selected with the G option
    ($(GMTdoc)triangulate.html#t)
- $(GMT.opt_V)
- **Z** | **xyz** | **triplets** :: [Type => Bool]

    ($(GMTdoc)triangulate.html#z)
- $(GMT.opt_bi)
- $(GMT.opt_bo)
- $(GMT.opt_di)
- $(GMT.opt_e)
- $(GMT.opt_f)
- $(GMT.opt_h)
- $(GMT.opt_i)
- $(GMT.opt_r)
- $(GMT.opt_w)
- $(GMT.opt_swap_xy)
"""
function triangulate(cmd0::String="", arg1=nothing; kwargs...)

	length(kwargs) == 0 && return monolitic("triangulate", cmd0, arg1)

	d = init_module(false, kwargs...)[1]		# Also checks if the user wants ONLY the HELP mode
	cmd, = parse_common_opts(d, "", [:G :RIr :V_params :bi :bo :di :e :f :h :i :w :yx])
	cmd  = parse_these_opts(cmd, d, [[:C :slope_grid], [:D :derivatives], [:E :empty], [:M :network],
                                     [:N :ids], [:S :triangles], [:T :edges], [:Z :xyz :triplets]])
	cmd = parse_Q_tri(d, [:Q :voronoi], cmd)
	if (occursin("-I", cmd) && occursin("-R", cmd) && !occursin("-G", cmd)) cmd *= " -G"  end
	if (!occursin("-G", cmd)) cmd, = parse_J(d, cmd)  end

	common_grd(d, cmd0, cmd, "triangulate ", arg1)		# Finish build cmd and run it
end

# ---------------------------------------------------------------------------------------------------
function parse_Q_tri(d::Dict, symbs::Array{Symbol}, cmd::String)
	(show_kwargs[1]) && return print_kwarg_opts(symbs, "Bool | String")	# Just print the options
	if ((val = find_in_dict(d, symbs)[1]) !== nothing)
		cmd *= " -Q";   val_ = string(val)
		(startswith(val_, "pol")) && (cmd *= "n")
    end
    return cmd
end

# ---------------------------------------------------------------------------------------------------
triangulate(arg1::Array, cmd0::String=""; kw...) = triangulate(cmd0, arg1; kw...)