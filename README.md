# Sourmash-based Assignment of Xp Whole Genomes into Lineages and Sub-lineages

This repository provides a rapid, k-mer-based classification pipeline to assign newly sequenced *Xanthomonas euvesicatoria* pv. *perforans* (Xp) whole-genome sequences into established lineages and sub-lineages. 

Using **Sourmash**, this workflow bypasses intensive alignment steps by utilizing MinHash sketches to query genomic signatures against a pre-indexed Sequence Bloom Tree (SBT) reference database.

---

##  Repository Contents

* `ref_db.sbr.zip` - The compiled Sourmash SBT reference database containing signatures of classified Xp reference strains.
* `classify_genomes_local.sh` - Universal Bash script for local machines (Mac/Linux).
* `classify_genomes_hipergator.sh` - Slurm-optimized batch script for running on HiPerGator.

---

## Reference Database Specifications

The reference database (`ref_db.sbr.zip`) was generated from curated Xp reference genomes organized into **20 distinct classification groups** (18 sub-lineages within Group A, 2 within Group B, and an Unclassified group):

* **Lineages:** `LineageA1` through `LineageA16`, `LineageB1`, `LineageB2`, and `Unclassified`.
* **Parameters:** Sketched at $k=31$ with a scaling factor of 1000 (`scaled=1000`).
* **Metadata:** Reference strains carry embedded metadata tags using the format `${strain_name}|${lineage_assignment}` (e.g., `StrainName|LineageA11`). This ensures that downstream search hits immediately reveal the precise lineage or sub-lineage assignment without manual lookup tables.

---

##  Classifying Newly Sequenced Genomes

### Prerequisites
* **Sourmash** installed on your system.
* A folder named `downloaded_fna/` in your project directory containing your target assemblies in `.fna` format.

---

###  Option 1: Running Locally (Mac / Linux)

If you are executing this on a local machine, utilize the universal script which includes automatic dependency checks:

1. **Set up your environment (via Conda):**
   ```bash
   conda create -n sourmash_env -c bioconda -c conda-forge sourmash
   conda activate sourmash_env
