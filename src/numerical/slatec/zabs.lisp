;;; Compiled by f2cl version 2.0 beta 2002-05-06
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':simple-array)
;;;           (:array-slicing nil) (:declare-common nil)
;;;           (:float-format double-float))

(in-package "SLATEC")


(defun zabs (zr zi)
  (declare (type double-float zi zr))
  (prog ((u 0.0) (v 0.0) (q 0.0) (s 0.0) (zabs 0.0))
    (declare (type double-float zabs s q v u))
    (setf u (coerce (abs zr) 'double-float))
    (setf v (coerce (abs zi) 'double-float))
    (setf s (+ u v))
    (setf s (* s 1.0))
    (if (= s 0.0) (go label20))
    (if (> u v) (go label10))
    (setf q (/ u v))
    (setf zabs (* v (f2cl-lib:fsqrt (+ 1.0 (* q q)))))
    (go end_label)
   label10
    (setf q (/ v u))
    (setf zabs (* u (f2cl-lib:fsqrt (+ 1.0 (* q q)))))
    (go end_label)
   label20
    (setf zabs 0.0)
    (go end_label)
   end_label
    (return (values zabs nil nil))))

