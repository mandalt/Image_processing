//geberate masks for brain organoids.
run("Bio-Formats Macro Extensions");
dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);
print("organoid per FOV");


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
		run("Gaussian Blur...", "sigma=12");
//Apply auto threshold
		run("Threshold...");
		setAutoThreshold("Default dark no-reset");
//Or set a threshold as a percentage of the max intensity
//		thresholdPercentage = 20; 
//		thresholdValue = max * (thresholdPercentage / 100);
//		setThreshold(thresholdValue, 255);
		run("Convert to Mask");
		run("Fill Holes");
		run("Set Measurements...", "area center redirect=None decimal=3");
//If the organoids are sticking to each other then run "Watershed" but not "Find Edges".
		run("Watershed");
//If there are >1 organoids in one FOV but they are well seperated then use "Find Edges" instead of Watershed
//		run("Find Edges");
		run("Analyze Particles...", "size=30000-infinity circularity=0.0-1.00 show=[Overlay Masks] show=[Overlay Masks] display clear add");
		n_organoids = roiManager("count");
		print(n_organoids);
		for (j = 0; j < n_organoids; j++){
			newImage("blank", "8-bit black", 1024, 1024, 1);
			roiManager("Select", j);
			roiManager("Add");
//			setForegroundColor(255, 255, 255);
			roiManager("Fill");
			run("Flatten");
			saveAs("Tiff", dir2 + i + "_nuclei_mask_" + "0" + j + "_" + currentImage_name);
		}
		saveAs("Results", dir2 + i + "_nuclei_mask_" + currentImage_name + ".csv");                    
		close("*");
    }
}
selectWindow("Log");
saveAs("Text", dir2 + "count_nuclei");