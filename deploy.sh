#!/bin/bash
#
# script to test Traffic Signs model
#
name=$(basename $1)
imagenet-console  ~/projects/TrafficSigns/test/${name} out_${name} \
--prototxt=$NET/deploy.prototxt \
--model=$NET/snapshot_iter_170.caffemodel \
--labels=$NET/labels.txt \
--input_blob=data \
--output_blob=softmax
#imagenet-camera --prototxt=$NET/deploy.prototxt --model=$NET/snapshot_iter_170.caffemodel --labels=$NET/labels.txt --input_blob=data --output_blob=softmax

