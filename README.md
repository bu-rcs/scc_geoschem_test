# Description

`test_geoschem.sh` wrapper script for running tests made available by [GeosCHEM](https://github.com/geoschem/GCClassic/tree/main) on BU's SCC.  

## ARGUMENTS

*GIT_TAG* - The first argument is the [release tag](https://github.com/geoschem/GCClassic/tags) you want to test (e.g. 14.4.0)

*OUTPUT_DIR* - The second argument is the location where you want the test to run.  In this directory the bash script will git clone the release tag and also create a `runs` directory.  The `runs` directory will contain the compiled models and log files for the runs.

## OVERVIEW

The following are the general steps of this script:

1. Clone the specified release tag of GeosCHEM specified into OUTPUT_DIR.
1. Source the `env.sh` file.
1. Create a `runs` directory in OUTPUT_DIR.
1. Run `./parallelTestCompile.sh` found in the GeosCHEM test directory to compile the included tests.  The compiled tests will be in `OUTPUT_DIR/runs` directory.
1. Run `./parallelTestExecute.sh` found in the GeosCHEM test directory to run the included tests.

## Files

`env.sh` - Environment file specific for the SCC.  
`test_geoschem.sh` - Bash script that runs the steps defined in the[Overview](#overview) section.

## Example Usage

1. Update the `env.sh` file with the SCC modules and compiling environment variables you want to test.
1. Run the `test_geoschem.sh` bash script.

```console
   bash test_geosche.sh 14.4.0 test_directory
```

## Review Results

The GeosCHEM tests generate a collection of logs for various steps, including:

- creating run directories
- compiling
- running in parallel

The logs can be found in the output directory: `OUTPUT_DIR/runs/log`
