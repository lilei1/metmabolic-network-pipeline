# Metabolic Network Pipeline

This pipeline builds and simulates a genome-scale metabolic model using CarveMe and COBRApy, with optional transcriptomics integration.

---

## 🚀 How to Use This Pipeline

### 🐳 Run with Docker

```bash
docker build -t metabolic-pipeline .
docker run -v $PWD:/workspace -w /workspace metabolic-pipeline nextflow run main.nf -c nextflow.config
```

### 🧪 Input Files
- `genome/genome.faa`: protein FASTA file for model building
- `omics/transcript_abundance.csv`: optional gene expression data for constraints

### 📤 Output
- `draft_model.xml`: initial genome-scale model
- `model_with_constraints.xml`: expression-constrained version
- `fba_result.txt`: predicted growth rate using FBA

---

## ✅ CI/CD Integration

This project includes a GitHub Actions workflow that:
- Builds a Docker image for the pipeline
- Installs Nextflow
- Runs the metabolic model pipeline automatically on commits

### ✅ Build Status Badge

![CI](https://github.com/your-username/metabolic-network-pipeline/actions/workflows/ci.yml/badge.svg)

Replace `your-username` with your GitHub username after publishing the repo.

