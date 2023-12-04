//geberate masks for brain organoids.
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
		run("Gaussian Blur...", "sigma=8");
//Apply threshold
//	thresholdValue = 20;
//Set a threshold as a percentage of the mean intensit
		thresholdPercentage = 30; 
		thresholdValue = max * (thresholdPercentage / 100);
		setThreshold(thresholdValue, 255);
		run("Convert to Mask");
		run("Fill Holes");
		run("Set Measurements...", "area center redirect=None decimal=3");
		run("Watershed");
		run("Analyze Particles...", "size=10000-800000 circularity=0.2-1.00 show=[Overlay Masks] show=[Overlay Masks] display clear add");
		run("Flatten");
		n_organoids = roiManager("count");
		print(n_organoids);
		saveAs("Results", dir2 + i + "_nuclei_mask_" + currentImage_name + ".csv");
//		saveAs("Results", dir2 + "nuclei_mask" + currentImage_name + ".csv");                     
		saveAs("Tiff", dir2 + i + "_nuclei_mask_" + currentImage_name);
		close("*");
    }
}
selectWindow("Log");
saveAs("Text", dir2 + "count_nuclei");