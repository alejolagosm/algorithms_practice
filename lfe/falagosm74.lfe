;; lfec -L falagosm.lfe

(defun print (num_a)
  (io:format "~p " (list num_a)))

(defun print_c (x_1 y_1)
  (io:format "~.7f ~.7f " (list x_1 y_1)))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun get_str (lst ind)
  (let ((str (lists:nth ind lst)))
    str))

(defun get_chour (hour minute lng)
  (let*
    ((min_extra (* minute 0.5))
      (ang (* (rem hour 12) (/ 360 12)))
      (ang_rad (* (+ ang min_extra) (/ (* (math:pi) 2) 360)))
      (y_lng (+ (* (math:cos ang_rad) lng) 10))
      (x_lng (+ (* (math:sin ang_rad) lng) 10)))
    (print_c x_lng y_lng)))

(defun get_cmin (minute lng)
  (let*
    ((ang (* minute (/ 360 60)))
      (ang_rad (* ang (/ (* (math:pi) 2) 360)))
      (y_lng (+ (* (math:cos ang_rad) lng) 10))
      (x_lng (+ (* (math:sin ang_rad) lng) 10)))
    (print_c x_lng y_lng)))

(defun get_time (hours idx)
  (let*
    ((str (get_str hours idx))
      (str_int (string:tokens str ":"))
      (hour (get_int str_int 1))
      (minute (get_int str_int 2)))
    (get_chour hour minute 6)
    (get_cmin minute 9)))

(defun do_iter (hours idx qty)
  (let*
    ((coords (get_time hours idx)))
    (if (> qty idx)
      (do_iter hours (+ idx 1) qty))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (qty (get_int (string:tokens str_1 "\n") 1))
      (str_2 (io:get_line ""))
      (str_3 (string:tokens str_2 "\n"))
      (hours (string:split str_3 " " 'all)))
    (do_iter hours 1 qty)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;; 10.0523592 15.9997715 10.9407562 18.9506971 8.3461759 4.2324298
;; 8.1287948 1.1966716 8.9581109 15.9088465 2.2057714 5.5000000 
;; 14.9742254 13.3551574 3.3116966 16.0221755 7.5595801 15.4812727
;; 18.5595086 12.7811529 11.2474701 15.8688856 15.2900673 2.7188471
;; 10.6792193 15.9614311 18.8033284 11.8712052
