#!/bin/bash
########################################################################
#
# Process traffic sign data for from LISA database for DIGITS
# Term 2 Udacity Robotics Inference Project
#
# Douglas Teeple Jan 22 2018
#
########################################################################

# the location of the LISA sign data
dirs="./aiua120214-0/frameAnnotations-DataLog02142012_external_camera.avi_annotations ./aiua120214-1/frameAnnotations-DataLog02142012_001_external_camera.avi_annotations ./aiua120214-1/frameAnnotations-DataLog02142012_001_external_camera.avi_annotations ./aiua120306-0/frameAnnotations-DataLog02142012_002_external_camera.avi_annotations ./aiua120306-1/frameAnnotations-DataLog02142012_003_external_camera.avi_annotations"

if [[ "$1" == "" || "$1" == "-h" ]]
then
    echo "usage: $(basename $0): -pass2 <item to extract i.e. stop, yield, speedLimit25 etc>"
    echo "Options:"
    echo "signalAhead, slow, stopAhead, thruMergeLeft, thruMergeRight, turnLeft, turnRight, yieldAhead"
    echo "prohibition: doNotPass, keepRight, rightLaneMustTurn, speedLimit15, speedLimit25, speedLimit30, speedLimit35, speedLimit40, speedLimit45, speedLimit50, speedLimit55, speedLimit65, truckSpeedLimit55"
    echo "speedLimit: speedLimit15, speedLimit25, speedLimit30, speedLimit35, speedLimit40, speedLimit45, speedLimit50, speedLimit55, speedLimit65, speedLimitUrdbl"
    echo "speedLimitGood: speedLimit15, speedLimit25, speedLimit30, speedLimit35, speedLimit40, speedLimit45, speedLimit50, speedLimit55, speedLimit65"
    exit
fi
action=crop
rm -f validate.txt train.txt labels.txt
root=/Volumes/Backups/signDatabasePublicFramesOnly/
# pass 1 is used to generate complete database
# pass 2 operates on the existing split data, that may have been cleaned up by hand
passno=1
if [[ "$1" == "-pass2" ]]
then
    passno=2
    shift
fi
for arg in $*
do
    what=${arg}
    train=${root}/data/train/${what}/
    validate=${root}/data/validate/${what}/
    if [ ! -d ${train} ]
    then
        mkdir -p ${train}
    fi
    if [ ! -d ${validate} ]
    then
        mkdir -p ${validate}
    fi
    if (( passno == 1 ))
    then
        rm -f ${train}/*
        rm -f ${validate}/*
        # merge all the sub directories into one csv index file
        echo "merging into mergedAnnotations.csv"
        rm -f mergedAnnotations.csv
        python tools/mergeAnnotationFiles.py frame mergedAnnotations.csv
        # split the data 80/20%
        echo "Splitting ${what}"
        rm -f split1.csv split2.csv
        python tools/splitAnnotationFiles.py 80 mergedAnnotations.csv
        echo "${action}ping ${what} ${train}"
        # extract annotations in the 80% training split
        rm -rf annotations
        python tools/extractAnnotations.py ${action} split1.csv -f ${what}
        mv annotations/* ${train}
        echo "Extracted `ls ${train}/* | wc -l` images in ${train}"
        # extract annotations in the 20% validation split
        rm -rf annotations
        echo "${action}ping ${what} ${validate}"
        python tools/extractAnnotations.py ${action} split2.csv -f ${what}
        mv annotations/* ${validate}
        echo "Extracted `ls ${validate}/* | wc -l` images in ${validate}"
    else
        echo "Using `ls ${train}/* | wc -l` images in ${train}"
        echo "Using `ls ${validate}/* | wc -l` images in ${validate}"
    fi
    # create the train.txt source file
    tindex=0
    if [ -e train.txt ]
    then
        tindex=`wc -l train.txt | awk '{print $1}'`
    fi
    echo "${train} ${tindex}" >>train.txt
    echo "${train} ${tindex}"
    # create the validate.txt source file
    vindex=0
    if [ -e validate.txt ]
    then
        vindex=`wc -l validate.txt | awk '{print $1}'`
    fi
    echo "${validate} ${vindex}" >>validate.txt
    echo "${validate} ${vindex}"
    # create the labels index file
    echo "${what}" >>labels.txt
done
