;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "moderncv"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("moderncv" "")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("graphicx" "") ("longtable" "") ("wrapfig" "") ("rotating" "") ("ulem" "normalem") ("amsmath" "") ("amssymb" "") ("capt-of" "") ("hyperref" "")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "moderncv10"
    "inputenc"
    "fontenc"
    "graphicx"
    "longtable"
    "wrapfig"
    "rotating"
    "ulem"
    "amsmath"
    "amssymb"
    "capt-of"
    "hyperref")
   (LaTeX-add-labels
    "sec:org17c1d23"
    "sec:org301f955"
    "sec:org3a12566"
    "sec:orgaaefac7"
    "sec:org8846508"
    "sec:org49d8f28"
    "sec:org7f71e87"
    "sec:org0ba81ed"))
 :latex)

