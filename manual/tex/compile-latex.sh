#!/bin/bash


str='2013-mmsoda-manual'


latex -output-directory=./../out -interaction=nonstopmode $str.tex
cd ./../out
bibtex $str.aux
makeindex -o $str.ind $str.idx
cd ./../tex
latex -output-directory=./../out -interaction=nonstopmode $str.tex
latex -output-directory=./../out -interaction=nonstopmode $str.tex
dvips -o ./../out/$str.ps ./../out/$str.dvi
ps2pdf ./../out/$str.ps ./../out/$str.pdf
