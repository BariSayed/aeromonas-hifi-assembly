#!/usr/bin/env bash
# Proper PacBio HiFi assembly of a bacterial isolate (no polishing needed).
# Reads: ENA SRR30596866 (Aeromonas dhakensis, Sequel IIe HiFi, Q30 98%, ~78x)
set -euo pipefail
READS=00_raw_data/SRR30596866.fastq.gz
# 1. Flye (HiFi mode) -> single circular chromosome
flye --pacbio-hifi "$READS" --out-dir 02_assembly/flye_hifi --threads 14
# 2. hifiasm (independent HiFi assembler) -> primary contigs
hifiasm -o 02_assembly/hifiasm/asm -t 14 "$READS"
awk '/^S/{print ">"$2"\n"$3}' 02_assembly/hifiasm/asm.bp.p_ctg.gfa > 04_results/hifiasm.fasta
# 3. QC: QUAST + BUSCO (bacteria_odb10); no Medaka/consensus step is required for HiFi
# 4. Downstream: fastANI (species), mlst, abricate, amrfinder  (see scripts/)
