;; lfec -L falagosm.lfe

(defun print (num_a)
  (io:format "~.7f " (list num_a)))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun calc_dot (num_a num_b num_c num_d)
  (+ (* num_a num_c) (* num_b num_d)))

(defun calc_lng (num_c num_d)
  (+ (* num_c num_c) (* num_d num_d)))

(defun calc_xy (num_1 num_2 num_p num_a)
  (if (< num_p 0) num_1
    (if (> num_p 1) num_2
      (+ num_1 (* num_p num_a)))))

(defun calc_dist (data)
  (let*
    ((num_x1 (get_int data 1))
      (num_y1 (get_int data 2))
      (num_x2 (get_int data 3))
      (num_y2 (get_int data 4))
      (num_x3 (get_int data 5))
      (num_y3 (get_int data 6))
      (num_a (- num_x3 num_x1))
      (num_b (- num_y3 num_y1))
      (num_c (- num_x2 num_x1))
      (num_d (- num_y2 num_y1))
      (num_dot (calc_dot num_a num_b num_c num_d))
      (num_lng (calc_lng num_c num_d))
      (num_param (/ num_dot num_lng))
      (num_xx (calc_xy num_x1 num_x2 num_param num_c))
      (num_yy (calc_xy num_y1 num_y2 num_param num_d))
      (num_dx (- num_x3 num_xx))
      (num_dy (- num_y3 num_yy)))
    (math:sqrt (+ (* num_dx num_dx) (* num_dy num_dy)))))

(defun do_iter (qty idx)
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:substr str_1 1 ( - (string:len str_1) 1)))
      (data (string:tokens str_2 " "))
      (dist (calc_dist data)))
    (print dist)
    (if (> qty idx)
      (do_iter qty (+ idx 1)))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (qty (get_int (string:tokens str_1 "\n") 1)))
    (do_iter qty 1)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;; 6.7082039 9.7081811 5.3851648 5.0000000 12.8062485
;; 3.1622777 0.5144958 11.4159936 17.0000000 5.5286561
;; 7.2801099 1.0000000 1.4142136 10.6066017 9.2195445
;; 4.4721360 6.0000000 9.5408434 17.0327099
