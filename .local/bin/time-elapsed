#!/bin/bash

time_elapsed() {
    START=$(date +%s)

    # Your stuff here
    sleep 4  # Placeholder for your actual time-consuming tasks

    END=$(date +%s)
    echo $((END - START)) | awk '{print int($1/60)":"int($1%60)}'
}

time_elapsed
