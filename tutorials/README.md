# Running tutorial workflows

Tutorial workflows are written in [Workflow Description Language (WDL)](https://openwdl.org/#:~:text=The%20Workflow%20Description%20Language%20(WDL,workflows%2C%20and%20parallelize%20their%20execution.), a pipelining language that can be run on a number of infrastructures and backends including locally and in Cloud compute environments.

Tools required for data analysis are packaged into [Docker containers](https://www.docker.com/), which ensures that the workflows will run consistently and reproducibly.


## Preparing the `inputs.json` file

The `inputs.json` file defines the set of inputs required by the workflow. It is JSON-formatted, and specifies the expected type of each input.
For each workflow run, this file should be modified (or copied) and each field filled out according to the sample to be run.

Each tutorial contains an unmodified `inputs.json` file, as well as an `example_inputs.aws.json` file specifying a set of example inputs that could be run in AWS, and an `example_inputs.local.json` file specifying a set of example inputs that could be run locally.


## Running workflows locally

To run workflows locally, any file-type inputs must first be downloaded to a local directory. This can be done using the [AWS CLI](../README.md##Data-access).


### Via Cromwell

Requirements:
- Java 8 or higher
- [Docker](https://docs.docker.com/get-docker/)


1. Download the latest version of the Cromwell jar file from the [releases page](https://github.com/broadinstitute/cromwell/releases/tag/72).

e.g. for Cromwell version 72:
```bash
wget https://github.com/broadinstitute/cromwell/releases/download/72/cromwell-72.jar
```

2. Prepare your `inputs.json` file, or use one of the example files provided (you will want to use `example_inputs.local.json` when running locally). If any inputs are of type `File`, make sure they are downloaded and use their absolute paths in your `inputs.json` file.

3. Run the workflow

If you have used relative paths in your `inputs.json` file, make sure you are running this command from the directory where those relative paths align.

```bash
java -jar cromwell-72.jar run workflow_file --inputs input_json_file
```

Where the **workflow_file** is the path to the `.wdl` file you are trying to run, and the **inputs_json_file** is the path to the corresponding inputs file you prepared in step 2.

When workflow execution is complete, Cromwell will output a message directing you to the output file(s).


### Via `miniwdl`

Requirements:
- python3
- [Docker](https://docs.docker.com/get-docker/)

1. [Install miniwdl](https://github.com/chanzuckerberg/miniwdl#install-miniwdl)

2. Prepare your `inputs.json` file, or use one of the example files provided (you will want to use `example_inputs.local.json` when running locally). If any inputs are of type `File`, make sure they are downloaded and use their absolute paths in your `inputs.json` file.

3. Run the workflow

If you have used relative paths in your `inputs.json` file, make sure you are running this command from the directory where those relative paths align.

```bash
miniwdl run workflow_file -i input_json_file
```

Where the **workflow_file** is the path to the `.wdl` file you are trying to run, and the **inputs_json_file** is the path to the corresponding inputs file you prepared in step 2.


## Running workflows in the AWS cloud

**Workflows run in the AWS cloud will incur cloud compute costs**.
File-type inputs can be accessed directly from the cloud and will not need to be downloaded locally; the full `s3://` URL to these files should be used in the `inputs.json` file.


### Via the Amazon Genomics CLI

1. Make sure you are in this directory (dnastack-open-data/tutorials).

2. Set up your AWS environment using the [AGC getting started documentation](https://aws.github.io/amazon-genomics-cli/docs/getting-started/).

3. Deploy the agc project:

```bash
agc context deploy --all
```

4. List available workflows

```bash
agc workflow list
```

5. Run the workflow of your choice using the example inputs:

```bash
agc workflow run tutorial_name --context openData
```

Where **tutorial_name** is one of the workflows listed in the `agc workflow list` command; names correspond to the directory names of the different tutorials.

To run a workflow using a different set of inputs, generate an `inputs.json` file and edit the `tutorial_name/MANIFEST.json` file to point to that inputs file instead of the default `example_inputs.aws.json`, then run the `agc workflow run tutorial_name --context openData` command. The inputs file must be in the `tutorial_name` directory for this to work.

To check on the status of a workflow, run `agc workflow status [--run-id run_id]`

When the workflow is complete, outputs will be written to the AGC_BUCKET configured via the AGC setup steps. You should be able to get the execution bucket name using the following:

```bash
AGC_BUCKET=$(aws ssm get-parameter \
    --name /agc/_common/bucket \
    --query 'Parameter.Value' \
    --output text)
```

When you are finished running workflows, make sure to clean up your environment to avoid incurring additional costs for AGC resources:

```bash
agc context destroy --all
```
