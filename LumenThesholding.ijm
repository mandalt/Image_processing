//generate masks for lumens in brain organoids.
run("Bio-Formats Macro Extensions");
dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);



for (i = 0; i < list.length; i++) {
	if (list.length == 0) {
    print("No files found.");
	} else {
        open(dir1 + list[i]);
		currentImage_name = getTitle();
		selectImage(currentImage_name);
		getStatistics(area, mean, min, max, std, histogram);
//	z = getHistogram(values, counts, nBins[, histMin, histMax]);
//Apply Gaussian blur filter
		run("Gaussian Blur...", "sigma=5");
//Apply a constant threshold 
//	thresholdValue = 20;
//Set a threshold as a percentage of the mean intensity
		thresholdPercentage = 50; 
		thresholdValue = max * (thresholdPercentage / 100);
		setThreshold(thresholdValue, 255);
		run("Convert to Mask");
		run("Fill Holes");
		run("Find Edges");
//apply a size and shape(circularity) filter
		run("Set Measurements...", "area center redirect=None decimal=3");
		run("Analyze Particles...", "size=20-10000 circularity=0.0-1.00 show=[Overlay Masks] show=[Overlay Masks] display clear add");
		run("Flatten");
		saveAs("Results", dir2 + i + "_lumen_mask_" + currentImage_name + ".csv");
		n_lumens = roiManager("count");
		print(n_lumens);
//	newImage("mask", "8-bit black", 1024, 1024, 1);
//	roiManager("select", newArray(n_lumens));
//	roiManager("add");
//	roiManager("Show All");
//	run("Flatten");                         
		saveAs("Tiff", dir2 + i + "_lumen_mask_" + currentImage_name);
		close("*");
    }
}
selectWindow("Log");
saveAs("Text", dir2 + "count_lumen");
