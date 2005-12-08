;;; -*-  Mode: Lisp; Package: Maxima; Syntax: Common-Lisp; Base: 10 -*- ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     The data in this file contains enhancments.                    ;;;;;
;;;                                                                    ;;;;;
;;;  Copyright (c) 1984,1987 by William Schelter,University of Texas   ;;;;;
;;;     All rights reserved                                            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;                 GJC 9:29am  Saturday, 5 April 1980		 	 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :maxima)
(macsyma-module transl)
(transl-module transl)

;;; File directory.

;;; MC:MAXSRC;TRANSL   Driver. Basic translation properties.
;;; MC:MAXSRC;TRANSS   User-interaction, FILE-I/O etc.
;;; MC:MAXSRC;TRANS1   Translation of JPG;MLISP and other FSUBRS.
;;;                    which take call-by-name parameters.
;;; MC:MAXSRC;TRANS2   LISTS, ARRAYs, other random operators.
;;; MC:MAXSRC;TRANS3   LAMBDA. CLOSURES. also used by fsubr call-by-name
;;;                    compatibility package.              
;;; MC:MAXSRC;TRANS4   operators, ".", "^^" some functions such as GAMMA.
;;; MC:MAXSRC;TRANS5   FSUBRS from COMM, and others, these are mere MACRO
;;;                    FSUBRS.
;;; MC:MAXSRC;TRANSF   floating point intensive properties. BIGFLOAT stuff.
;;; MC:MAXSRC;TROPER   Basic OPERATORS.
;;; MC:MAXSRC;TRUTIL   transl utilities.
;;; MC:MAXSRC;TRMODE   definition of MODEDECLARE. run time error checking code.
;;; MC:MAXSRC;TRDATA   this is the MODE data for the "built-in" functions.
;;; MC:LIBMAX;TRANSM   This defines the macro DEF%TR. When compiled on MC
;;;                     DEF%TR produces autoload definitions for TRANS1 thru L.
;;; MC:LIBMAX;PROCS   macro's needed.
;;; MC:LIBMAX;TPRELU   this file is INCLUDEF'ed by translated macsyma code.
;;; MC:LIBMAX;TRANSQ   these are macros for translated code. Loaded by TPRELU
;;;                    this is compile-time only.
;;; MC:LIBMAX;MDEFUN   contains the macro which defines macsyma functions.
;;;                    runtime and compile-time.
;;; MC:MAXSRC;ACALL is some run time support for translated code, array calls.
;;; MC:MAXSRC;FCALL  run-time translated function call support for uncompiled
;;;                  code. Many FSUBRS which are macros in TRANSQ.
;;; MC:MAXSRC;EVALW  EVAL-WHEN definition for interpreter.
;;; MC:MAXSRC;MLOAD  This has a hack hook into BATCH, which is needed to do
;;;                  TRANSLATE_FILE I/O. when using old-i/o SUPRV.


;;; Functions and literals have various MODE properties;;; >
;;; (at user level set up by $MODEDECLARE), such as "$FLOAT" and "$ANY".
;;; The main problem solved by this translater (and the reason that
;;; it works on forms from the "inside out" as an evaluator would do
;;; (expect for macro forms)), is the problem of type (MODE) dependant
;;; function calling and mode conversion. The function TRANSLATE
;;; returns a list  where the CAR of the list is the MODE of the
;;; expression and the CDR is the expression to be evaluated by
;;; the lisp evaluator to give the equivalent result of evaluating
;;; the given macsyma expression with the macsyma evaluator.
;;; One doesn't know the MODE of an expression until seeing the modes
;;; of all its parts. See "*UNION-MODE"

;;; weak points in the code
;;; [1] duplication of functionality in the translaters for
;;; MPLUS MTIMES etc. 
;;; [3] primitive mode scheme. lack of even the most primitive general
;;; type coercion code. Most FORTRAN compilers are better than this.
;;; [4] for a compiler, this code SUCKS when it comes to error checking
;;; of the code it is munging. It doesn't even do a WNA check of system
;;; functions!
;;; [5]
;;; The duplication of the code which handles lambda binding, in MDO, MDOIN
;;; TR-LAMBDA, and MPROG, is very stupid. For macsyma this is one of
;;; the hairier things. Declarations must be handled, ASSIGN properties...
;;; -> Binding of ASSIGN properties should be handled with he "new"
;;; UNWIND-PROTECT instead of at each RETURN, and at "hope" points such as
;;; the ERRLIST. {Why wasn't this obvious need for UNWIND-PROTECT made
;;; known to the lisp implementers by the macsyma implementers? Why did it
;;; have to wait for the lisp machine group? Isn't this just a generalization
;;; of special binding?}
;;; [6] the DCONVX idea here is obscurely coded, incomplete, and totally
;;; undocumented. It was probably an attempt to hack efficient
;;; internal representations (internal to a given function), for some macsyma
;;; data constructs, and yet still be sure that fully general legal data
;;; frobs are seen outside of the functions. Note: this can be done
;;; simply by type coercion and operator folding.

;;; General comments on the stucture of the code.
;;; A function named TR-<something> means that it translates
;;; something having to do with that something.
;;; N.B. It does not mean that that is the translate property for <something>.


(defmvar $transbind nil
  "This variable is now obsolete."
  )

(defun obsolete-variable (var ignore-val) ignore-val
       (cond ((eq (symbol-value var) '$obsolete))
	     (t
	      (set var '$obsolete)
	      (mtell "~%Warning, setting obsolete variable: ~:M~%" var))))

(putprop '$transbind #'obsolete-variable 'assign)

(defvar *untranslated-functions-called* nil)
(declaim (special *declared-translated-functions*))

(defmvar $tr_semicompile nil
  "If TRUE TRANSLATE_FILE and COMPFILE output forms which will~
	 be macroexpanded but not compiled into machine code by the~
	 lisp compiler.")
(defmvar  $transcompile  t
  "If TRUE TRANSLATE_FILE outputs declarations for the COMPLR.
	  The only use of the switch is to save the space declarations take
	  up in interpreted code.")

(defmvar $special nil "This is an obsolete variable -GJC")

(putprop '$special #'obsolete-variable 'assign)

(defmvar tstack nil " stack of local variable modes ")

(defmvar local nil "T if a $local statement is in the body.")
(defmvar arrays nil "arrays to declare to `complr'")
(defmvar lexprs nil "Lexprs to declare.")
(defmvar exprs nil "what else?")
(defmvar fexprs nil "Fexprs to declare.")
(defmvar tr-progret t)
(defmvar inside-mprog nil)
(defmvar returns nil "list of `translate'd return forms in the block.")
(defmvar return-mode nil "the highest(?) mode of all the returns.")
(defmvar need-prog? nil)
(defmvar assigns nil "These are very-special variables which have a Maxima
	assign property which must be called to bind and unbind the variable
	whenever it is `lambda' bound.")
(defmvar specials nil "variables to declare special to the complr.")
(defmvar translate-time-evalables
    '($modedeclare $alias $declare $infix $nofix $declare_translated
      $matchfix $prefix $postfix $compfile))

(defmvar *transl-backtrace* nil
  " What do you think? ")
(defmvar *transl-debug* nil "if T it pushes `backtrace' and `trace' ")

(defmvar tr-abort nil "set to T if abortion is requested by any of the
	sub-parts of the translation. A *THROW would be better, although it
	wouldn't cause the rest of the translation to continue, which may
	be useful in translation for MAXIMA-ERROR checking.")

(defmvar tr-unique (gensym)
  "this is just a unque object used for random purposes,
	such as the second (file end) argument of READ.")


(defmvar $tr_warn_undeclared
    '$compile
  "When to send warnings about undeclared variables to the TTY")

(defmvar $tr_warn_meval
    '$compfile
  "If `meval' is called that indicates problems in the translation")

(defmvar $tr_warn_fexpr
    '$compfile
  "FEXPRS should not normally be output in translated code, all legitimate
special program forms are translated.")

(defmvar $tr_warn_mode
    '$all
  "Warn when variables are assigned values out of their mode.")

(defmvar $tr_warn_undefined_variable
    '$all
  "Warn when undefined global variables are seen.")


(defmvar *warned-un-declared-vars* nil "Warning State variable")
(defmvar *warned-fexprs* nil "Warning State variable")
(defmvar *warned-mode-vars* nil "Warning State variable")

(defmvar $tr_function_call_default '$general
  "
FALSE means punt to MEVAL, EXPR means assume lisp fixed arg function.
GENERAL, the default gives code good for mexprs and mlexprs but not macros.
GENERAL assures variable bindings are correct in compiled code.
In GENERAL mode, when translating F(X), if F is a bound variable, then
it assumes that APPLY(F,[X]) is meant, and translates a such, with 
apropriate warning. There is no need to turn this off.
APPLY means like APPLY.")

(defmvar $tr_array_as_ref t
  "If true runtime code uses value of the variable as the array.")

(defmvar $tr_numer nil
  "If `true' numer properties are used for atoms which have them, e.g. %pi")

(defmvar $tr_predicate_brain_damage nil
  "If TRUE, output possible multiple evaluations in an attempt
  to interface to the COMPARE package.")

(defvar boolean-object-table
  '(($true . ($boolean . t))
    ($false . ($boolean . nil))
    (t . ($boolean . t))
    (nil . ($boolean . nil))))

(defvar mode-init-value-table
  '(($float . 0.0)
    ($fixnum . 0)
    ($number  . 0)
    ($list . '((mlist)))
    ($boolean  . nil)))

(defvar tr-lambda-punt-assigns nil
  "Kludge argument to `tr-lambda' due to lack of keyword argument passing")

(or (boundp '*in-compile*) (setq *in-compile* nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deftrfun tr-tell (&rest x &aux (tp t))
  (do ((x x (cdr x)))
      ((null x))
    (cond ((atom (car x)) ;;; simple heuristic that seems to work.
	   (cond ((or tp (> (flatc (car x)) 10.))
		  (dolist (v *translation-msgs-files*) (terpri v))
		  (setq tp nil)))
	   (dolist (v *translation-msgs-files*)
	     (princ (print-invert-case (stripdollar (car x))) v)))
	  (t
	   (dolist (v *translation-msgs-files*) (mgrind (car x) v))))))

(deftrfun barfo (&rest l)
  (apply #'tr-tell
	 (nconc l
		'("***BARFO*** gasp. Internal TRANSLATE error. i.e. *BUG*")))
  (cond (*transl-debug*
	 (*break t '|Transl Barfo|))
	(t
	 (setq tr-abort t)
	 nil)))

(defun specialp (var)
  (cond ((or (optionp var)
	     (get var 'special))
	 (if $transcompile (addl var specials))
	 t)))


;;; The error message system. Crude as it is.
;;; I tell you how this aught to work:
;;; (1) All state should be in one structure, one state variable.
;;; (2) Should print out short message on-the-fly so that it
;;;     gives something to watch, and also so that it says something
;;;     if things crash.
;;; (3) Summaries on a cross-referenced per-function and per-item
;;;     should be printed at the end, as a table.
;;;     e.g.
;;;     Undefined Functions     used in
;;;     FOO                     BAR, BAZ,BOMB
;;;     FOOA                    P,Q
;;;     Undefined Variables ... same thing
;;;     Incomprehensible special forms
;;;     EV                      ....
;;;     Predicate Mode Targetting failures.
;;;     .....  -gjc

;;; The way it works now is to print too little or too much.
;;; Many items are only warned about the first time seen.
;;; However, this isn't too much of a problem when using Emacs
;;; to edit code, because searching for warned-about tokens
;;; is quick and easy.

(defmvar *tr-warn-break* t
  " if in debug mode `warning's signaled go to lisp break loops ")

(defmacro tr-warnbreak () `(and *transl-debug* *tr-warn-break* (*break t 'transl)))


(defun tr-warnp (val)
  (and val
       (cond (*in-compile*
	      (memq val '($all $compile $compfile $translate)))
	     ((or *in-compfile* *in-translate-file*)
	      (memq val '($all $compfile $translate)))
	     (*in-translate*
	      (memq val '($all $translate))))))

(defvar warned-undefined-variables nil)

(deftrfun warn-undefined-variable (form)
  (and (tr-warnp $tr_warn_undefined_variable)
       (cond ((memq form warned-undefined-variables))
	     ('else
	      (push form warned-undefined-variables)
	      (tr-format "~%Warning-> ~:M is an undefined global variable."
			 form)
	      (tr-warnbreak)))))

(deftrfun warn-undeclared (form &optional comment)
  (and (tr-warnp $tr_warn_undeclared)
       (cond ((zl-member form *warned-un-declared-vars*) t)
	     (t
	      (push form *warned-un-declared-vars*)
	      (tr-format
	       "~%WARNING-> ~:M has not been MODEDECLAREd, ~
		       taken as mode `any'."
	       form)
	      (cond (comment
		     (dolist (v *translation-msgs-files*) (terpri v) (princ comment v))
		     ))
	      (tr-warnbreak)
	      nil))))

(deftrfun warn-meval (form &optional comment)
  (cond ((tr-warnp $tr_warn_meval)
	 (tr-format
	  "~%WARNING-> ~:M~
		       ~%has caused a call to the evaluator to be output,~
		       ~%due to lack of information. Code will not work compiled."
	  form)
	 (cond (comment       (dolist (v *translation-msgs-files*) (terpri v) (princ comment v))))
	 (tr-warnbreak)
	 'warned)))


(deftrfun warn-mode (var mode newmode &optional comment)
  (cond ((eq mode newmode))
	(t
	 (cond ((and (tr-warnp $tr_warn_mode)
		     (not (covers mode newmode))
		     (not (zl-member (list var mode newmode)
				     *warned-mode-vars*)))
		(push (list var mode newmode) *warned-mode-vars*)
		(tr-format
		 "~%WARNING-> Assigning variable ~:M, whose mode is ~:M,~
		 a value of mode ~:M."
		 var mode newmode)
		(cond (comment
		       (dolist (v *translation-msgs-files*) (terpri v) (princ comment v))
		       ))
		(tr-warnbreak))))))

(deftrfun warn-fexpr (form &optional comment)
  (cond ((and (tr-warnp $tr_warn_fexpr)
	      (not (zl-member form *warned-fexprs*)))
	 (push  form *warned-fexprs*)
	 (tr-format
	  "~%WARNING->~%~:M~
		       ~%is a special function without a full LISP translation~
		       ~%scheme. Use in compiled code may not work."
	  form
	  )
	 (cond (comment       (dolist (v *translation-msgs-files*) (terpri v) (princ comment v))))
	 (tr-warnbreak))))


(defun macsyma-special-macro-p (fcn)
  (getl-lm-fcn-prop  fcn  '( macro)))
;;
;;(DEFUN MACSYMA-SPECIAL-OP-P (Fcn)
;;   #-lispm
;;    
;;        (GETL F '(FSUBR FEXPR MFEXPR* MFEXPR*S *FEXPR)))

(defun macsyma-special-op-p (f)
  (getl f '(fsubr fexpr mfexpr* mfexpr*s *fexpr)))

(defun possible-predicate-op-p (f)
  (memq f '(mnotequal mequal $equal
	    mgreaterp mgeqp mlessp mleqp)))

(defun warn-predicate (form)
  (warn-meval
   form
   (cond ((atom form)
	  "This variable should be declared `boolean' perhaps.")
	 ((macsyma-special-op-p (caar form))
	  "Special form not handled in targeting: Transl bug.")
	 ((possible-predicate-op-p (caar form))
	  "Unable to assert modes of subexpressions, a call to the macsyma data *print-base* has been generated.")
	 (t
	  "`translate' doesn't know predicate properties for this, a call to the macsyma data *print-base* has been generated."))))

;;;***************************************************************;;;

;;; This function is the way to call the TRANSLATOR on an expression with
;;; locally bound internal mode declarations. Result of TR-LAMBDA will be
;;; (MODE . (LAMBDA (...) (DECLARE ...) TRANSLATED-EXP))

(defun tr-local-exp (exp &rest vars-modes)
  (let ((loc (let ((tr-lambda-punt-assigns t))
	       (tr-lambda `((lambda) ((mlist)  ,@(do ((l vars-modes (cddr l))
						      (ll nil (cons (car l) ll)))
						     ((null l) ll)
						     (or (variable-p (car l))
							 (bad-var-warn (car l)))
						     ))
			    (($modedeclare)  ,@ (copy-rest-arg vars-modes))
			    ,exp)))))
    (let ((mode (car loc))
	  (exp (car (last loc)))) ;;; length varies with TRANSCOMPILE.
      (cons mode exp))))

(defun tr-args (form)
  (mapcar #'(lambda (x) (dconvx (translate x))) form))

(defun dtranslate (form) (cdr (translate form)))

(defun dconv (x mode) 
  (cond ((eq '$float mode) (dconv-$float x))
	((eq '$cre mode) (dconv-$cre x))
	(t (cdr x))))

(defun dconvx (x) 
  (if (memq (car x) '(ratexpr pexpr)) (dconv-$cre x) (cdr x)))

(defun dconv-$float (x)
  (cond ((memq (car x) '($fixnum $number))
	 (if (integerp (cdr x)) (float (cdr x)) (list 'float (cdr x))))
	((eq '$rational (car x))
	 (ifn (eq 'quote (cadr x)) `($float ,(cdr x))
	      (//$ (float (cadadr (cdr x))) (float (caddr (caddr x))))))
	(t (cdr x))))

(defun dconv-$cre (x) (if (eq '$cre (car x)) (cdr x) `(ratf ,(cdr x))))

(defmvar *$any-modes* '($any $list))

(defun covers (mode1 mode2)
  (cond ((eq mode1 mode2) t)
	((eq '$float mode1) (memq mode2 '($float $fixnum $rational)))
	((eq '$number mode1) (memq mode2 '($fixnum $float)))
	((memq mode1 *$any-modes*) t)))


;;; takes a function name as input.

(deftrfun tr-mfun (name &aux (*transl-backtrace* nil))
  (let   ((def-form (consfundef name nil nil)))
    (cond ((null def-form)
	   (setq tr-abort t))
	  (t
	   (tr-mdefine-toplevel def-form)))))

;;; DEFUN
;;; All the hair here to deal with macsyma fexprs has been flushed.
;;; Right now this handles MDEFMACRO and MDEFINE. The decisions
;;; of where to put the actual properties and what kind of
;;; defuns to make (LEXPR EXPR for maclisp) are punted to the
;;; macro package.

(defun tr-mdefine-toplevel (form &aux (and-restp nil))
  (destructuring-let (( (((name . flags) . args) body) (cdr form))
		      (a-args) kind out-forms)

    (do ((args args (cdr args))
	 ;; array functions cannot be LEXPR-like. gee.
	 ;; there is no good reason for that, except for efficiency,
	 ;; and I know that efficiency was not a consideration.
	 (full-restricted-flag (or (eq name 'mqapply)
				   (memq 'array flags))))
	((null args) (setq a-args (nreverse a-args)))
      (let ((u (car args)))
	(cond ((atom u)
	       (push u a-args))
	      ((and (not full-restricted-flag)
		    (not and-restp)
		    (eq (caar u) 'mlist)
		    (cdr u) (atom (cadr u)))
	       (push (cadr u) a-args)
	       (setq and-restp t))
	      (t
	       (push tr-unique a-args)))))

    
    (cond ((eq name 'mqapply) 
	   ;; don't you love syntax!
	   ;; do a switch-a-roo here. Calling ourselves recursively
	   ;; like this allows all legal forms and also catches
	   ;; errors. However, certain generalizations are also
	   ;; allowed. They won't get passed the interpreter, but
	   ;; interesting things may happen here. Thats what you
	   ;; get from too much syntax, so don't sweat it.
	   (tr-mdefine-toplevel
	    `(,(car form) ,(car args)
	      ((lambda) ((mlist) ,@(cdr args)) ,body))))
	  ((memq tr-unique a-args)
	   (tr-tell "Bad argument list for a function to translate->"
		    `((mlist),@args))
	   (setq tr-abort t)
	   nil)
	  ((memq (caar form) '(mdefine mdefmacro))
	   (setq kind (cond ((eq (caar form) 'mdefmacro) 'macro)
			    ((memq 'array flags) 'array)
			    (t 'func)))
	   (let* ((t-form
		   (tr-lambda `((lambda)
				((mlist) ,@a-args) ,body)))
		  (desc-header
		   `(,name ,(car t-form) ,(caar form)
		     ,and-restp ,(eq kind 'array))))
	     (cond ((eq kind 'func)
		    (push-pre-transl-form
		     `(defmtrfun-external ,desc-header))
		    (and (not (memq (car t-form) '($any nil)))
			 (putprop name (car t-form) 'function-mode)))
		   ((eq kind 'array)
		    (and (not (memq (car t-form) '($any nil)))
			 (decmode-arrayfun name (car t-form)))))

	     (cond ((or *in-translate* (not $packagefile))
					; These are all properties which tell the
					; user that functions are in the environment,
					; and that also allow him to SAVE the functions.
		    (push `(defprop ,name t translated) out-forms)
		    (push `(add2lnc ',name $props) out-forms)
		    (cond ((eq '$all $savedef)
			   (push
			    `(add2lnc
			      '((,name ,@flags) ,@args)
			      ,(case kind
				     (array '$arrays)
				     (func '$functions)
				     (macro '$macros))) out-forms)))))
	     (cond ((eq '$all $savedef)
		    ;; For some reason one may want to save the
		    ;; interpreted definition even if in a PACKAGEFILE.
		    ;; not a good idea to use SAVEDEF anyway though.
		    (push `(mdefprop ,name
			    ((lambda) ((mlist) ,@args) ,body)
			    ,(case kind
				   (array 'aexpr)
				   (macro 'mmacro)
				   (func 'mexpr)))
			  out-forms)))
	     ;;once a function has been translated we want to make sure mfunction-call is eliminated.
	     (progn (remprop (car desc-header) 'undefined-warnp)
		    (setf (get (car desc-header) 'once-translated) "I was once translated"))
	     `(progn			;'COMPILE
	       ,@(nreverse out-forms)
	       (defmtrfun ,desc-header ,@(cdr (cdr t-form))))))
	  (t
	   (barfo '?)))))


(defun lisp-fcn-typep (fcn type)
  #-lispm (get fcn type)
  #+lispm (eq type (getl-lm-fcn-prop
		    fcn '(subr lsubr fsubr expr lexpr fexpr macro))))

(deftrfun translate-function (name)
  (bind-transl-state
   (setq *in-translate* t)
   (let ((lisp-def-form (tr-mfun name))
	 (delete-subr? (and (get name 'translated)
			    (not (lisp-fcn-typep name 'expr)))))
     (cond (tr-abort
	    (trfail name))
	   (t
	    (if delete-subr? (remprop name 'subr))
	    (if (mget name 'trace) (macsyma-untrace name))
	    (if (not $savedef) (meval `(($remfunction) ,name)))
	    (let ((lisp-action
					; apply EVAL so it is easy to TRACE.
					; ERRSET is crude, but...
		   (errset (apply 'eval (list lisp-def-form)))))
	      (cond ((not lisp-action)
		     (trfail name))
		    (t (values name lisp-def-form)))))))))


(defun trfail (x) (tr-tell x " failed to translate.") nil)


;;; should macsyma batch files support INCLUDEF? No, not needed
;;; and not as efficient for loading declarations, and macros 
;;; as simple LOADING is. Thats why there is EVAL_WHEN.

(deftrfun translate-macexpr-actual (form filepos)
  (declare (special *translate-buffered-forms*))
  ;; Called as the EVAL-PRINT part of the READ-EVAL-PRINT
  (if (and (not (atom form)) (symbolp (caar form)))
      (let ((p (get (caar form) 'tags)))
	;; So we can generate a tags file as we translate,
	;; this is an incredibly efficient way to do it
	;; since the incremental cost is almost nothing.
	(if p (funcall p form filepos))))
  (push (translate-macexpr-toplevel form)
	*translate-buffered-forms*))

(defmfun translate-and-eval-macsyma-expression (form)
  ;; this is the hyper-random entry to the transl package!
  ;; it is used by MLISP for TRANSLATE:TRUE ":=".
  (bind-transl-state
   (setq *in-translate* t)
   ;; Use FUNCALL so that we can be sure we can TRACE this even when
   ;; JPG sets PURE to NIL. Also, use a function named TRANSLATOR-EVAL
   ;; so we don't have to lose badly by tracing EVAL!
   (funcall (progn 'translator-eval)
	    (funcall (progn 'translate-macexpr-toplevel) form))))

(defun translator-eval (x) (eval x))

(defun apply-in$bind_during_translation (f form &rest l)
  (cond ((not ($listp (cadr form)))
	 (tr-format "Badly formed `bind_during_translation' variable list.~%~:M"
		    (cadr form))
	 (apply f form l))
	('else
	 (do ((l (cdr (cadr form)) (cdr l))
	      (vars nil)
	      (vals nil))
	     ((null l)
	      (mbinding (vars vals '$bind_during_translation)
			(apply f form l)))
	   (let ((p (car l)))
	     (cond ((atom p) (push p vars) (push (meval p) vals))
		   ((eq (caar p) 'msetq)
		    (push (cadr p) vars) (push (meval (caddr p)) vals))
		   ('else
		    (tr-format
		     "Badly formed `bind_during_translation' binding~%~:M"
		     p))))))))

;; This basically tells the msetq def%tr to use defparameter insetad
;; of setq because we're doing a setq at top-level, which isn't
;; specified by ANSI CL.
(defvar *macexpr-top-level-form-p* nil)

(defmfun translate-macexpr-toplevel (form &aux (*transl-backtrace* nil)
					  tr-abort)
  ;; there are very few top-level special cases, I don't
  ;; think it would help the code any to generalize TRANSLATE
  ;; to target levels.
  ;;
  ;; Except msetq at top-level is special for ANSI CL.  See below.
  (setq form (toplevel-optimize form))
  (cond ((atom form) nil)
	((eq (caar form) '$bind_during_translation)
	 (apply-in$bind_during_translation
	  #'(lambda (form) 
	      `(progn
		'compile
		,@(mapcar 'translate-macexpr-toplevel (cddr form))))
	  form))
	((eq (caar form) '$eval_when)
	 (let ((whens (cadr form))
	       (body (cddr form)) tr-whens)
	   (setq whens (cond (($listp whens) (cdr whens))
			     ((atom whens) (list whens))
			     (t
			      (tr-tell "Bad `eval-when' times"
				       (cadr form))
			      nil)))
	   (setq tr-whens (mapcar 'stripdollar whens))
	   (cond ((memq '$translate whens)
		  (mapc 'meval body)))
	   (cond ((memq '$loadfile whens)
		  `(progn 'compile
		    ,@(mapcar 'translate-macexpr-toplevel body)))
		 #+cl
		 ((setq tr-whens (intersect tr-whens '(compile load eval)))
		  `(eval-when
		    ,tr-whens
		    ,@(mapcar 'translate-macexpr-toplevel body)))
		 ((memq '$compile whens)
		  ;; strictly for the knowledgeable user.
		  ;; I.E. so I can use EVAL_WHEN(COMPILE,?SPECIALS:TRUE)
		  `(eval-when
		    (compile)
		    ,@(mapcar 'translate-macexpr-toplevel body))))))
	((memq (caar form) translate-time-evalables)
	 (meval1 form)
	 #-cl
	 `(meval* ',form)
	 #+cl
	 `(eval-when (compile load eval) (meval* ',form))
	 )
	((memq  (caar form) '(mdefine mdefmacro))
	 (let ((name (caaadr form))
	       (trl))
	   (tr-format
	    "~%Translating: ~:@M"
	    name)
	   (setq trl (tr-mdefine-toplevel form))
	   (cond (tr-abort
		  (tr-format
		   "~%~:@M failed to Translate.  Continuing..."
		   name)
		  `(meval* ',form))
		 (t trl))))
	((eq 'mprogn (caar form))
	 ;; flatten out all PROGN's of course COMPLR needs PROGN 'COMPILE to
	 ;; tell it to flatten. I don't really see the use of that since one
	 ;; almost allways wants to. flatten.
	 ;; note that this ignores the $%% crock.
	 `(progn 'compile
		 ,@(mapcar #'translate-macexpr-toplevel (cdr form))))
	((eq 'msetq (caar form))
	 ;; Toplevel msetq's should really be defparameter instead of
	 ;; setq for Common Lisp.  
	 (let ((*macexpr-top-level-form-p* t))
	   (dtranslate form)))
	((eq '$define_variable (caar form))
	 ;; Toplevel msetq's should really be defparameter instead of
	 ;; setq for Common Lisp.  
	 (let ((*macexpr-top-level-form-p* t))
	   (dtranslate form)))
	(t		
	 (let  ((t-form (dtranslate form)))
	   (cond (tr-abort
		  `(meval* ',form))
		 (t
		  t-form))))))



(defmvar $tr_optimize_max_loop 100.
  "The maximum number of times the macro-expansion and optimization
	 pass of the translator will loop in considering a form.
	 This is to catch macro expansion errors, and non-terminating
	 optimization properties.")

(defun toplevel-optimize (form)
  ;; it is vital that optimizations be done within the
  ;; context of variable meta bindings, declarations, etc.
  ;; Also: think about calling the simplifier here.
  (cond ((atom form)
	 (cond ((symbolp form)
		(let ((v (getl (mget form '$props) '($constant))))
		  (if v (cadr v) form)))
	       (t form)))
	('else
	 (do ((new-form)
	      (kount 0 (f1+ kount)))
	     ;; tailrecursion should always arrange for a counter
	     ;; to check for mobylossage.
	     ((> kount $tr_optimize_max_loop)
	      (tr-format
	       "~%Looping over ~A times in optimization of call to ~:@M~
		    ~%macro expand MAXIMA-ERROR likely so punting at this level."
	       $tr_optimize_max_loop (caar form))
	      form)
	   (setq new-form (toplevel-optimize-1 form))
	   (cond ((atom new-form)
		  (return (toplevel-optimize new-form)))
		 ((eq new-form form)
		  (return form))
		 (t
		  (setq form new-form)))))))

(defun toplevel-optimize-1 (form &aux (op (car form)) prop)
  (cond ((or (atom op)
	     (memq 'array op)) form)
	((progn (setq op (car op))
		(setq prop
		      (if $transrun	; crock a minute.
			  (or (get op 'translated-mmacro)
			      (mget op 'mmacro))
			  (or (mget op 'mmacro)
			      (get op 'translated-mmacro)))))
	 (mmacro-apply prop form))
	((setq prop ($get op '$optimize))
	 ;; interesting, the MAPPLY here causes the simplification
	 ;; of the form and the result.
	 ;; The optimize property can be used to implement
	 ;; such niceties as the $%% crock.
	 (mapply1 prop (list form) "an optimizer property" nil))
	((and ($get op '$transload)
	      (get op 'autoload)
	      ;; check for all reasonable definitions,
	      ;; $OPTIMIZE and MACRO already checked.
	      (not (or (get-lisp-fun-type op)
		       (getl op '(translate mfexpr* mfexpr*s
				  fsubr fexpr *fexpr
				  macro
				  ;; foobar?
				  ))
		       (mgetl op '(mexpr)))))
	 (load-function op t)
	 ;; to loop.
	 (cons (car form) (cdr form)))
	(t form)))

(deftrfun translate (form)
  (and *transl-debug* (push form *transl-backtrace*))
  (setq form (toplevel-optimize form))
  (and *transl-debug* (pop *transl-backtrace*))
  (prog2
      (and *transl-debug* (push form *transl-backtrace*))
      (cond ((atom form)
	     (translate-atom form))
	    ((consp form)
	     (translate-form form))
	    (t
	     (barfo "help")))
    ;; hey boy, reclaim that cons, just don't pop it!
    (and *transl-debug* (pop *transl-backtrace*))))

(defun translate-atom (form &aux temp)
  (cond ((numberp form) (cons (tr-class form) form))
	((setq temp (assq form boolean-object-table))
	 (cdr temp))
	((and (setq temp (mget form '$numer)) $tr_numer)
	 `($float . ,temp))
	((setq temp (implied-quotep form))
	 `($any . ',temp))
	((tboundp form)
	 (specialp form) ;; notes its usage if special.
	 (setq form (teval form))
	 `(,(value-mode form) . ,form))
	(t
	 (cond ((not (specialp form))
		(warn-undefined-variable form)
		(if $transcompile (addl form specials))))
	 ;; note that the lisp analysis code must know that
	 ;; the TRD-MSYMEVAL form is a semantic variable.
	 (let* ((mode (value-mode form))		
		(init-val (assq mode mode-init-value-table)))
	   (setq init-val (cond (init-val (cdr init-val))
				(t `',form)))
	   ;; in the compiler TRD-MSYMEVAL doesn't do a darn
	   ;; thing, but it provides dynamic initialization of
	   ;; variables in interpreted code which is translated
	   ;; in-core. In FILE loaded code the DEFVAR will take
	   ;; care of this.
	   (push-defvar form init-val)
	   `(,mode . (trd-msymeval ,form ,init-val))))))

(defun translate-form (form &aux temp)
  (cond ((eq (car form) 'meval) (cons '$any form)) ;;for those lispy macsyma forms
	((not (atom (caar form)))
	 ;; this is a check like that in the simplifier. form could
	 ;; result from substitution macros.
	 (translate `((mqapply) ,(caar form) . ,(cdr form))))
	((memq 'array (cdar form))
	 ;; dispatch this bad-boy to another module quick.
	 (tr-arraycall form))
	;; TRANSLATE properties have priority.
	((setq temp (get (caar form) 'translate))
	 ;; TPROP-CALL is a macro, think of it as FUNCALL.
	 ;; see the macro file if you are curious.
	 (tprop-call temp form))
	((setq temp (get-lisp-fun-type (caar form)))
	 (tr-lisp-function-call form temp))
	((setq temp (macsyma-special-macro-p (caar form)))
	 (attempt-translate-random-macro-op form temp))
	((setq temp (macsyma-special-op-p (caar form)))
	 ;; a special form not handled yet! foobar!
	 (attempt-translate-random-special-op form temp))
	((getl (caar form) '(noun operators))
	 ;; puntastical case. the weird ones are presumably taken care
	 ;; of by TRANSLATE properties by now.
	 (tr-infamous-noun-form form))
	
	;; "What does a macsyma function call mean?".
	;; By the way, (A:'B,B:'C,C:'D)$ A(3) => D(3)
	;; is not supported.
	(t
	 (tr-macsyma-user-function-call (caar form) (cdr form) form))))



(defmvar $tr_bound_function_applyp t)

(defun tr-macsyma-user-function-call (function args form)
  ;; this needs some work, output load-time code to
  ;; check for MMACRO properties, etc, to be really
  ;; foolproof.
  (cond ((eq $tr_function_call_default '$apply)
	 (translate `(($apply)  ,(caar form) ((mlist) ,@(cdr form)))))
	((eq $tr_function_call_default '$expr)
	 (tr-lisp-function-call form 'subr))
	     
	((eq $tr_function_call_default '$general)
	 (cond 
	     ;;; G(F,X):=F(X+1); case.
	     
	   ((and $tr_bound_function_applyp (tboundp function))
	    (let ((new-form `(($apply) ,function ((mlist) ,@args))))
	      (tr-tell function
		       "in the form "
		       form
		       "has been used as a function, yet is a bound variable"
		       "in this context. This code being translated as :"
		       new-form)
	      (translate new-form)))
	   ;; MFUNCTION-CALL cleverely punts this question to a FSUBR in the
	   ;; interpreter, and a macro in the compiler. This is good style,
	   ;; if a user is compiling then assume he is less lossage prone.
	   (t #+cl (pushnew (caar form) *untranslated-functions-called*)
	      (call-and-simp
	       (function-mode (caar form))
	       'mfunction-call `(,(caar form) ,@(tr-args args))))))
	(t
	 ;; This case used to be the most common, a real loser.
	 (warn-meval form)
	 `(,(function-mode (caar form)) . (meval ',form)))))


(defun attempt-translate-random-macro-op (form typel &aux tem)
  ;; da,da,da,da.
  (warn-fexpr form)
  (setq tem (translate-atoms form))
  (setf (car tem) (caar tem))
  `($any . ,tem))

(defun attempt-translate-random-special-op (form typel)
  ;; da,da,da,da.
  (warn-fexpr form)
  `($any . (meval ',(translate-atoms form))))




(defun tr-lisp-function-call (form type)
  (let ((op (caar form)) (mode) (args))
    (setq args (cond ((memq type '(subr lsubr expr))
		      (if $transcompile
			  (case type
			    ((subr) (addl op exprs))
			    ((lsubr) (addl op lexprs))
			    (t nil)))
		      (mapcar #'(lambda (llis) (dconvx (translate llis)))
			      (cdr form)))
		     (t
		      (if $transcompile (addl op fexprs))
		      (mapcar 'dtranslate (cdr form))))
	  mode (function-mode op))
    (call-and-simp mode op args)))

;;the once-translated is so that inside translate file where a function
;;has been translated, subsequent calls won't use mfunction call
(defun get-lisp-fun-type (fun &aux temp)
  ;; N.B. this is Functional types. NOT special-forms,
  ;; lisp special forms are meaningless to macsyma.
  (cond ((get fun '*lexpr) 'lsubr)
	((get fun '*expr) 'subr)
	;; *LEXPR & *EXPR gotten from DEFMFUN declarations
	;; which is loaded by TrData.
	((mget fun '$fixed_num_args_function)
	 'subr)
	((mget fun '$variable_num_args_function)
	 'lsubr)
	((setq temp #+lispm (getl-lm-fcn-prop fun '(expr subr lsubr))
	       #-lispm (getl fun '(expr subr lsubr)))
	 (car temp))
	#+(or cl lispm)
	((get fun 'once-translated))
	((get fun 'translated))
	(t nil)))

(defun tr-infamous-noun-form (form)
  ;; 'F(X,Y) means noun-form. The arguments are evaluated.
  ;;  but the function is cons on, not applied.
  ;;  N.B. for special forms and macros this is totally wrong.
  ;;  But, those cases are filtered out already, presumably.
       
  (let ((op (cond ((memq 'array (car form))
		   `(,(caar form) array))
		  (t `(,(caar form)))))
	(args (tr-args (cdr form))))
    `($any . (simplify (list ',op ,@args)))))



;;; Some atoms, soley by usage, are self evaluating. 

(defun implied-quotep (atom)
  (cond ((get atom 'implied-quotep)
	 atom)
	((char= (getcharn atom 1)  #\&)    ;;; mstring hack
	 (cond ((eq atom '|&**|) ;;; foolishness. The PARSER should do this.
		;; Losing Fortran hackers.
		(tr-format
		 "~% `**' is obsolete, use `^' !!!")
		'|&^|)
	       (t atom)))
	(t nil)))

(defun translate-atoms (form)
  ;; This is an oldy moldy which tries to declare everthing
  ;; special so that calling fexpr's will work in compiled
  ;; code. What a joke.
  (cond ((atom form)
	 (cond ((or (numberp form) (memq form '(t nil))) form)
	       ((tboundp form)
		(if $transcompile
		    (or (specialp form)
			(addl form specials)))
		form)
	       (t
		(if $transcompile (addl form specials))
		form)))
	((eq 'mquote (caar form)) form)
	(t (cons (car form) (mapcar 'translate-atoms (cdr form))))))


;;; the Translation Properties. the heart of TRANSL.

;;; This conses up the call to the function, adding in the
;;; SIMPLIFY i the mode is $ANY. This should be called everywhere.
;;; instead of duplicating the COND everywhere, as is done now in TRANSL.

(defun tr-nosimpp (op)
  (cond ((atom op)
	 (get op 'tr-nosimp))
	(t nil)))

(defun call-and-simp (mode fun args)
  (cond ((or (not (eq mode '$any))
	     (tr-nosimpp fun))
	 `(,mode ,fun . ,args))
	(t
	 `(,mode simplify (,fun . ,args)))))


(def%tr $bind_during_translation (form)
  (apply-in$bind_during_translation
   #'(lambda (form)
       (translate `((mprogn) ,@(cddr form))))
   form))

(defmspec $declare_translated (fns)
  (setq fns (cdr fns))
  (loop for v in fns
	when (symbolp v)
	do (setf (get v 'once-translated) t)
	(pushnew v *declared-translated-functions*)
	else do (merror "Declare_translated needs symbolic args")))

(def%tr $declare (form)
  (do ((l (cdr form) (cddr l)) (nl))
      ((null l) (if nl `($any $declare . ,(nreverse nl))))
    (cond ((not (eq '$special (cadr l)))
	   (setq nl (cons (cadr l) (cons (car l) nl))))
	  ((atom (car l)) (spec (car l)))
	  (t (mapcar 'spec (cdar l))))))

(defun spec (var)
  (addl var specials)
  (putprop var t 'special)
  (putprop var var 'tbind))


(def%tr $eval_when (form)
  (tr-tell
   "`eval_when' can only be used at top level in a file"
   form
   "it cannot be used inside an expression or function.")
  (setq tr-abort t)
  '($any . nil))

(def%tr mdefine (form) ;; ((MDEFINE) ((F) ...) ...)
  (tr-format
   "A definition of the function ~:@M is given inside a program.~
   ~%This doesn't work well, try using `lambda' expressions instead.~%"
   (caar (cadr form)))
  `($any . (meval ',form)))

(def%tr mdefmacro (form)
  (tr-format "A definiton of a macro ~:@M is being given inside the~
	     ~%body of a function or expression. This probably isn't going~
	     ~%to work, local macro definitions are not supported.~%"
	     (caar (cadr form)))
  (meval form)
  `($any . (meval ',form)))

(def%tr $local (form)
  (cond (local (tr-format
		"Too many `local' statements in one block")
	       (setq tr-abort t))
	(t (setq local t)))
  (tr-format "Local does not work well in translated code.~
              ~%Try to use value cell and the Use_fast_arrays:true
              ~%if this is for arrays.  For functions, local definitions are~
               ~%not advised so use lambda expression")
  (cons nil (cons 'mlocal (cdr form)))
  )


(def%tr mquote (form) (list (tr-class (cadr form)) 'quote (cadr form)))


 
(defun tr-lambda (form &optional (tr-body #'tr-seq) &rest tr-body-argl
		  &aux
		  (arglist (mparams (cadr form)))
		  (easy-assigns nil))
  ;; This function is defined to take a simple macsyma lambda expression and
  ;; return a simple lisp lambda expression. The optional TR-BODY hook
  ;; can be used for translating other special forms that do lambda binding.
  
  ;; Local SPECIAL declarations are not used because
  ;; the multics lisp compiler does not support them. They are of course
  ;; a purely syntactic construct that doesn't buy much. I have been
  ;; advocating the use of DEFINE_VARIABLE in macsyma user programs so
  ;; that the use of DECLARE(FOO,SPECIAL) will be phased out at that level.

  (mapc #'tbind arglist)
  (destructuring-let (((mode . nbody) (apply tr-body (cddr form) tr-body-argl))
		      (local-declares (make-declares arglist t)))
    ;; -> BINDING of variables with ASSIGN properties may be difficult to
    ;; do correctly and efficiently if arbitrary code is to be run.
    (if (or tr-lambda-punt-assigns
	    (do ((l arglist (cdr l)))
		((null l) t)
	      (let* ((var (car l))
		     (assign (get var 'assign)))
		(if assign
		    (cond ((memq assign '(assign-mode-check))
			   (push `(,assign ',var ,(teval var)) easy-assigns))
			  (t
			   (return nil)))))))
	;; Case with EASY or no ASSIGN's
	(progn ;;-have to undo any local assignments. --wfs
	  #+lispm
	  (loop for v in nbody when (and (consp v) (eq (car v) 'mlocal))
		 do
		 (setq nbody `((unwind-protect (progn ,@nbody) (munlocal))))
		 (return 'done))
	  `(,mode . (lambda ,(tunbinds arglist)
		      ,local-declares
		      ,@easy-assigns
		      ,@nbody)))
	;; Case with arbitrary ASSIGN's.
	(let ((temps (mapcar #'(lambda (ign) ign (tr-gensym)) arglist)))
	  `(,mode . (lambda ,temps
		      (unwind-protect
			   (progn
			     ;; [1] Check before binding.
			     ,@(mapcan #'(lambda (var val)
					   (let ((assign (get var 'assign)))
					     (if assign
						 (list `(,assign ',var ,val)))))
				       arglist temps)
			     ;; [2] do the binding.
			     ((lambda ,(tunbinds arglist)
				,local-declares
				,@nbody)
			      ,@temps))
			;; [2] check when unbinding too.
			,@(mapcan #'(lambda (var)
				      (let ((assign (get var 'assign)))
					(if assign
					    (list `(,assign ',var
						    ;; use DTRANSLATE to
						    ;; catch global
						    ;; scoping if any.
						    ,(dtranslate var))))))
				  arglist))))))))


(defun update-global-declares ()
  (do ((l arrays (cdr l)) (mode))
      ((null l))
    (setq mode (array-mode (car l)))
    (cond ((eq '$fixnum mode)
	   (addl `(array* (fixnum (,(car l) 1))) declares))
	  ((eq '$float mode)
	   (addl `(array* (flonum (,(car l) 1))) declares))))
  (if specials (addl `(special ,@specials) declares))
  (if specials
      (setq declares (nconc (cdr (make-declares specials nil)) declares)))
  (if lexprs (addl `(*lexpr . ,(reverse lexprs)) declares))
  (if fexprs (addl `(*fexpr . ,(reverse fexprs)) declares)))

(defun make-declares (varlist localp &aux (dl) (fx) (fl) specs)
  (when $transcompile
    (do ((l varlist (cdr l))
	 (mode) (var))
	((null l))
      
      ;; When a variable is declared special, be sure to declare it
      ;; special here.
      (when (and localp (get (car l) 'special))
	(push (car l) specs))
      
      (when (or (not localp)
		(not (get (car l) 'special)))
	;; don't output local declarations on special variables.
	(setq var (teval (car l)) mode (value-mode var))
	(setq specs (cons var specs))
		
	(cond ((eq '$fixnum mode) (addl var fx))
	      ((eq '$float mode)  (addl var fl)))))
    (if fx (addl `(fixnum  . ,fx) dl))
    (if fl (addl `(flonum  . ,fl) dl))
    (if specs (addl `(special  . ,specs) dl))
    (if dl `(declare . ,dl))))

(def%tr dolist (form) (translate `((mprogn) . ,(cdr form))))

(defun tr-seq (l)
  (do ((mode nil)
       (body nil))
      ((null l)
       (cons mode (nreverse body)))
    (let ((exp (translate (pop l))))
      (setq mode (car exp))
      (push (cdr exp) body))))

(def%tr mprogn (form)
  (setq form (tr-seq (cdr form)))
  (cons (car form) `(progn ,@(cdr form))))
	


(def%tr mprog (form)
  (let (arglist body val-list)
    ;; [1] normalize the MPROG syntax.
    (cond (($listp (cadr form))
	   (setq arglist (cdadr form)
		 body (cddr form)))
	  (t
	   (setq arglist nil
		 body (cdr form))))
    (cond ((null body)
	   (tr-format "A `block' with no body: ~:M" form)
	   (setq body '(((mquote) $done)))))
    (setq val-list (mapcar #'(lambda (u)
			       (if (atom u) u
				   (translate (caddr u))))
			   arglist)
	  arglist (mapcar #'(lambda (u)
			      ;;  X or ((MSETQ) X Y)
			      (if (atom u) u (cadr u)))
			  arglist))
    (setq form
	  (tr-lambda
	   ;; [2] call the lambda translator.
	   `((lambda) ((mlist) ,@arglist) ,@body)
	   ;; [3] supply our own body translator.
	   #'tr-mprog-body
	   val-list
	   arglist))
    (cons (car form) `(,(cdr form) ,@val-list))))

(defun tr-mprog-body (body val-list arglist
		      &aux 
		      (inside-mprog t)
		      (return-mode nil)
		      (need-prog? nil)
		      (returns nil) ;; not used but must be bound.
		      (local nil)
		      )
  (do ((l nil))
      ((null body)
       ;; [5] hack the val-list for the mode context.
       ;; Perhaps the only use of the function MAP in all of macsyma.
       (mapl #'(lambda (val-list arglist)
		 (cond ((atom (car val-list))
			(rplaca val-list
				(or (cdr (assq (value-mode
						(car arglist))
					       mode-init-value-table))
				    `',(car arglist))))
		       (t
			(warn-mode (car arglist)
				   (value-mode (car arglist))
				   (car (car val-list))
				   "in a `block' statement")
			(rplaca val-list (cdr (car val-list))))))
	     val-list arglist)
       (setq l (nreverse l))
       (cons return-mode
	     (if need-prog?
		 `((prog () ,@(zl-delete nil l)))
		 l)))
    ;; [4] translate a form in the body
    (let ((form (pop body)))
      (cond ((null body)
	     ;; this is a really bad case.
	     ;; we don't really know if the return mode
	     ;; of the expression is for the value of the block.
	     ;; Some people write RETURN at the end of a block
	     ;; and some don't. In any case, the people not
	     ;; use the PROG programming style won't be screwed
	     ;; by this.
	     (setq form (translate form))
	     (setq return-mode (*union-mode (car form) return-mode))
	     (setq form (cdr form))
	     (if (and need-prog?
		      (or (atom form)
			  (not (eq (car form) 'return))))
		 ;; put a RETURN on just in case.
		 (setq form `(return ,form))))
	    ((symbolp form))
	    (t
	     (setq form (dtranslate form))))
      (push form l))))

(def%tr mreturn (form)
  (if (null inside-mprog)
      (tr-format "`return' found not inside a `block' 'do': ~%~:M" form))
  (setq need-prog? t)
  (setq form (translate (cadr form)))
  (setq return-mode (if return-mode (*union-mode (car form) return-mode)
			(car form)))
  (setq form `(return ,(cdr form)))
  (push form returns) ;; USED by lusing MDO etc not yet re-written.
  ;; MODE here should be $PHANTOM or something.
  `($any . ,form))

(def%tr mgo (form)
  (if (null inside-mprog)
      (tr-format "~%`go' found not inside a `block' or `do'. ~%~:M" form))
  (if (not (symbolp (cadr form)))
      (tr-format "~%`go' tag in form not symbolic.~%~:M" form))
  (setq need-prog? t)
  `($any . (go ,(cadr form))))

(def%tr mqapply (form)
  (let     ((fn (cadr form)) (args (cddr form)) 
	    (aryp (memq 'array (cdar form))))
    (cond ((atom fn) 
	   (mformat  *translation-msgs-files*
		     "~%Illegal mqapply form:~%~:M" form)
	   nil)
	  ((eq (caar fn) 'mquote) 
	   `($any list ',(cons (cadr fn) aryp) ,@(tr-args args)))
	  ((eq (caar fn) 'lambda)
	   ;; LAMBDA([X,'Y,[L]],...)(A,B,C) is a bogus form. Don't bother with it.
	   ;; ((LAMBDA) ((MLIST) ....) ....)
	   (cond ((memq 'bogus (mapcar #'(lambda (arg)
					   (cond ((or (mquotep arg)
						      ($listp arg))
						  'bogus)))
				       (cdr (cadr fn))))
		  (tr-format
		   "~%QUOTE or [] args are not allowed in mqapply forms.~%~
		  ~:M"
		   form)
		  (setq tr-abort t)
		  nil)
		 (t
		  (setq 	fn (tr-lambda fn)
				args (tr-args args))
		  `(,(car fn) ,(cdr fn) ,@args))))
	  ((not aryp)
	   `($any simplify (mapply ,(dconvx (translate fn))
			    (list ,@(tr-args args))
			    ',fn)))
	  (t
	   (warn-meval form)
	   `($any meval ',form)))))



(def%tr mcond (form) 
  (prog (dummy mode nl) 
     (setq dummy (translate (caddr form)) 
	   mode (car dummy) 
	   nl (list dummy (translate-predicate (cadr form))))
     (do ((l (cdddr form) (cddr l))) ((null l))
       (cond ((and (not (atom (cadr l))) (eq 'mcond (caaadr l)))
	      (setq l (cdadr l))))
       (setq dummy (translate (cadr l)) 
	     mode (*union-mode mode (car dummy)) 
	     nl (cons dummy
		      (cons (translate-predicate (car l))
			    nl))))
     (setq form nil)
     (do ((l nl (cddr l))) ((null l))
       (cond ((and (eq t (cadr l)) (null (cdar l))))
	     (t (setq form
		      (cons (cons (cadr l)
				  (cond ((and (not (atom (cdar l)))
					      (cddar l)
					      (eq (cadar l) 'progn))
					 (nreverse 
					  (cons (dconv (cons (caar l)
							     (car (reverse (cddar l))))
						       mode)
						(cdr (reverse (cddar l))))))
					((and (equal (cdar l) (cadr l))
					      (atom (cdar l))) nil)
					(t (list (cdr (car l))))))
			    form)))))
     (return (cons mode (cons 'cond form)))))



;; The MDO and MDOIN translators should be changed to use the TR-LAMBDA.
;; Perhaps a mere expansion into an MPROG would be best.

(defun new-end-symbol ( &aux tem)
  (loop for i from 0
	 do (setq tem (intern (format nil "test-~A" i)))
	 when (null (symbol-plist tem))
	 do (return tem)))

(declare-top (special shit))
(def%tr mdo (form )
  (let     (returns assigns return-mode local (inside-mprog t) tem
		    need-prog?)
    (let   (mode var init next test action varmode end-var init-end-var)
      (setq var (cond ((cadr form)) (t 'mdo)))
      (specialp var)
      (tbind var)
      (setq init (if (caddr form) (translate (caddr form)) '($fixnum . 1)))
      (ifn (setq varmode (get var 'mode)) (declvalue var (car init) t))
      (setq next (translate (cond ((cadddr form) (list '(mplus) (cadddr form) var))
				  ((car (cddddr form)))
				  (t (list '(mplus) 1 var)))))
      (setq form (copy-list form))
      ;;to make the end test for thru be numberp if the index is numberp
      ;;and to eliminate reevaluation
      tem
      #+lispm
      (cond ((setq tem (sixth form))
	     (cond ((symbolp tem)
		    (putprop tem (get var 'mode) 'mode))
		   (t (setq end-var (new-end-symbol))
		      (putprop end-var (get var 'mode) 'mode)
		      (putprop end-var end-var  'tbind)
		      (setq init-end-var `((,end-var ,(cdr (translate tem)))))
		      (setf (sixth form) end-var)))))
      (ifn varmode (declvalue var (*union-mode (car init) (car next)) t)
	   (warn-mode var varmode (*union-mode (car init) (car next))))
      (setq test (translate-predicate
		  (list '(mor)
			(cond ((null (cadr (cddddr form)))  nil)
			      ((and (cadddr form)
				    (mnegp ($numfactor (simplify (cadddr form)))))
			       (list '(mlessp) var (cadr (cddddr form))))
			      (t (list '(mgreaterp) var (cadr (cddddr form)))))
			(caddr (cddddr form)))))
      #+lispm
      (cond ((and tem (symbolp tem)) (remprop tem 'mode)))
      (cond ((and end-var (symbolp end-var))(remprop end-var 'mode)
	     (remprop end-var 'tbind)))
      (setq action (translate (cadddr (cddddr form)))
	    mode (cond ((null returns) '$any)
		       (t
			(if shit
			    (do ((l returns (cdr l))) ((null l))
			      (rplaca (cdar l) (dconv (cadar l) return-mode))))
			return-mode)))
      (setq var (tunbind (cond ((cadr form)) (t 'mdo))))
      `(,mode do ((,var ,(cdr init) ,(cdr next))
		  ,@ init-end-var )
	(,test '$done) . 
	,(cond ((atom (cdr action)) nil)
	       ((eq 'progn (cadr action)) (cddr action))
	       (t (list (cdr action))))))))

(setq shit nil)


(def%tr mdoin (form)
  (let     (returns assigns return-mode local (inside-mprog t)
		    need-prog?)
    (prog (mode var init action)
       (setq var (tbind (cadr form))) (tbind 'mdo)
       (specialp var)
       (setq init (dtranslate (caddr form)))
       (cond ((or (cadr (cddddr form)) (caddr (cddddr form)))
	      (tunbind 'mdo) (tunbind (cadr form))
	      (return `($any simplify (mdoin . ,(cdr form))))))
       (setq action (translate (cadddr (cddddr form)))
	     mode (cond ((null returns) '$any)
			(t
			 (if shit
			     (do ((l returns (cdr l))) ((null l))
			       (rplaca (cdar l) (dconv (cadar l) return-mode))))
			 return-mode)))
       (tunbind 'mdo) (tunbind (cadr form))
       (return
	 `(,mode do ((,var) (mdo (cdr ,init) (cdr mdo)))
	   ((null mdo) '$done)
	   (setq ,var (car mdo)) . 
	   ,(cond ((atom (cdr action)) nil)
		  ((eq 'progn (cadr action)) (cddr action))
		  (t (list (cdr action)))))))))


(defun lambda-wrap1 (tn val form)
  (if (or (atom val)
	  (eq (car val) 'quote))
      (subst val tn form)
      `((lambda (,tn) ,form) ,val)))
	  
(def%tr msetq (form)
  (let ((var (cadr form))
	(val (caddr form))
	assign
	mode)
    (cond ((atom var)
	   (setq mode (value-mode var) val (translate val))
	   (ifn (tboundp var) (addl var specials))
	   (warn-mode var mode (car val))
	   (if (eq '$any mode)
	       (setq mode (car val) val (cdr val))
	       (setq val (dconv val mode)))
	   (cons mode
		 (if (setq assign (get var 'assign))
		     (let ((tn (tr-gensym)))
		       (lambda-wrap1 tn val `(progn (,assign ',var ,tn)
					      (setq ,(teval var) ,tn))))
		     `(,(if *macexpr-top-level-form-p*
			    'defparameter
			    'setq)
			    ,(teval var) ,val))))
	  ((memq 'array (car var))
	   (tr-arraysetq var val))
	  (t
	   (tr-format "~%Dubious first LHS argument to ~:@M~%~:M"
		      (caar form) var)
	   (setq val (translate val))
	   `(,(car val) mset ',(translate-atoms var) ,(cdr val))))))



(def%tr $rat (form)
  (cond ((null (cddr form)) (cons '$cre (dconv-$cre (translate (cadr form)))))
	(t (setq tr-abort t) (cons '$any form))))


(def%tr $max (x) (translate-$max-$min x))
(def%tr $min (x) (translate-$max-$min x))
(def%tr %max (x) (translate-$max-$min x))
(def%tr %min (x) (translate-$max-$min x))

(defun translate-$max-$min (form)
  (let   ((mode) (arglist) (op (stripdollar (caar form))))
    (setq arglist 
	  (mapcar #'(lambda (l) (setq l (translate l)
				      mode (*union-mode (car l) mode))
			    l)
		  (cdr form)))
    (if (memq mode '($fixnum $float $number))
	`(,mode  ,(if (eq 'min op) 'min 'max) . ,(mapcar 'cdr arglist))
	`($any ,(if (eq 'min op) 'minimum 'maximum)
	  (list . ,(mapcar 'dconvx arglist))))))


;;; mode acessing, binding, handling. Super over-simplified.

(defun tr-class (x)
  (cond ((integerp x) '$fixnum)
	((floatp x) '$float)
	((memq x '(t nil)) '$boolean)
	((atom x) '$any)
	((eq 'rat (caar x)) '$rational)
	(t '$any)))

(defun *union-mode (mode1 mode2) 
  (cond ((eq mode1 mode2) mode1)
	((null mode1) mode2)
	((null mode2) mode1)
	((memq mode2 *$any-modes*) '$any)
	((memq mode1 *$any-modes*) '$any)
	((eq '$fixnum mode1) mode2)
	((eq '$float mode1)
	 (if (eq '$number mode2) '$number '$float))
	((eq '$rational mode1)
	 (if (eq '$float mode2) '$float '$any))
	((eq '$number mode1)
	 (if (eq '$rational mode2) '$any '$number))
	(t '$any)))



(defun value-mode (var) (cond ((get var 'mode))
			      (t
			       (warn-undeclared var)
			       '$any)))

(defun decmode-arrayfun (f m) (putprop f m 'arrayfun-mode))

(defun array-mode (ar) (cond ((get ar 'array-mode)) (t '$any)))
(defun arrayfun-mode (ar) (cond ((get ar 'arrayfun-mode)) (t '$any)))
(defun function-mode (f) (cond ((get f 'function-mode)) (t '$any)))
(defun function-mode-@ (f)
  (ass-eq-ref (get f 'val-modes) 'function-mode '$any))
(defun array-mode-@ (f)
  (ass-eq-ref (get f 'val-modes) 'array-mode '$any))


(defvar $tr_bind_mode_hook nil
  "A hack to allow users to key the modes of variables
  off of variable spelling, and other things like that.")

(eval-when (eval compile #-pdp10 load)
  (defstruct (tstack-slot #+maclisp conc-name
			  #-maclisp (:conc-name tstack-slot-)
			  #+maclisp tree
			  #-(or cl maclisp) :named)
    mode 
    tbind
    val-modes
    ;; an alist telling second order info
    ;; about APPLY(VAR,[X]), ARRAYAPPLY(F,[X]) etc.
    special))

;;; should be a macro (TBINDV <var-list> ... forms)
;;; so that TUNBIND is assured, and also so that the stupid ASSQ doesn't
;;; have to be done on the darn TSTACK. This will have to wait till
;;; the basic special form translation properties are rewritten.

(defun variable-p (var)
  (and var (symbolp var) (not (eq var t))))

(defun bad-var-warn (var)
  (tr-format "~%Bad object to use as a variable:~%~:M~%" var))

(defun tbind (var &aux old)
  (cond ((variable-p var)
	 (setq old (make-tstack-slot #+cl :mode #-cl mode (get var 'mode)
				     #+cl :tbind #-cl tbind (get var 'tbind)
				     #+cl :val-modes #-cl val-modes (get var 'val-modes)
				     #+cl :special #-cl special (get var 'special)))
	 (push (cons var old) tstack)
	 (cond ((not (specialp var))
		;; It is the lisp convention in use to inherit
		;; specialness from higher context.
		;; Spurious MODEDECLARATIONS get put in the environment
		;; when code is MEVAL'd since there is no way to stack
		;; the mode properties. Certainly nobody is willing
		;; to hack MEVAL in JPG;MLISP
		(remprop var 'val-modes)
		(remprop var 'mode)
		(remprop var 'special)))
	 (putprop var var 'tbind)
	 (if $tr_bind_mode_hook
	     (let ((mode? (mapply $tr_bind_mode_hook
				  (list var)
				  '$tr_bind_mode_hook)))
	       (if mode? (tr-declare-varmode var mode?))))
	 var)
	('else
	 (bad-var-warn var))))



(defun tunbind (var
		&aux
		(old (assq var tstack)))
  (when (variable-p var)
    (prog1
	(teval var)
      (cond (old
	     (setq tstack (delq old tstack)) ; POP should be all we need.
	     (setq old (cdr old))
	     (putprop1 var (tstack-slot-mode old) 'mode)
	     (putprop1 var (tstack-slot-tbind old) 'tbind)
	     (putprop1 var (tstack-slot-val-modes old) 'val-modes)
	     (putprop1 var (tstack-slot-special old) 'special))))))

(defun putprop1 (name value key)
  ;; leaves property list clean after unwinding, this
  ;; is an efficiency/storage issue only.
  (if value (putprop name value key) (progn (remprop name key) nil)))

(defun tunbinds (l)
  (do ((nl)) ((null l) nl)
    (setq nl (cons (tunbind (caar tstack)) nl) l (cdr l))))

(defun tboundp (var)
  ;; really LEXICAL-VARP.
  (and (get var 'tbind) (not (get var 'special))))

(defun teval (var) (or (get var 'tbind) var))




;; Local Modes:
;; Mode: LISP
;; Comment Col: 40
;; END:

