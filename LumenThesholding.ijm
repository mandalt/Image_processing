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
		run("8-bit");
		run("Gaussian Blur...", "sigma=5");
//Set a threshold as a percentage of the mean intensity
		thresholdPercentage = 30; 
		thresholdValue = max * (thresholdPercentage / 100);
		setThreshold(thresholdValue, 255);
//Apply auto threshold
//		run("Threshold...");
//		setAutoThreshold("Default dark no-reset");
		run("Convert to Mask");
		run("Fill Holes");
		run("Find Edges");
//apply a size and shape(circularity) filter
		run("Set Measurements...", "area center limit display redirect=None decimal=3");
		Image.removeScale();
		run("Analyze Particles...", "size=100-20000 circularity=0.0-1.00 show=[Overlay Masks] show=[Overlay Masks] display clear add");
		run("Flatten");
		saveAs("Results", dir2 + currentImage_name + ".csv");
		n_lumens = roiManager("count");
		print(n_lumens, currentImage_name);
//	newImage("mask", "8-bit black", 1024, 1024, 1);
//	roiManager("select", newArray(n_lumens));
//	roiManager("add");
//	roiManager("Show All");
//	run("Flatten");                         
		saveAs("Tiff", dir2 + currentImage_name + "_lumen_mask");
		close("*");
    }
}
selectWindow("Log");
saveAs("Text", dir2 + "count_lumen");

