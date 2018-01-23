# Udacity Term 2 Robotic Inference Project

## Introduction: 

This project consists of two parts:

1. Classification training of the supplied P1 dataset of bottles and candy wrappers - the "P1" dataset.
2. Creation of a Robotic Inference Idea. In this case a traffic sign classification idea was chosen. These images are in the "TrafficeSigns" dataset.

### Part One

This dataset represents images of bottles and candy wrappers on a conveyor belt passing under a camera. The idea is to sort the items into two bins by activating a swing arm that guides the products to the right bin. The applications of such a recognition system are many, including including for example classification sorting, or identifying defective products.

### Part Two

This idea was motivated by an interest in autonomous vehicle control. Many lives can be saved on the highways and roadways if the vehicle can monitor unsafe situations and assist in controlling the vehicle. The idea is to recognize traffic signs such as stop, yeild and speed limit signs. Should the driver ignore or not see a stop or yield sign, the autonomous control can take over to ensure vehicle safety. In the case that spped limits are being violated, the vehicle can modify the vehicle speed or advise the driver to do so.

The deployment idea is to create a model classifying traffic signs, download it to a processor such as a Jetson TX2 or perhaps even an iPhone and have it monitor and advise live driving.

## Background / Formulation

Once your data is imported, it is up to you to choose a training model. You can use a pre-supplied one, one from the DIGITS model store, an external network or even customize the above choices.

Your model will have to achieve an inference time of 10 ms or less on the workspace and have an accuracy greater than 75 percent.

At this stage, you should begin diving into the technical details of your approach by explaining to the reader how parameters were defined, what type of network was chosen, and the reasons these items were performed. This should be factual and authoritative, meaning you should not use language such as “I think this will work” or “Maybe a network with this architecture is better..”. Instead, focus on items similar to, ”A 3-layer network architecture was chosen with X, Y, and Z parameters”

Explain why you chose the network you did for the supplied data set and then why you chose the network used for your robotic inference project.

## Data Acquisition

The LISA dataset contains over 7,000 traffic sign images. This dataset was chosen for the reality of the images (many signs are small, occluded, blurry, etc) and its sheer volume fo images. While the rubric for the project specifies at least 3 classes of images, 4 classes were chosen. The classes are **stop**, **yield**, **speedLimit25** and **speedLimit35**. The first two classes were chosen due to their imoprtance for vehicle safety. The second two were chosen to set a challenge level of difficuly in distinguishing 25 from 35. 

These are examples of raw images of the 4 classes of signs chosen:

<div align="center">
<table>
    <tr>
        <th colspan=2>Raw Traffic Sign Images</th>
    </tr>
    <tr>
        <th>Speed Limit 25</th><th>Speed Limit 35</th>
    </tr>
    <tr>
        <td>
            <a href="images/speedLimit25_1333394492.avi_image2.png" target=_blank><img height="240" src="images/speedLimit25_1333394492.avi_image2.png"/></a>
        </td>
        <td>
            <a href="images/speedLimit35_1333393073.avi_image7.png" target=_blank><img height="240" src="images/speedLimit35_1333393073.avi_image7.png"/></a>
        </td>
    </tr>
    <tr>
        <th>Yield</th><th>Stop</th>
    </tr>
    <tr>
        <td>
            <a href="images/syield_1333395823.avi_image7.png" target=_blank><img height="240" src="images/yield_1333395823.avi_image7.png"/></a>
        </td>
        <td>
            <a href="images/stop_1333388384.avi_image0.png" target=_blank><img height="240" src="images/stop_1333388384.avi_image0.png"/></a>
        </td>
    </tr>
</table>
</div>

The images are processed by a bash script (<a href="doit.sh">doit.sh</a>) that I wrote that calls Python tools included with the LISA distribution. The script creates a single CSV index file that references the images in all of the subdirectories of the LISA distribution and crops the actual sign into image sets for training and validation that is uploaded to the DIGITS directory. The CSV file contains useful fields that reference the source image, tag and coordinates of the sign:

```
Filename;Annotation tag;Upper left corner X;Upper left corner Y;Lower right corner X;Lower right corner Y;Occluded,On another road;Origin file;Origin frame number;Origin track;Origin track frame number
```

Only the file name, the annotation tag and the sign image coordinates are used in the test and validation datasets.

The processed images are cropped from the raw data to contain just the signs:

<p "text-align=center">
<table>
    <tr>
        <th colspan=2>Processed Traffic Sign Images</th>
    </tr>
    <tr>
        <th>Speed Limit 25</th><th>Speed Limit 35</th>
    </tr>
    <tr>
        <td>
            <a href="images/276_speedLimit_1324866665.avi_image0.png" target=_blank><img height="128" src="images/276_speedLimit_1324866665.avi_image0.png"/></a>
        </td>
        <td>
            <a href="images/416_speedLimit_1324866807.avi_image0.png" target=_blank><img height="128" src="images/416_speedLimit_1324866807.avi_image0.png"/></a>
        </td>
    </tr>
    <tr>
        <th>Yield</th><th>Stop</th>
    </tr>
    <tr>
        <td>
            <a href="images/176_yield_1323816786.avi_image19.png" target=_blank><img height="128" src="images/176_yield_1323816786.avi_image19.png"/></a>
        </td>
        <td>
            <a href="images/1410_stop_1324866481.avi_image15.png" target=_blank><img height="128" src="images/1410_stop_1324866481.avi_image15.png"/></a>
        </td>
    </tr>
</table>
</p>

The raw and processed images are mixture of grayscale and color images. The DIGITS DataSet creation process converts all the images to grayscale. The processed images are cropped to a size of 32x32 pixels.

The count of **training** images for each class are:

<p "text-align=center">
<table>
    <tr>
        <th colspan=2>Training Traffic Sign Image Counts</th>
    </tr>
    <tr>
        <th>Tag</th><th>Count</th>
    </tr>
    <tr>
        <td>stop</td><td>1413</td>
    </tr>
    <tr>
        <td>yield</td><td>85</td>
    </tr>
    <tr>
        <td>speedLimit25</td><td>245</td>
    </tr>
    <tr>
        <td>speedLimit35</td><td>404</td>
    </tr>
</table>
</p>

The count of **validation** images for each class are:

<p "text-align=center">
<table>
    <tr>
        <th colspan=2>Validation Traffic Sign Image Counts</th>
    </tr>
    <tr>
        <th>Tag</th><th>Count</th>
    </tr>
    <tr>
        <td>stop</td><td>381</td>
    </tr>
    <tr>
        <td>yield</td><td>18</td>
    </tr>
    <tr>
        <td>speedLimit25</td><td>63</td>
    </tr>
    <tr>
        <td>speedLimit35</td><td>114</td>
    </tr>
</table>

The split im number of training / validation images was set at 80% / 20% in the doit.sh bash script.

While the raw images in the LISA dataset were used to create the training and validation set, the test dataset was taken independently using an iPhone.

<div align="center">
<table>
    <tr>
        <th colspan=2>Test Traffic Sign Images</th>
    </tr>
    <tr>
        <th>Speed Limit 25</th><th>Speed Limit 35</th>
    </tr>
    <tr>
        <td>
            <a href="images/" target=_blank><img height="240" src="images/"/></a>
        </td>
        <td>
            <a href="images/" target=_blank><img height="240" src="images/"/></a>
        </td>
    </tr>
    <tr>
        <th>Yield</th><th>Stop</th>
    </tr>
    <tr>
        <td>
            <a href="images/" target=_blank><img height="240" src="images/"/></a>
        </td>
        <td>
            <a href="images/stop_test_001.png" target=_blank><img height="240" src="images/stop_test_001.png"/></a>
        </td>
    </tr>
</table>
</div>

## Results

This is typically the hardest part of the report for many. You want to convey your results in an unbiased fashion. If your results are good, you can objectively note this. Similarly, you may do this if they are bad as well. You do not want to justify your results here with discussion; this is a topic for the next session. Present the results of your robotics project model and the model you used for the supplied data with the appropriate accuracy and inference time.

For demonstrating your results, it is incredibly useful to have some charts, tables, and/or graphs for the reader to review. This makes ingesting the information quicker and easier.

## Discussion: 

This is the only section of the report where you may include your opinion. However, make sure your opinion is based on facts. If your results are poor, make mention of what may be the underlying issues. If the results are good, why do you think this is the case? Again, avoid writing in the first person (i.e. Do not use words like “I” or “me”). If you really find yourself struggling to avoid the word “I” or “me”; sometimes, this can be avoided with the use of the word “one”. As an example: instead of, "I think the accuracy on my dataset is low because the images are too small to show the necessary detail" try, "one may believe the accuracy on the dataset is low because the images are too small to show the necessary detail". They say the same thing, but the second avoids the first person.

Reflect on which is more important, inference time or accuracy, in regards to your robotic inference project.

Conclusion / Future Work: This section is intended to summarize your report. Your summary should include a recap of the results, did this project achieve what you attempted, and is this a commercially viable product? For future work, address areas of work that you may not have addressed in your report as possible next steps. This could be due to time constraints, lack of currently developed methods / technology, and areas of application outside of your current implementation. Again, avoid the use of the first-person.

Your report must be in PDF format. You may use any method to produce this format. If you are looking for a challenge, you can create your project report in LaTeX and then export the report to pdf. Here’s a sample LaTeX report. It’s a fun way to create well formatted documents!

## References

[1] Sayanan Sivaraman and Mohan M. Trivedi, "A General Active Learning Framework for On-road Vehicle Recognition and Tracking," IEEE Transactions on Intelligent Transportation Systems, 2010.

[2] Eshed Ohn-Bar and Mohan M. Trivedi, "Hand Gesture Recognition in Real-Time for Automotive Interfaces: A Multimodal Vision-based Approach and Evaluations," IEEE Transactions on Intelligent Transportation Systems, 2014. 

[3] Andreas Møgelmose, Mohan M. Trivedi, and Thomas B. Moeslund, "Vision based Traffic Sign Detection and Analysis for Intelligent Driver Assistance Systems: Perspectives and Survey," IEEE Transactions on Intelligent Transportation Systems, 2012.

[4] Morten Bornø Jensen, Mark Philip Philipsen, Andreas Møgelmose, Thomas B Moeslund, and Mohan M Trivedi. “Vision for Looking at Traffic Lights: Issues, Survey, and Perspectives”. In: IEEE Transactions on Intelligent Transportation Systems (2015).

[5] Mark Philip Philipsen, Morten Bornø Jensen, Andreas Møgelmose, Thomas B Moeslund, and Mohan M Trivedi. “Learning Based Traffic Light Detection: Evaluation on Challenging Dataset”. In: 18th IEEE Intelligent Transportation Systems Conference (2015).


