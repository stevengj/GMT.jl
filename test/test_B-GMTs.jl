	println("	GMTINFO")
	gmt("gmtset -");
	r = gmt("gmtinfo -C", ones(Float32,9,3)*5);
	@assert(r[1].data == [5.0 5 5 5 5 5])
	r = gmtinfo(ones(Float32,9,3)*5, C=true, V=:q);
	@assert(r[1].data == [5.0 5 5 5 5 5])
	#gmtinfo(help=0)

	println("	BLOCK*s")
	d = [0.1 1.5 1; 0.5 1.5 2; 0.9 1.5 3; 0.1 0.5 4; 0.5 0.5 5; 0.9 0.5 6; 1.1 1.5 7; 1.5 1.5 8; 1.9 1.5 9; 1.1 0.5 10; 1.5 0.5 11; 1.9 0.5 12];
	G = blockmedian(region=[0 2 0 2], inc=1, fields="z", reg=true, d);
	if (G !== nothing)	# If run from GMT5 it will return nothing
		G = blockmean(d, region=[0 2 0 2], inc=1, grid=true, reg=true, S=:n);	# Number of points in cell
		G,L = blockmode(region=[0 2 0 2], inc=1, fields="z,l", reg=true, d);
		G,L,H = blockmode(d, region=[0 2 0 2], inc=1, fields="z,l,h", reg=true)
	end
	D = blockmedian(region=[0 2 0 2], inc=1,  reg=true, d);
	D = blockmean(region=[0 2 0 2], inc=1,  reg=true, d);
	D = blockmode(region=[0 2 0 2], inc=1,  reg=true, d);

	println("	CONTOURF")
	G = GMT.peaks();
	gmtwrite("lixo.grd", G)
	C = makecpt(T=(-7,9,2));
	contourf("lixo.grd", Vd=dbg2)
	contourf(G, Vd=dbg2)
	contourf!(G, C=C, Vd=dbg2)
	contourf("lixo.grd", contour=[-2, 0, 2, 5], Vd=dbg2)
	contourf!("lixo.grd", contour=[-2, 0, 2, 5], grd=true, Vd=dbg2)
	contourf(G, C, contour=[-2, 0, 2, 5], Vd=dbg2)
	contourf(G, C, annot=:none, Vd=dbg2)
	d = [0 2 5; 1 4 5; 2 0.5 5; 3 3 9; 4 4.5 5; 4.2 1.2 5; 6 3 1; 8 1 5; 9 4.5 5];
	contourf(d, limits=(-0.5,9.5,0,5), pen=0.25, labels=(line=(:min,:max),), Vd=dbg2)
	C = makecpt(range=(0,10,1));
	contourf(d, C, limits=(-0.5,9.5,0,5), pen=0.25, labels=(line=(:min,:max),), Vd=dbg2)
	contourf(d, C=C, limits=(-0.5,9.5,0,5), pen=0.25, labels=(line=(:min,:max),), Vd=dbg2)

	println("	EARTHTIDE")
	earthtide();
	earthtide(S="");
	earthtide(L=(0,0));

	# FILTER1D
	filter1d([collect((1.0:50)) rand(50)], F="m15");

	println("	FITCIRCLE")
	d = [-3.2488 -1.2735; 7.46259 6.6050; 0.710402 3.0484; 6.6633 4.3121; 12.188 18.570; 8.807 14.397; 17.045 12.865; 19.688 30.128; 31.823 33.685; 39.410 32.460; 48.194 47.114; 62.446 46.528; 59.865 46.453; 68.739 50.164; 64.334 32.984];
	fitcircle(d, L=3);

	println("	GMT2KML & KML2GMT")
	D = gmt("pscoast -R-5/-3/56/58 -Jm1i -M -W0.25p -Di");
	K = gmt2kml(D, F=:l, W=(1,:red));
	gmtwrite("lixo.kml", K)
	kml2gmt("lixo.kml", Z=true);
	kml2gmt(nothing, "lixo.kml", Z=true);	# yes, cheating
	gmtread("lixo.kml", Vd=dbg2);
	#gmtread("lixo.kml");		# Because Travis CI oldness
	rm("lixo.kml")

	println("	GMTCONNECT")
	gmtconnect([0 0; 1 1], [1.1 1.1; 2 2], T=0.5);

	println("	GMTCONVERT")
	gmtconvert([1.1 2; 3 4], o=0)

	println("	GMTGRAVMAG3D")
	if (GMTver > v"6.1.1")
		gmtgravmag3d(M=(shape=:prism, params=(1,1,1,5)), I=1.0, R="-15/15/-15/15", H="10/60/10/-10/40", Vd=dbg2);
		@test_throws ErrorException("Missing one of 'index', 'raw_triang' or 'str' data") gmtgravmag3d(I=1.0);
		@test_throws ErrorException("For grid output MUST specify grid increment ('I' or 'inc')") gmtgravmag3d(Tv=true);
	end

	println("	GMTREGRESS")
	d = [0 5.9 1e3 1; 0.9 5.4 1e3 1.8; 1.8 4.4 5e2 4; 2.6 4.6 8e2 8; 3.3 3.5 2e2 2e1; 4.4 3.7 8e1 2e1; 5.2 2.8 6e1 7e1; 6.1 2.8 2e1 7e1; 6.5 2.4 1.8 1e2; 7.4 1.5 1 5e2];
	regress(d, E=:y, F=:xm, N=2, T="-0.5/8.5/2+n");

	println("	GMTLOGO")
	logo(D="x0/0+w2i")
	logo(julia=8)
	logo(GMTjulia=8, fmt=:png, Vd=dbg2)
	logo(GMTjulia=2, savefig="logo.PNG")
	logo(GMTjulia=2, fmt=:PNG)
	logo!(julia=8, Vd=dbg2)
	logo!("", julia=8, Vd=dbg2)
	@test startswith(logo(pos=(anchor=(0,0),justify=:CM, offset=(1.5,0)), Vd=dbg2), "gmtlogo -Jx1 -Dg0/0+jCM+o1.5/0")
	logo!(julia=8, Vd=dbg2)
	logo!("", julia=8, Vd=dbg2)

	println("	GMTSPATIAL")
	# GMTSPATIAL
	# Test  Cartesian centroid and area
	result = gmt("gmtspatial -Q", [0 0; 1 0; 1 1; 0 1; 0 0]);
	@assert(isapprox(result[1].data, [0.5 0.5 1]))
	# Test Geographic centroid and area
	result = gmt("gmtspatial -Q -fg", [0 0; 1 0; 1 1; 0 1; 0 0]);
	# Intersections
	l1 = gmt("project -C22/49 -E-60/-20 -G20 -Q");
	l2 = gmt("project -C0/-60 -E-60/-30 -G20 -Q");
	#int = gmt("gmtspatial -Ie -Fl", l1, l2);       # Error returned from GMT API: GMT_ONLY_ONE_ALLOWED (59)
	if (GMTver > v"6.2")
		int = gmtspatial((l1, l2), I=:e, F="l");
	end
	d = [-300 -3500; -200 -800; 400 -780; 500 -3400; -300 -3500];
	gmtspatial(d, C=true, R="0/100/-3100/-3000");

	println("	GMTSELECT")
	gmtselect([2 2], R=(0,3,0,3));		# But is bugged when answer is []
	@test gmtselect([1 2], C=(pts="aa",dist=10), Vd=dbg2) == "gmtselect  -Caa+d10"
	@test gmtselect([1 2], C=(pts=[1 2],dist=10), Vd=dbg2) == "gmtselect  -C+d10"
	@test gmtselect([1 2], C="aa+d0", Vd=dbg2) == "gmtselect  -Caa+d0"
	@test gmtselect([1 2], C=(pts=[1 2],dist=10), L=(line=[1 2;3 4], dist=10), Vd=dbg2) == "gmtselect  -C+d10 -L+d10"

	println("	GMTSET")
	gmtset(MAP_FRAME_WIDTH=0.2)

	println("	GMTSIMPLIFY")
	gmtsimplify([0.0 0; 1.1 1.1; 2 2.2; 3.3 3], T="3k")

	println("	GMTREADWRITE")
	G=gmt("grdmath", "-R0/10/0/10 -I1 5");
	gmtwrite("lixo.grd", G,  scale=10, offset=-10)
	GG = gmtread("lixo.grd", grd=true, varname=:z);
	GG = gmtread("lixo.grd", varname=:z);
	GG = gmtread("lixo.grd", grd=true, layout=:TR);
	GG = gmtread("lixo.grd", grd=true, layout=:TC);
	#GG = gmtread("lixo.grd", grd=true, layer=1);	# This crashes GMT or GDAL in Linux
	@test(sum(G.z[:] - GG.z[:]) == 0)

	GG = mat2grid(reshape(collect(1.0:25), 5, 5));
	gmtwrite("lixo.grd",GG)
	Gr = gmtread("lixo.grd", layout="BCB");
	@test Gr.z[1:5] == [1.0, 2.0, 3.0, 4.0, 5.0]
	Gr = gmtread("lixo.grd", layout="TCB");
	@test Gr.z[1:5] == [5.0, 4.0, 3.0, 2.0, 1.0]
	Gr = gmtread("lixo.grd", layout="TRB");
	@test Gr.z[1:5] == [5.0, 10.0, 15.0, 20.0, 25.0]
	Gr = gmtread("lixo.grd", layout="BRB");
	@test Gr.z[1:5] == [1.0, 6.0, 11.0, 16.0, 21.0]

	gmtwrite("lixo.grd", rand(5,5), id=:cf, layout=:TC)
	gmtwrite("lixo.tif", rand(UInt8,32,32,3), driver=:GTiff)
	I = gmtread("lixo.tif", img=true, layout="TCP");
	I = gmtread("lixo.tif", img=true, layout="ICP");
	I = gmtread("lixo.tif", img=true, band=0);
	I = gmtread("lixo.tif", img=true, band=[0 1 2]);
	show(I);
	imshow(I, show=false)			# Test this one here because we have a GMTimage at hand
	gmtwrite("lixo.tif", mat2img(rand(UInt8,32,32,3)), driver=:GTiff)
	@test GMT.parse_grd_format(Dict(:nan => 0)) == "+n0"
	@test_throws ErrorException("Input data of unknown data type Int64") GMT.gmtwrite(" ", 1)
	@test_throws ErrorException("Format code MUST have 2 characters and not bla") GMT.parse_grd_format(Dict(:id => "bla"))
	r = rand(UInt8(0):UInt8(10),10,10);	C=makecpt(range=(0,11,1));	I = mat2img(r, cmap=C);
	cpt = makecpt(T="-6/8/1");
	gmtwrite("lixo.cpt", cpt)
	cpt = gmtread("lixo.cpt", cpt=true);
	cpt = gmtread("lixo.cpt", cpt=true, Vd=dbg2);
	cpt = gmtread("lixo.cpt");
	gmtwrite("lixo.dat", mat2ds([1 2 10; 3 4 20]))
	gmtwrite("lixo.dat", convert.(UInt8, [1 2 3; 2 3 4]))
	gmtwrite("lixo.dat", [1 2 10; 3 4 20])
	D = gmtread("lixo.dat", i="0,1s10", table=true);
	@test(sum(D[1].data) == 64.0)
	gmtwrite("lixo.dat", D)
	gmt("gmtwrite lixo.cpt", cpt)		# Same but tests other code chunk in gmt_main.jl
	gmt("gmtwrite lixo.dat", D)
	gmt("write lixo.tif=gd:GTiff", mat2img(rand(UInt8,32,32,3)))
	gmt("grdinfo lixo.tif");
	@test_throws ErrorException("Output file name cannot be empty.") gmtwrite("",[1 2]);

	# This gdalwrite screws deeply. Nex GMT errors with non-sensic reason and not reproducible in REPL
	#gdalwrite("lixo1.gmt", fromWKT("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))"))
	gmtread("polyg_hole.gmt")

	println("	GMTVECTOR")
	d = [0 0; 0 90; 135 45; -30 -60];
	gmtvector(d, T=:D, S="0/0", f=:g);

	println("	GMTWICH")
	gmtwhich("lixo.dat", C=true)