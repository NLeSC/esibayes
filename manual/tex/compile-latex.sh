#!/bin/bash


str='2012-esibayes-manual'


latex -output-directory=./../out -interaction=nonstopmode $str.tex
bibtex ./../out/$str.aux
makeindex ./../out/$str.idx
latex -output-directory=./../out -interaction=nonstopmode $str.tex
latex -output-directory=./../out -interaction=nonstopmode $str.tex
dvips -o ./../out/$str.ps ./../out/$str.dvi
ps2pdf ./../out/$str.ps ./../out/$str.pdf
