# ==========================================
# arXiv-safe Technical Report Build System
# Uses: pdfLaTeX + BibTeX
# Upload: main.tex + main.bbl
# ==========================================

MAIN        := paper
LATEX       := pdflatex
BIB         := bibtex
LATEXFLAGS  := -interaction=nonstopmode -file-line-error -halt-on-error
ZIPNAME     := arxiv_submission.zip

# Default target
all: pdf ## Full build (pdflatex + bibtex + pdflatex x2)

pdf: $(MAIN).pdf ## Compile PDF with fresh bibliography

$(MAIN).pdf: $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	$(BIB) $(MAIN)
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex


locked: $(MAIN).pdf ## Compile PDF using existing .bbl (no BibTeX)
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex

quick: ## Quick compile (no BibTeX)
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex

bib: ## Regenerate bibliography (.bbl)
	$(BIB) $(MAIN)

zip: cleanaux pdf ## Create arXiv upload zip
	zip -r $(ZIPNAME) \
		$(MAIN).tex \
		preamble.tex \
		EU_AI_ACT.tex \
		literature.bib \
		-x "*.aux" "*.log" "*.out" "*.blg" "*.bbl" "*.toc" "*.lof" "*.lot" "*.fls" "*.fdb_latexmk" "*.synctex.gz"
	@echo "Created $(ZIPNAME)"

cleanaux: ## Remove auxiliary files (keep PDF)
	rm -f *.aux *.blg *.bbl *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz

clean: cleanaux ## Remove PDF as well
	rm -f $(MAIN).pdf

distclean: clean ## Remove everything including PDF and .bbl
	rm -f $(MAIN).pdf $(MAIN).bbl

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e "s/\\$$//" | sed -e "s/##//"