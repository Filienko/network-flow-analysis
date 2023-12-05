#!/bin/bash

# Compile Java code
javac graphGenerationCode/Random/BuildGraph.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    # Run Java program with command line arguments
    java graphGenerationCode/Random/BuildGraph "$@"
    echo "Done Random"
else
    echo "Compilation failed. Exiting..."
fi
