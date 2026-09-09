# Build the NSF SaTC proposal PDFs.
#
#   main.pdf                 – full project description (compiled with latexmk: handles bibtex/hyperref reruns)
#   facilities.pdf           – standalone "Facilities, Equipment, and Other Resources" document
#   mentoring.pdf            – standalone "Mentoring Plan" document
#   budget-justification.pdf – standalone "Budget Justification" document
#
# facilities.pdf, mentoring.pdf, and budget-justification.pdf are built directly from
# their .tex sources via pdflatex (standalone / *-standalone.tex wrappers below) so
# research.gov gets a clean pdfTeX-produced PDF — never one re-exported through
# Preview/Quartz, which corrupts PDF object dictionaries and gets rejected on upload.
#
# Usage:
#   make                       build all four PDFs
#   make main                  build only main.pdf
#   make facilities            build only facilities.pdf
#   make mentoring             build only mentoring.pdf
#   make budget-justification  build only budget-justification.pdf
#   make clean                 remove LaTeX build artifacts (keeps PDFs)
#   make distclean             remove build artifacts and the PDFs

LATEXMK  = latexmk -pdf -interaction=nonstopmode -halt-on-error
PDFLATEX = pdflatex -interaction=nonstopmode -halt-on-error

.PHONY: all main facilities mentoring budget-justification clean distclean

all: main facilities mentoring budget-justification

main: main.pdf

facilities: facilities.pdf

mentoring: mentoring.pdf

budget-justification: budget-justification.pdf

main.pdf: main.tex section1.tex section2.tex section3.tex thrusts.tex thrust1.tex thrust2.tex thrust3.tex reference.bib
	$(LATEXMK) main.tex

facilities.pdf: facilities.tex
	$(PDFLATEX) -jobname=facilities facilities.tex

mentoring.pdf: mentoring.tex
	$(PDFLATEX) -jobname=mentoring mentoring.tex

budget-justification.pdf: budget-justification.tex
	$(PDFLATEX) budget-justification.tex

clean:
	latexmk -c main.tex
	rm -f facilities.aux facilities.log facilities.out
	rm -f mentoring.aux mentoring.log mentoring.out
	rm -f budget-justification.aux budget-justification.log budget-justification.out

distclean: clean
	rm -f main.pdf facilities.pdf mentoring.pdf budget-justification.pdf
