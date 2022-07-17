;; lfec -L falagosm.lfe

(defun print (num_a)
  (io:format "~p " (list num_a)))

(defun div_num (num_a num_b)
  (/ num_a num_b))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun do_iter (qty idx)
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:substr str_1 1 ( - (string:len str_1) 1)))
      (data (string:tokens str_2 " "))
      (num_a (get_int data 1))
      (num_b (get_int data 2))
      (res_f (/ num_a num_b))
      (res (round res_f)))
    (print res)
    (if (> qty idx)
      (do_iter qty (+ idx 1)))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (qty (get_int (string:tokens str_1 "\n") 1)))
    (do_iter qty 1)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;; 2 6 7 3 15 20 -1 2 -12 12 14 15 -3 14 21 13637 10310 1 7
;; 5377 7 12 5 16 11 24 0 3 -1
