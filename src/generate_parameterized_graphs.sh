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

# Function to run the Java bipartite script with the given parameter values
run_bipartite_script() {
    local output_dir=$1
    local nodes_source=$2
    local nodes_sink=$3
    local maxProbability=$4
    local minCapacity=$5
    local maxCapacity=$6

    mkdir -p "$output_dir"
    local output_file="$output_dir/output_bipartite_${nodes_source}_${nodes_sink}_${maxProbability}"
    ./"bipartite.sh" "$nodes_source" "$nodes_sink" "$maxProbability" "$minCapacity" "$maxCapacity" "$output_file" > /dev/null
}

# Function to run the Java fixeddegree script with the given parameter values
run_fixeddegree_script() {
    local output_dir=$1
    local nodes_source=$2
    local edges=$3
    local minCapacity=$4
    local maxCapacity=$5

    mkdir -p "$output_dir"
    local output_file="$output_dir/output_fixeddegree_${nodes_source}_${edges}_${minCapacity}_${maxCapacity}.txt"
    ./"fixeddegree.sh" "$nodes_source" "$edges" "$minCapacity" "$maxCapacity" "$output_file" > /dev/null
}

# Function to run the Java mesh script with the given parameter values
run_mesh_script() {
    local output_dir=$1
    local rows=$2
    local columns=$3

    mkdir -p "$output_dir"
    local output_file="$output_dir/output_mesh_${rows}_${columns}.txt"
    ./"mesh.sh" "$rows" "$columns" > "$output_file"
}

# Function to run the Java random script with the given parameter values
run_random_script() {
    local output_dir=$1
    local nodes_source=$2
    local dense=$3
    local maxCapacity=$4
    local minCapacity=$5

    mkdir -p "$output_dir"
    local output_file="$output_dir/output_random_${nodes_source}_${dense}_${minCapacity}_${maxCapacity}.txt"
    ./"random.sh" "$output_file" " " "$nodes_source" "$dense" "$maxCapacity" "$minCapacity" > /dev/null
}

# Set default values if not provided by the user
big_Step=${6:-250}
medium_Step=${7:-50}
small_Step=${8:-10}
point_number=${9:-2}

# Initialize random values for each parameter
initial_edges=$(generate_random_number 500 1000)
initial_nodes_source=$((initial_edges + $(generate_random_number 500 1000)))
initial_nodes_sink=$(generate_random_number 500 1000)
initial_dense=$(generate_random_number 1 89)
initial_minCapacity=$(generate_random_number 100 150)
initial_maxCapacity=$(generate_random_number 160 500)
initial_rows=$(generate_random_number 50 150)
initial_columns=$(generate_random_number 100 150)
initial_maxProbability=$(generate_random_float 0 1)

# Loop to test all possible combinations of parameter values for the bipartite script
output_dir_bipartite="bipartite_examples"
for nodes_source in $(seq $initial_nodes_source $big_Step $((initial_nodes_source + $big_Step * $point_number))); do
    for nodes_sink in $(seq $initial_nodes_sink $big_Step $((initial_nodes_sink + $big_Step * $point_number))); do
        for maxProbability in $(seq $initial_maxProbability 0.2 1); do
            for minCapacity in $(seq $initial_maxCapacity $medium_Step $((initial_maxCapacity + $medium_Step * $point_number))); do
              for maxCapacity in $(seq $initial_maxCapacity $medium_Step $((initial_maxCapacity + $medium_Step * $point_number))); do
                run_bipartite_script "$output_dir_bipartite" "$nodes_source" "$nodes_sink" "$maxProbability" "$minCapacity" "$maxCapacity"
              done
            done
        done
    done
done

# Loop to test all possible combinations of parameter values for the fixeddegree script
output_dir_fixeddegree="fixeddegree_examples"
for nodes_source in $(seq $initial_nodes_source $big_Step $((initial_nodes_source + $big_Step * $point_number))); do
    for edges in $(seq $initial_edges $big_Step $((initial_edges + $big_Step * $point_number))); do
        for minCapacity in $(seq $initial_minCapacity $medium_Step $((initial_minCapacity + $medium_Step * $point_number))); do
            for maxCapacity in $(seq $initial_maxCapacity $medium_Step $((initial_maxCapacity + $medium_Step * $point_number))); do
                run_fixeddegree_script "$output_dir_fixeddegree" "$nodes_source" "$edges" "$minCapacity" "$maxCapacity"
            done
        done
    done
done

# Loop to test all possible combinations of parameter values for the mesh script
output_dir_mesh="mesh_examples"
for rows in $(seq $initial_rows $small_Step $((initial_rows + $small_Step * $point_number))); do
    for columns in $(seq $initial_columns $small_Step $((initial_columns + $small_Step * $point_number))); do
        run_mesh_script "$output_dir_mesh" "$rows" "$columns"
    done
done

# Loop to test all possible combinations of parameter values for the random script
output_dir_random="random_examples"
for nodes_source in $(seq $initial_nodes_source $big_Step $((initial_nodes_source + $big_Step * $point_number))); do
    for dense in $(seq $initial_dense $small_Step $((100))); do
        for minCapacity in $(seq $initial_minCapacity $medium_Step $((initial_minCapacity + $medium_Step * $point_number))); do
            for maxCapacity in $(seq $initial_maxCapacity $medium_Step $((initial_maxCapacity + $medium_Step * $point_number))); do
                run_random_script "$output_dir_random" "$nodes_source" "$dense" "$maxCapacity" "$minCapacity"
            done
        done
    done
done

echo "Done"
