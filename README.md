# MStaT

Meander Statistics Toolbox is a Matlab-based software for the quantification of parameters descriptors of meandering channels (sinuosity, arc-wavelength, amplitude, curvature, inflection point, among other). To obtain all the meander parameters MStaT uses the  function of wavelet transform to decompose the signail (centerline). The toolbox obtains the Wavelet Spectrum, Curvature and  Angle Variation and the Global Wavelet Spectrum. The input data to use MStaT is the Centerline (in a Coordinate System) and the average Width of the study Channels. MStaT can analize a large number of bends in a short time. Also MStaT allows calculate the migration of a period, throgout of Migration Module and analizes the migration signal. Finally MStaT has a Confluence Module that allow calculate the influence due the presence of the tributary channel on the main channel. For more information you can see https://meanderstatistics.blogspot.com/.

This is the GitHub repository of the source code for MStaT.

To run MStaT using the source code:

Ensure you have Matlab 2015b or newer.

Clone this repository using Git:

 # if you have a key associated with your github account
 git clone https://github.com/ldominguezruben/mstat.git

 # otherwise
 git clone https://github.com/ldominguezruben/mstat

Run mstat.m in Matlab.
