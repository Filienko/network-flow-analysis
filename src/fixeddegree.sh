#!/bin/bash

# Compile Java code
javac graphGenerationCode/FixedDegree/RandomGraph.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    # Run Java program with command line arguments
    
    java graphGenerationCode/FixedDegree/RandomGraph "$@"
    echo "Done FixedDegree"

else
    echo "Compilation failed. Exiting..."
fi
