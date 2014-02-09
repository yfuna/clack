#|
  This file is a part of Clack package.
  URL: http://github.com/fukamachi/clack
  Copyright (c) 2011 Eitarow Fukamachi <e.arrows@gmail.com>

  Clack is freely distributable under the LLGPL License.
|#

(in-package :cl-user)
(defpackage clack.util.doc
  (:nicknames :doc)
  (:use :cl
        :split-sequence))
(in-package :clack.util.doc)

(cl-syntax:use-syntax :annot)

@export
'#.(defvar *section-plist*
       '(:synopsis "SYNOPSIS"
         :explanation "EXPLANATION"
         :dependencies "DEPENDENCIES"
         :description "DESCRIPTION"
         :example "EXAMPLE"
         :see "SEE ALSO"
         :author "AUTHOR"
         :contributors "CONTRIBUTORS"
         :copyright "COPYRIGHT"
         :license "LICENSE"))

@export
(defun start ()
  "Clears the documentation string of `*package*'.
I recommend you use `(doc:start)' before calling any clack.util.doc
functions, because, otherwise, they append sections already in the
string when the package is reloaded."
  (setf (documentation *package* t) ""))

@export
(defun doc (header &optional (string "") (level 1))
  "Appends a section with HEADER to the documentation string of the
current package."
  (setf (documentation *package* t)
        (concatenate 'string
                     (documentation *package* t)
                     (section header string level))))

@export
(defun section (header &optional (string "") (level 1))
  "Returns a string in the Clack's section format, using HEADER for 
the header and STRING as its content."
  (format nil "~:[~;~:*~V@{~A~:*~}~* ~A~2&~]~A~2&"
          level "#" header (string-left-trim #(#\Newline) string)))

@export
(defun name (string)
  (doc string))

#.`(progn
     ,@(loop for (fn-name sec) on *section-plist* by #'cddr
             collect
             `@export
               (defun ,(intern (symbol-name fn-name)) (string)
                 (doc ,sec
                      (string-left-trim #(#\Newline) string)
                      2))))

(doc::start)

@doc::NAME "
Clack.Util.Doc - For writing Clack documentations.
"

@doc::SYNOPSIS "

    ;; Clear documentation of `*package*'.
    (doc:start)
    
    (doc:NAME \"
    Clack - Web Application Environment for Common Lisp
    \")
    
    (doc:DESCRIPTION \"
    Clack is a Web application environment for Common Lisp inspired by Python's WSGI and Ruby's Rack. Your awesome framework should base on this.
    \")

    ;; I recommend using Clack.Util.Doc with cl-annot (https://github.com/arielnetworks/cl-annot).
    ;; It enables you to write docs with annotation-style.
    (cl-annot:enable-annot-syntax)
    
    (doc:start)
    
    @doc:NAME \"
    Clack - Web Application Environment for Common Lisp
    \"
"

@doc::DESCRIPTION "
Clack.Util.Doc enables you to write packabe documentation easy writing package documentations with a markdown-like syntax.
"

@doc::AUTHOR "
* Eitarow Fukamachi (e.arrows@gmail.com)
"

@doc::SEE "
* [cl-annot](https://github.com/arielnetworks/cl-annot)
"