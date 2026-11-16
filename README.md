# aeromonas-hifi-assembly

PacBio **HiFi** whole-genome assembly of an *Aeromonas* isolate from publicly
available sequencing data, assembled with Flye (`--pacbio-hifi`) and hifiasm.

## Overview

This repository documents a long-read HiFi assembly of secondary (publicly archived)
data. No new sequencing was generated. HiFi (PacBio circular consensus) reads are
highly accurate (Q30 ~98%), so the assembly requires **no separate polishing step**.
The pipeline, run script and summary outputs are provided for reproducibility.

## Input data

| | |
|---|---|
| Organism | *Aeromonas dhakensis* (member of the *A. hydrophila* species complex) |
| Platform | PacBio Sequel IIe, HiFi (circular consensus) |
| ENA run | [`SRR30596866`](https://www.ebi.ac.uk/ena/browser/view/SRR30596866) |
| Reads | 45,532 |
| Read N50 | 8,694 bp |
| Read accuracy | Q20 99.2%, Q30 98.1% |
| Coverage | ~78x |

## Workflow

HiFi reads were assembled with two independent assemblers; no polishing was applied.

1. **Flye** `--pacbio-hifi` → de novo assembly
2. **hifiasm** → independent de novo assembly (primary contigs)
3. Assembly QC — QUAST and BUSCO (`bacteria_odb10`)
4. Characterization — fastANI (species), mlst, ABRicate and AMRFinderPlus (AMR/virulence),
   PlasmidFinder (plasmid replicons)

See `scripts/run_hifi_assembly.sh` for commands.

## Results

| Metric | Flye `--pacbio-hifi` | hifiasm |
|---|---|---|
| Contigs | **1** | **1** |
| Chromosome length | 4,892,629 bp (circular) | 4,893,362 bp |
| N50 | 4,892,629 bp | 4,893,362 bp |
| GC content | 61.6% | 61.6% |
| Polishing | none | none |
| BUSCO completeness | **C:100.0%** [S:98.4%, D:1.6%], M:0.0% | — |

Both assemblers independently produced a single circular chromosome of essentially
the same length (within ~700 bp), with no fragmentation.

### Characterization (Flye `--pacbio-hifi` assembly)

| Analysis | Tool | Result |
|---|---|---|
| Species (ANI) | fastANI | 97.3% vs *A. dhakensis* (species confirmed); 93.9% vs *A. hydrophila* (below the 95% threshold) |
| Sequence type | mlst (*aeromonas* scheme) | ST335 |
| AMR genes | AMRFinderPlus / ABRicate | intrinsic *Aeromonas* β-lactamases only (cphA, blaOXA, blaAQU); no acquired resistance genes |
| Virulence | ABRicate / VFDB | 175 hits, including aerolysin (*aerA/act*) and a Type III secretion system (*asc/aop*) |
| Plasmid | PlasmidFinder | no replicon detected (single circular chromosome) |

Full tables are in `results/` (`qc/`, `downstream/`).

## Repository contents

```
scripts/            HiFi assembly run script
results/assembly/   Flye and hifiasm assemblies (gz), Flye assembly_info (circularity)
results/qc/         QUAST report, BUSCO summary, read statistics
results/downstream/ fastANI, MLST, AMR/virulence, plasmid screening
```
Raw reads and intermediate assembly working files are not tracked (see `.gitignore`).

## Tools and versions

Flye 2.9.5 (`--pacbio-hifi`) · hifiasm (StaPH-B) · QUAST 5.3.0 · BUSCO 5.8.3 (bacteria_odb10) ·
fastANI · mlst · ABRicate · AMRFinderPlus · seqkit 2.1.0 — run with Apptainer containers.

## Data availability and reproducibility

Input reads are public ENA records (`SRR30596866`). Reference genome for ANI:
*A. dhakensis* GCF_002285935.1, *A. hydrophila* GCF_000014805.1 (ATCC 7966<sup>T</sup>).

## License

Released under the MIT License. Input sequence data are public ENA/NCBI records.
