;; lfec -L falagosm.lfe

(defun print (var_a)
  (io:format "~p " (list var_a)))

(defun get_bmi (num_w num_h)
  (/ num_w (* num_h num_h)))

(defun get_cla (num_bmi)
  (if (=< num_bmi 18.5)
    "under"
    (if (=< num_bmi 25)
      "normal"
      (if (=< num_bmi 30)
        "over"
        "obese"))))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun get_float (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_float str)))

(defun do_iter (qty idx)
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:substr str_1 1 ( - (string:len str_1) 1)))
      (data (string:tokens str_2 " "))
      (num_w (get_int data 1))
      (num_h (get_float data 2))
      (num_bmi (get_bmi num_w num_h))
      (res_cal (get_cla num_bmi)))
    (print res_cal)
    (if (> qty idx)
      (do_iter qty (+ idx 1)))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (qty (get_int (string:tokens str_1 "\n") 1)))
    (do_iter qty 1)))

(main)

;; cat DATA.lst | lfe falagosm028.lfe
;; 
