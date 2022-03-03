function [l_point,r_point] = SurfFeaturepoints(I1,I2)

I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

%returns a SURFPoints object, points, containing information about SURF features detected in the 2-D grayscale input image I. 
ptsLeft  = detectSURFFeatures(I1); 
ptsRight = detectSURFFeatures(I2);

%ExtractFeatures: Returns [features, validPoints], extracted feature vectors, also known as
%descriptors, and their corresponding locations.
[featuresLeft,  validPtsLeft]  = extractFeatures(I1,  ptsLeft);
[featuresRight, validPtsRight] = extractFeatures(I2, ptsRight);

%indexPairs the matching feature vectors and return the matching points
%index in featuresLeft, and featuresRight
indexPairs = matchFeatures(featuresLeft, featuresRight);

%Get the valid points using the index.
matchedLeft  = validPtsLeft(indexPairs(:,1));
matchedRight = validPtsRight(indexPairs(:,2));
l_point=round(matchedLeft.Location);
r_point=round(matchedRight.Location);
%The matchedpoints here are the SURFPoints but we can get the x,y coordinates
%by the Location attribute. 
end