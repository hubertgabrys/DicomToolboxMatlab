# DicomToolboxMatlab
DicomToolboxMatalb allows to import, visualize, and extract image features from CT and RT Dose DICOM files in MATLAB.

# Instructions
## Start the GUI
Move to DicomToolboxMatlab directory and start the GUI by executing 'start.m'.

## Import DICOMs
To import DICOMs of a single patient, click on 'Import DICOM' button and specify the import parameters. After successful DICOM import, 'tps_data.mat' file is created in the directory containing the patient's files.

In order to import DICOM files of more than one patient at a time, one can do batch DICOM import by selecing 'Batch' checkbox and then clicking on 'Import DICOM' button. The patient files need to be organized in such a way that each patient files are stored in a separate subdirectory of the input directory. For example: 'input_directory/patient1', 'input_directory/patient2' and so on.

## DICOM feature extraction
To extract features of a single patient, one needs to load the patient's 'tps_data.mat' file by clicking on 'Load '\*.mat'' button and then click 'Calculate features' button. 

Features can be also extracted for multiple patients in one go. To do this, one needs to select 'Batch' checkbox and then click on 'Calculate features' button. Requirements for patient directory structure are the same as for batch DICOM import. There is no need to manualy load 'tps_data.mat' files but they need to be present in patient directories. 'tps_data.mat' files can be easily calculated for all patients by doing batch DICOM import explained in the previous paragraph.

By default, features of all rt structures are extracted. If one would like to extract features of parotid glands only, it can be achieved by changing 'all' to 'parotids' in the selection menu below the patient name. This applies to both single-patient and batch feature extraction.

# DicomToolboxMatlab features
## DICOM Import
* CT
* RT Dose
* RT Structures
* Grid interpolation

## Visualization
* CT
* Dose
* Dose-volume histogram

## DICOM feature extraction
* Organ shape
  * volume
  * area
  * sphericity
  * eccentricity
  * compactness
  * density
  * eigenvalues
* Dose-volume histogram
  * mean
  * spread
  * skewness
  * kurtosis
  * Dx
  * Vx
  * entropy
  * uniformity
* Subvolume dose
* Dose shape
  * Dose gradients
  * Dose moments
