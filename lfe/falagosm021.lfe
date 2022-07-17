;; lfec -L falagosm.lfe

(defun print (array qty idx)
  (io:format "~p " (list (array:get idx array)))
  (if (> (- qty 1) idx)
    (print count_list qty (+ idx 1))))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun do_iter (ipt_list count_list qty idx num_amount)
  (let*
    ((num_a (get_int ipt_list idx))
     (num_b (+ (array:get (- num_a 1) count_list) 1))
     (count_list (array:set (- num_a 1) num_b count_list)))
    (if (> qty idx)
      (do_iter ipt_list count_list qty (+ idx 1) num_amount)
      (print count_list num_amount 0))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:tokens str_1 "\n"))
      (params (string:split str_2 " " 'all))
      (qty (get_int params 1))
      (num_amount (get_int params 2))
      (str_3 (io:get_line ""))
      (str_4 (string:tokens str_3 "\n"))
      (numbers (string:split str_4 " " 'all))
      (count_list (array:new num_amount #(default 0))))
    (do_iter numbers count_list qty 1 num_amount)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;; 32 39 36 30 35 36 40 34 37
