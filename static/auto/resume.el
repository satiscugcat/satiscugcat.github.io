;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "resume"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4" "11pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("amsmath" "") ("amsfonts" "") ("amssymb" "") ("dsfont" "") ("enumerate" "") ("color" "") ("hyperref" "") ("xcolor" "dvipsnames") ("xurl" "") ("physics" "") ("graphicx" "") ("geometry" "margin=1.6cm" "top=1cm" "bottom=1cm") ("longtable" "") ("nopageno" "") ("float" "")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art11"
    "inputenc"
    "amsmath"
    "amsfonts"
    "amssymb"
    "dsfont"
    "enumerate"
    "color"
    "hyperref"
    "xcolor"
    "xurl"
    "physics"
    "graphicx"
    "geometry"
    "longtable"
    "nopageno"
    "float"))
 :latex)

