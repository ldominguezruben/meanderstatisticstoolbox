# MStaT

Meander Statistics Toolbox is a Matlab-based program for the quantification of parameters dexscriptors of meandering channels (sinuosity, arc-wavelength, amplitude, curvature, inflection point, among other). To obtain all the meander parameters MStaT uses the  function of wavelet transform to decompose the signail (centerline). The toolbox obtains the Wavelet Spectrum, Curvature and  Angle Variation and the Global Wavelet Spectrum. The input data to use MStaT is the Centerline (in a Coordinate System) and the average Width of the study Channels. MStaT can analize a large number of bends in a short time. Also MStaT allows calculate the migration of a period, and analizes the migration signature. Finally MStaT has a Confluencer and Difuencer toolbox that allow calculate the influence due the presence of the tributary o distributary channel on the main channel. For more information you can reviewed the Gutierrez and Abad 2014a and Gutierrez and Abad 2014b.

This is the GitHub repository of the source code for MStaT.

To run MStaT using the source code:

    Ensure you have Matlab 2015b or newer.

    Clone this repository using Git:

     # if you have a key associated with your github account
     git clone https://github.com/ldominguezruben/MStaT.git

     # otherwise
     git clone https://github.com/ldominguezruben/MStaT

    Run MStaT.m in Matlab.

