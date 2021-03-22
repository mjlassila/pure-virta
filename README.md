# Pure-VIRTA
Contains [BaseX](https://basex.org/) scripts for transforming XML loaded from Elsevier Pure API to Finnish Ministry of Education VIRTA compatible XML.

Originally developed for Tampere University and therefore not ready-to-run in other contexts. Feel free to modify.

## Usage

You need [BaseX XML database](https://basex.org/) for using these scripts. You also need to modify the scripts to suit your spesific needs, as these scripts contains hardcoded values only relevant for Tampere University.

1. Fetch research-output and journal data from Pure.
2. Run basex create-supplementary-data.bxs to create publisher data needed in actual data transformation
3. Run basex virta-transformation.bxs. This creates VIRTA-compatible XML and runs local tests for validating the data.
4. Run basex virta-analytics.bxs for running only the tests.

