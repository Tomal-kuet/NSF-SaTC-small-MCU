# Build the NSF SaTC proposal PDFs.
#
#   main.pdf       – full project description (compiled with latexmk: handles bibtex/hyperref reruns)
#   facilities.pdf – standalone "Facilities, Equipment, and Other Resources" document
#   mentoring.pdf  – standalone "Mentoring Plan" document
#
# facilities.pdf and mentoring.pdf are built directly from facilities.tex/mentoring.tex
# via pdflatex (through the *-standalone.tex wrappers below) so research.gov gets a
# clean pdfTeX-produced PDF — never one re-exported through Preview/Quartz, which
# corrupts PDF object dictionaries and gets rejected on upload.
#
# Usage:
#   make              build all three PDFs
#   make main         build only main.pdf
#   make facilities   build only facilities.pdf
#   make mentoring    build only mentoring.pdf
#   make clean        remove LaTeX build artifacts (keeps PDFs)
#   make distclean    remove build artifacts and the PDFs

LATEXMK  = latexmk -pdf -interaction=nonstopmode -halt-on-error
PDFLATEX = pdflatex -interaction=nonstopmode -halt-on-error

.PHONY: all main facilities mentoring clean distclean

all: main facilities mentoring

main: main.pdf

facilities: facilities.pdf

mentoring: mentoring.pdf

main.pdf: main.tex section1.tex section2.tex section3.tex thrusts.tex thrust1.tex thrust2.tex thrust3.tex mentoring.tex facilities.tex reference.bib
	$(LATEXMK) main.tex

facilities.pdf: facilities-standalone.tex facilities.tex
	$(PDFLATEX) -jobname=facilities facilities-standalone.tex

mentoring.pdf: mentoring-standalone.tex mentoring.tex
	$(PDFLATEX) -jobname=mentoring mentoring-standalone.tex

clean:
	latexmk -c main.tex
	rm -f facilities.aux facilities.log facilities.out
	rm -f mentoring.aux mentoring.log mentoring.out

distclean: clean
	rm -f main.pdf facilities.pdf mentoring.pdf
