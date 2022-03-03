Code for Q1 is in compute_LK_optical_flow.m

You can set parameters in the file:

smooth factor for smoothing frames: sigma

smooth factor for smoothing RHS: sigma_1d

Window size: (2w+1)*(2w+1) ex: window size =9\*9 if w =4



To run this function, you can use test_flow.m to run it. Test_flow will also display and save the motion field overlaying every frame you loaded.

