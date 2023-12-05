#!/bin/bash

# Compile Java code
javac graphGenerationCode/Bipartite/BipartiteGraph.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    # Run Java program with command line arguments
    java graphGenerationCode/Bipartite/BipartiteGraph "$@"
    echo "Done Bipartite"
else
    echo "Compilation failed. Exiting..."
fi
