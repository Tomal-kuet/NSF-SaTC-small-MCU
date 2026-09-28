# Build the NSF SaTC proposal PDFs.
#
#   main.pdf                 – full project description (compiled with latexmk: handles bibtex/hyperref reruns)
#   summary.pdf               – standalone "Project Summary" document
#   facilities.pdf           – standalone "Facilities, Equipment, and Other Resources" document
#   mentoring.pdf            – standalone "Mentoring Plan" document
#   budget-justification.pdf – standalone "Budget Justification" document
#   project-description.pdf  – pages 1-15 of main.pdf, split via split.tex (research.gov upload)
#   references-cited.pdf     – pages 16-end of main.pdf, split via split.tex (research.gov upload)
#
# summary.pdf, facilities.pdf, mentoring.pdf, and budget-justification.pdf are built directly
# from their .tex sources via pdflatex (standalone / *-standalone.tex wrappers below) so
# research.gov gets a clean pdfTeX-produced PDF — never one re-exported through
# Preview/Quartz, which corrupts PDF object dictionaries and gets rejected on upload.
#
# Usage:
#   make                       build all five PDFs
#   make main                  build only main.pdf
#   make summary               build only summary.pdf
#   make facilities            build only facilities.pdf
#   make mentoring             build only mentoring.pdf
#   make budget-justification  build only budget-justification.pdf
#   make split                 split main.pdf into project-description.pdf and references-cited.pdf
#   make clean                 remove LaTeX build artifacts (keeps PDFs)
#   make distclean             remove build artifacts and the PDFs

LATEXMK  = latexmk -pdf -interaction=nonstopmode -halt-on-error
PDFLATEX = pdflatex -interaction=nonstopmode -halt-on-error

.PHONY: all main summary facilities mentoring budget-justification split clean distclean

all: main summary facilities mentoring budget-justification split

main: main.pdf

summary: summary.pdf

facilities: facilities.pdf

mentoring: mentoring.pdf

budget-justification: budget-justification.pdf

split: project-description.pdf references-cited.pdf

main.pdf: main.tex section1.tex section2.tex section3.tex thrusts.tex thrust1.tex thrust2.tex thrust3.tex misc.tex reference.bib
	$(LATEXMK) main.tex

summary.pdf: summary.tex
	$(PDFLATEX) -jobname=summary summary.tex

facilities.pdf: facilities.tex
	$(PDFLATEX) -jobname=facilities facilities.tex

mentoring.pdf: mentoring.tex
	$(PDFLATEX) -jobname=mentoring mentoring.tex

budget-justification.pdf: budget-justification.tex
	$(PDFLATEX) budget-justification.tex

project-description.pdf: split.tex main.pdf
	$(PDFLATEX) -jobname=project-description split.tex

references-cited.pdf: split.tex main.pdf
	$(PDFLATEX) -jobname=references-cited split.tex

clean:
	latexmk -c main.tex
	rm -f summary.aux summary.log summary.out
	rm -f facilities.aux facilities.log facilities.out
	rm -f mentoring.aux mentoring.log mentoring.out
	rm -f budget-justification.aux budget-justification.log budget-justification.out
	rm -f project-description.aux project-description.log references-cited.aux references-cited.log

distclean: clean
	rm -f main.pdf summary.pdf facilities.pdf mentoring.pdf budget-justification.pdf
	rm -f project-description.pdf references-cited.pdf
