#!/bin/bash

# Compile Java code
javac graphGenerationCode/Mesh/MeshGenerator.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    # Run Java program with command line arguments
    java graphGenerationCode/Mesh/MeshGenerator "$@"
    echo "Done Mesh"
else
    echo "Compilation failed. Exiting..."
fi
