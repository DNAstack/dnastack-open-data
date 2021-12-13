# Assigning viral lineage

Assembled SARS-CoV-2 viral genomes may be classified as belonging to a particular phylogenetic lineage using [Pangolin](https://github.com/cov-lineages/pangolin). Lineage designations evolve and change as the virus does, meaning that a sequence may be assigned to different lineages at different points in time depending on the models in use at the time. For this reason, lineage assignment should be rerun regularly as Pangolin's underlying models are updated to ensure that those lineage assignments are up-to-date with the latest available information.


## Input files

The input to the workflow is an array of paths to assembled SARS-CoV-2 genomes.

For details on preparing the `inputs.json` file, see the corresponding section in the [README](../README.md#preparing-the-inputsjson-file).

- If the workflow is being run locally, you should first [download the assembly files](../../README.md#data-access), and use absolute paths to the files in the `inputs.json` file (or paths relative to the directory from which you are executing the workflow).
- If the workflow is being run on AWS (e.g. via the [Amazon Genomics CLI](https://aws.amazon.com/genomics-cli/)), `s3://` URLs to the files in the `s3://dnastack-covid-19-sra-data` can be used instead, and local download is not required. **Note that if the workflow is run on AWS, cloud compute and storage costs will be incurred**


## Example `inputs.json` files

Each of the `example_inputs.*.json` files in this directory will run the workflow using 10 samples as input.

- The `example_inputs.local.json` file should be used when running the workflow locally
- The `example_inputs.aws.json` file should be used when running the workflow in AWS

To run locally, first download the files from s3:

```
mkdir data
for sample in ERR4082025 ERR4082026 ERR4082027 ERR4082028 ERR4082029 ERR4082030 ERR4082031 ERR4082032 ERR4082033 ERR4082034; do
    aws s3 cp s3://dnastack-covid-19-sra-data/NCBI_SRA/${sample}/${sample}.consensus.fasta ./data/ --no-sign-request
done
```

Running on AWS will not require any additional steps; data will be pulled directly from s3 as part of workflow execution.


## Output files

The workflow outputs a CSV file containing a lineage assignment for each of the assembled genomes input to the workflow.


## Running the workflow

See the [README](../README.md) for details on running the tutorial workflows, either locally or in the AWS cloud.
