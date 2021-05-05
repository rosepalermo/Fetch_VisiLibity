# Fetch_VisiLibity
This code uses the VisiLibity1 algorithm to calculate the fetch (distance over which can blow and generate waves) and associated wave energy proportionality for each point along a shoreline. The wind field is assumed to be isotropic. 

% Rose Palermo
% Updated May 5 2021
% This code uses the VisiLibity algorithm to calculate the fetch (distance over which can blow and generate waves) and associated wave energy proportionality for each point along a shoreline. The wind field is assumed to be isotropic. 

% To run VisiLibity library, you need to compile it in the terminal. Navigate to your VisiLibity folder, then enter commands below. 
make clean
make

% VisiLibity library: https://karlobermeyer.github.io/VisiLibity1/
% Visilibity citation: 
@Misc{VisiLibity1:2008,
  author = {K. J. Obermeyer and Contributors},
  title = {{VisiLibity}: A C++ Library for Visibility Computations in Planar
    Polygonal Environments},
  howpublished = {\texttt{http://www.VisiLibity.org}},
  year = 2008,
  note = {R-1},
}



 % Next, you’ll need to mex the cpp files in matlab.
% mex in matlab
mex -setup
mex -v in_environment.cpp visilibity.o
mex -v visibility_polygon.cpp visilibity.o

% You are now ready to run Fetch_VisiLibity! See the example file for more info.

