;; lfec -L falagosm.lfe

(defun print (num_a)
  (io:format "~.1f " (list num_a)))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun calc_area (num_s num_d1 num_d2 num_d3)
  (let* 
    ((n_int1 (- num_s num_d1))
      (n_int2 (- num_s num_d2))
      (n_int3 (- num_s num_d3))
      (n_int4 (* num_s (* n_int1 (* n_int2 n_int3))))
      (res_area (math:sqrt n_int4)))
    (print res_area)))

(defun calc_d (num_x1 num_y1 num_x2 num_y2)
  (let* 
    ((n_int1 (- num_x2 num_x1))
      (n_int2 (- num_y2 num_y1))
      (n_int3 (* n_int1 n_int1))
      (n_int4 (* n_int2 n_int2))
      (n_int5 (+ n_int3 n_int4)))
    (math:sqrt n_int5)))

(defun calc_params (data)
  (let* 
    ((num_x1 (get_int data 1))
      (num_y1 (get_int data 2))
      (num_x2 (get_int data 3))
      (num_y2 (get_int data 4))
      (num_x3 (get_int data 5))
      (num_y3 (get_int data 6))
      (num_d1 (calc_d num_x1 num_y1 num_x2 num_y2))
      (num_d2 (calc_d num_x1 num_y1 num_x3 num_y3))
      (num_d3 (calc_d num_x2 num_y2 num_x3 num_y3))
      (num_s (/ (+ (+ num_d1 num_d2) num_d3) 2)))
    (calc_area num_s num_d1 num_d2 num_d3)))

(defun do_iter (qty idx)
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:substr str_1 1 ( - (string:len str_1) 1)))
      (data (string:tokens str_2 " ")))
    (calc_params data)
    (if (> qty idx)
      (do_iter qty (+ idx 1)))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (qty (get_int (string:tokens str_1 "\n") 1)))
    (do_iter qty 1)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;;
