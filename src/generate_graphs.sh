#!/bin/bash

# Function to generate a random integer within a specified range
generate_random_number() {
    local min=$1
    local max=$2
    echo $((RANDOM % (max - min + 1) + min))
}

# Function to generate a random float within a specified range
generate_random_float() {
    awk -v min=$1 -v max=$2 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# Function to generate a constant increment for all values
generate_constant_increment() {
    generate_random_number 1 5  # Adjust the range as needed
}

# Check if the correct number of command line arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <num_runs>"
    exit 1
fi

# Get the number of runs from the command line argument
num_runs=$1
bipartite="bipartite.sh"
fixeddegree="fixeddegree.sh"
mesh="mesh.sh"
random="random.sh"

# Generate random integer values
nodes_source=$(generate_random_number 1000 4000)
nodes_sink=$(generate_random_number 500 2000)
edges=$(generate_random_number 1000 2000)
random_nodes_number=$(generate_random_number 100 500)
nodes=$((edges + nodes_source))
dense=$(generate_random_number 1 99)

# Generate random float values for other parameters
maxProbability=$(generate_random_float 0 1)
minCapacity=$(generate_random_number 1 10)
maxCapacity=$(generate_random_number 10 50)
rows=$(generate_random_number 100 200)
columns=$(generate_random_number 100 200)

# Generate random integer increments
increment_nodes_source=$(generate_constant_increment)
increment_nodes_sink=$(generate_constant_increment)
increment_edges=$(generate_constant_increment)
increment_nodes=$(generate_constant_increment)
increment_dense=$(generate_constant_increment)
increment_minCapacity=$(generate_constant_increment)
increment_maxCapacity=$(generate_constant_increment)
increment_rows=$(generate_constant_increment)
increment_columns=$(generate_constant_increment)

# Loop to run the Java program multiple times
for ((i=1; i<=$num_runs; i++)); do
    # Run the Java scripts with random values and fixed maxProbability
    ./"$bipartite" "$nodes_source" "$nodes_sink" "$maxProbability" "$minCapacity" "$maxCapacity" "output_${i}_bipartite"
    ./"$fixeddegree" "$nodes" "$edges" "$minCapacity" "$maxCapacity" "output_${i}_fixeddegree.txt"
    ./"$mesh" "$rows" "$columns" > "output_${i}_mesh.txt"

    # Increase values with the fixed increments
    nodes_source=$((nodes_source + increment_nodes_source))
    nodes_sink=$((nodes_sink + increment_nodes_sink))
    edges=$((edges + increment_edges))
    nodes=$((nodes + increment_nodes))
    dense=$((dense + increment_dense))
    minCapacity=$((minCapacity + increment_minCapacity))
    maxCapacity=$((maxCapacity + increment_maxCapacity))
    rows=$((rows + increment_rows))
    columns=$((columns + increment_columns))

    ./"$random" "output_${i}_random" " " "$nodes_source" "$dense" "$maxCapacity" "$minCapacity"

    # Add any additional sleep or delay if needed between runs
    sleep 1
done
