
// Nextflow pipeline for constructing a genome-scale metabolic model using CarveMe and COBRApy

nextflow.enable.dsl=2

// Define parameters
params.faa = "genome/genome.faa"
params.outdir = "results"
params.transcript_csv = "omics/transcript_abundance.csv"

workflow {
  fasta_ch = Channel.fromPath(params.faa)
  transcript_ch = Channel.fromPath(params.transcript_csv)

  draft_model = build_model(fasta_ch)
  integrated_model = integrate_transcriptomics(draft_model, transcript_ch)
  simulate_fba(integrated_model)
}

process build_model {
  input:
    path faa_file

  output:
    path "draft_model.xml"

  script:
  """
  carveme draft -g ${faa_file} -o draft_model.xml
  """
}

process integrate_transcriptomics {
  input:
    path model_xml
    path transcript_file

  output:
    path "model_with_constraints.xml"

  container "python:3.9-slim"

  script:
  """
  pip install cobra pandas
  python3 -c '
import pandas as pd
from cobra.io import read_sbml_model, write_sbml_model
from cobra.flux_analysis import single_gene_deletion

model = read_sbml_model("${model_xml}")
tpm = pd.read_csv("${transcript_file}")
tpm_dict = dict(zip(tpm["gene"], tpm["TPM"]))
thresh = tpm["TPM"].quantile(0.25)

for gene in model.genes:
    if gene.id in tpm_dict and tpm_dict[gene.id] < thresh:
        gene.knock_out()

write_sbml_model(model, "model_with_constraints.xml")
'
  """
}

process simulate_fba {
  input:
    path curated_model

  output:
    path "fba_result.txt"

  container "python:3.9-slim"

  script:
  """
  pip install cobra
  python3 -c '
from cobra.io import read_sbml_model
model = read_sbml_model("${curated_model}")
sol = model.optimize()
with open("fba_result.txt", "w") as f:
    f.write(f"Growth rate: {sol.objective_value:.4f}\\n")
'
  """
}
