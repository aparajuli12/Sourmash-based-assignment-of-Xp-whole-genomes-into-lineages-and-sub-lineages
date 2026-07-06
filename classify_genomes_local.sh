#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "===================================================="
echo " Sourmash Xp Lineage Classification Pipeline"
echo "===================================================="

# Check if sourmash is available
if ! command -v sourmash &> /dev/null; then
    echo "❌ Error: sourmash is not installed or not in your current PATH."
    echo "💡 Please install it via Conda: 'conda install -c bioconda sourmash'"
    exit 1
fi

# Set path to local reference database file
ref_db="ref_db.sbr.zip"
input_dir="downloaded_fna"

# Check if required components are present
if [ ! -f "$ref_db" ]; then
    echo "❌ Error: Reference database '$ref_db' not found in this folder."
    exit 1
fi

if [ ! -d "$input_dir" ] || [ -z "$(ls -A $input_dir/*.fna 2>/dev/null)" ]; then
    echo "❌ Error: '$input_dir/' folder is missing or contains no .fna files."
    exit 1
fi

# Stage files locally
echo " Copying target files..."
cp "$input_dir"/*.fna ./

# Generate strain tracking list
shopt -s nullglob
ls *.fna | sed 's/\.fna$//' > strains.txt

# Loop over each strain to sketch and search
while read -r x; do
    if [ -z "$x" ]; then continue; fi
    echo " Processing unknown genome: $x"

    # Create sourmash signature
    sourmash sketch dna -p k=31,scaled=1000 -o "${x}.sig" "${x}.fna"

    # Search against the reference SBT
    sourmash search "${x}.sig" "$ref_db" > "${x}.txt"
done < strains.txt

# Compile master summary output
echo "Consolidating results into combined_results.txt..."
> combined_results.txt
for f in *.txt; do
    if [ "$f" != "strains.txt" ]; then
        echo "===== $f =====" >> combined_results.txt
        cat "$f" >> combined_results.txt
        echo "" >> combined_results.txt
    fi
done

echo "✅ Classification complete. Results saved to 'combined_results.txt'."
