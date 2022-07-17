;; lfec -L falagosm.lfe

(defun print (num_a)
  (io:format "~p \n" (list num_a)))

(defun print_arr (array qty idx)
  (io:format "~p " (list (array:get idx array)))
  (if (> (- qty 1) idx)
    (print_arr array qty (+ idx 1))))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun get_float (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_float str)))

(defun does_stop (num_xd num_x num_v)
  (if (and (>= num_xd 100) (=< (abs (- num_xd num_x)) 0.1) (=< (abs num_v) 0.1))
    1
    0))

(defun get_speed (speeds num_xd)
  (if (< num_xd 20)
    (array:get 0 speeds)
    (if (< num_xd 40)
      (array:get 1 speeds)
      (if (< num_xd 60)
        (array:get 2 speeds)
        (if (< num_xd 80)
          (array:get 3 speeds)
          (if (< num_xd 100)
            (array:get 4 speeds)
            0))))))

(defun get_time (speeds num_x num_v num_t num_xd)
  (let*
    ((f_spring (* 0.5 (- num_xd num_x)))
      (f_friction (* -0.5 num_v))
      (f_total (+ f_spring f_friction))
      (accel (/ f_total 5))
      (new_x (+ num_x (* num_v 0.2)))
      (new_v (+ num_v (* accel 0.2)))
      (new_t (+ num_t 0.2))
      (new_xd (+ num_xd (* (get_speed speeds num_xd) 0.2)))
      (not_stopped (does_stop new_xd new_x new_v)))
    (if (=:= not_stopped 0)
      (get_time speeds new_x new_v new_t new_xd)
      new_t)))

(defun get_sign (str)
  (if (== str "+") 1 -1))

(defun is_valid (speeds sp_idx sp_change)
  (let*
    ((new_sp (+ (array:get sp_idx speeds) sp_change))
      (first_sp (if (=:= sp_idx 0) new_sp (array:get 0 speeds)))
      (prev_idx (max (- sp_idx 1) 0))
      (next_idx (min (+ sp_idx 1) 4))
      (prev_sp (array:get prev_idx speeds))
      (next_sp (array:get next_idx speeds))
      (dif_pr (abs (- new_sp prev_sp)))
      (dif_n (abs (- new_sp next_sp))))
    (if (and (=< first_sp 3) (>= new_sp 0) (=< dif_pr 3) (=< dif_n 3))
      1
      0)))

(defun get_newsp (speeds sp_idx sp_change)
  (let ((new_sp (+ (array:get sp_idx speeds) sp_change)))
    (array:set sp_idx new_sp speeds)))

(defun print_res (speeds time)
 (print_arr speeds 5 0)
 (print time))

(defun do_iter (speeds time idx qty)
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:substr str_1 1 ( - (string:len str_1) 1)))
      (data (string:tokens str_2 " "))
      (sp_idx (get_int data 1))
      (sp_int (lists:nth 2 data))
      (sp_sign (get_sign (string:substr sp_int 1 1)))
      (str_3 (string:substr sp_int 2 (string:len str_1)))
      (sp_num (if (== (string:len str_3) 1)
                  (list_to_integer str_3)
                  (list_to_float str_3)))
      (sp_change (* sp_sign sp_num))
      (can_change (is_valid speeds sp_idx sp_change))
      (new_speeds (if (== can_change 1)
                    (get_newsp speeds sp_idx sp_change)
                    speeds))
      (new_time (get_time new_speeds 0 0 0 0))
      (next_time (min new_time time))
      (next_speeds (if (and (< new_time time) (/= can_change 0))
                        new_speeds
                        speeds)))
    (if (> qty idx)
      (do_iter next_speeds next_time (+ idx 1) qty)
      (print_res next_speeds next_time))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (qty (get_int (string:tokens str_1 "\n") 1))
      (str_2 (io:get_line ""))
      (str_3 (string:tokens str_2 "\n"))
      (speeds (array:from_list (lists:map
                (lambda (X) (list_to_integer X))
                (string:split str_3 " " 'all))))
      (time (get_time speeds 0 0 0 0)))
    (do_iter speeds time 1 qty)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;; 2 3 2.0 3.4 1.7000000000000002 49.80000000000017
