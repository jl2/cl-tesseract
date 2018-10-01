(in-package :cl-tesseract)

(cffi:define-foreign-library tesseract
  (:darwin (:or "libtesseract.4.dylib" "libtesseract.dylib"))
  (:linux (:or "libtesseract.so.4" "libtesseract.so"))
  (t (:default "libtesseract"))) ; Will this work on Windows?

(cffi:use-foreign-library tesseract)

(defvar *tessdata-directory* 
  #+unix
  (namestring (or (probe-file "/usr/local/share/tessdata") ; Homebrew
                  (probe-file "/usr/local/tessdata")
                  (probe-file "/usr/share/tesseract-ocr/4.00/tessdata/")))
  #+windows
  (namestring (probe-file "C:\\Program Files\\Tesseract OCR\\tessdata"))
  "*tessdata-directory* should point to the location of the directory containing 
.traineddata files for use by Tesseract. The value must be a string representing the full 
path to the directory. 

This searches in a common default location for each platform and will follow symlinks to 
find the true location of the tessdata directory if one exists.

If your .traineddata files are in a non-standard location, it can be shadowed; i.e.
(let ((*tessdata-directory* \"/path/to/tessdata\"))
     (image-to-text #P\"~/eurotext.jpg\"))")