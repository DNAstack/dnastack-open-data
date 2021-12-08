# SARS-CoV-2 sequencing data processed by DNAstack

Publicly available sequencing run data retrieved from the [NCBI's Sequence Read Archive (SRA)](https://www.ncbi.nlm.nih.gov/sra) was processed by DNAstack to provide assembled genomes, variant calls, and metadata on circulating strains of SARS-CoV-2.

For details about the data processing methods and pipelines used, see [this blog post](https://dnastack.com/harmonized-variant-calling-for-sars-cov-2-genomes/) and the workflow definition available from [Github](https://github.com/DNAstack/covid-processing-pipeline) or [Dockstore](https://dockstore.org/workflows/github.com/DNAstack/covid-processing-pipeline/covid-19-varcal:master?tab=info).


## Data structure and content

Data from different sequencing technologies was processed using different pipelines, resulting in different sets of output files. The major sequencing technologies that were processed as part of this initiative were Illumina paired-end sequencing samples and Oxford Nanopore single-ended sequencing samples.


### Illumina paired-end samples

#### Data content

| Data type          | File format                                      | File extension       | Description                                                                                                                                                                                                           |
|--------------------|--------------------------------------------------|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Raw reads          | Compressed FASTQ                                 | .fastq.gz            | Sequencing files converted from SRA objects using the [sra-toolkit](https://github.com/ncbi/sra-tools). Paired reads are extracted from SRA objects and stored as {sample}_1.fastq.gz and {sample}_2.fastq.gz.        |
| Read alignments    | Binary alignment map                             | .bam                 | Aligned, sorted, primer-trimmed reads. Reads are aligned to the SARS-CoV-2 reference genome, [NC_045512](https://www.ncbi.nlm.nih.gov/nuccore/NC_045512).                                                             |
| Assembled genome   | FASTA                                            | .fa                  | Reads assembled into contiguous genomic regions. For each sample, two assemblies are produced: {sample}.freebayes.fa and {sample}.ivar.fa.                                                                            |
| Variants and index | VCF, TBI                                         | .vcf.gz, .vcf.gz.tbi | Genomic sites and regions that differ between a particular sample and the reference genome. For each sample, two sets of variants files and indices are produced: {sample}.freebayes.vcf.gz and {sample}.ivar.vcf.gz. |
| Summary statistics | Zip archive containing HTML documents and images | .zip                 | Information about the raw and transformed files, variants, and lineage information gathered throughout the processing pipeline.                                                                                       |



#### Data structure

```
s3://dnastack-covid-19-data/
└── NCBI_SRA
    └── {sample}
        ├── {sample}_1.fastq.gz
        ├── {sample}_2.fastq.gz
        ├── {sample}.freebayes.fa
        ├── {sample}.freebayes.vcf.gz
        ├── {sample}.freebayes.vcf.gz.tbi
        ├── {sample}.ivar.fa
        ├── {sample}.ivar.vcf.gz
        ├── {sample}.ivar.vcf.gz.tbi
        ├── {sample}_summary.zip
        └── {sample}_viral_reference.mapping.primertrimmed.sorted.bam
```


### Oxford Nanopore single-ended samples

#### Data content

| Data type          | File format                                              | File extension       | Description                                                                                                                                                 |
|--------------------|----------------------------------------------------------|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Raw reads          | Compressed FASTQ                                         | .fastq.gz            | Sequencing files converted from SRA objects using the [sra-toolkit](https://github.com/ncbi/sra-tools). Single-ended reads are stored as {sample}.fastq.gz. |
| Read alignments    | Binary alignment map                                     | .bam                 | Aligned, sorted, primer-trimmed reads. Reads are aligned to the SARS-CoV-2 reference genome, [NC_045512](https://www.ncbi.nlm.nih.gov/nuccore/NC_045512).   |
| Assembly           | FASTA                                                    | .fasta               | Reads assembled into contiguous genomic regions.                                                                                                            |
| Variants and index | VCF, TBI                                                 | .vcf.gz, .vcf.gz.tbi | Genomic sites and regions that differ between a particular sample and the reference genome.                                                                 |
| Summary statistics | Zip archive containing plots and quality control reports | .zip                 | Information about the raw and transformed files, variants, and lineage information gathered throughout the processing pipeline.                             |


#### Data structure

```
s3://dnastack-covid-19-data/
└── NCBI_SRA
    └── {sample}
        ├── {sample}.consensus.fasta
        ├── {sample}.fastq.gz
        ├── {sample}.primertrimmed.rg.sorted.bam
        ├── {sample}.vcf.gz
        ├── {sample}.vcf.gz.tbi
        └── {sample}_summary.zip
```


## Data access

The data is available in the AWS S3 bucket `s3://dnastack-covid-19-data`.

Data can be listed and downloaded using the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

List data:
```bash
aws s3 ls s3://dnastack-covid-19-data/ --no-sign-request
```

Download a file:
```bash
aws s3 cp s3://dnastack-covid-19-data/NCBI_SRA/ERR4082025/ERR4082025.consensus.fasta . --no-sign-request
```


## Tutorials

See the [README](./tutorials/README.md) to learn how to run the tutorials either locally or in AWS via the [Amazon Genomics CLI](https://aws.amazon.com/genomics-cli/).

- [Assigning viral lineage](./tutorials/assign_lineage)
