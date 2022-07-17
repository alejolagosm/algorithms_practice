;; lfec -L falagosm.lfe

(defun print (num_a)
  (io:format "~p " (list num_a)))

(defun conv_cel (num_a)
  (/ (* (- num_a 32) 5) 9))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun do_iter (ipt_list qty idx)
  (let*
    ((num_a (get_int ipt_list idx))
      (res_f (conv_cel num_a))
      (res (round res_f)))
    (print res)
    (if (> qty idx)
      (do_iter ipt_list qty (+ idx 1)))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:tokens str_1 "\n"))
      (numbers (string:split str_2 " " 'all))
      (qty (get_int numbers 1)))
    (do_iter numbers (+ qty 1) 2)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;; 121 68 27 86 29 59 190 285 271 260 43 288 174 166 184
;; 244 301 199 21 256 216 258 303 36 79 308 164 167 274
;; 82 41 291 51 255
