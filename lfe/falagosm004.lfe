;; lfec -L falagosm.lfe

(defun print (min max)
  (io:format "~p ~p" (list max min)))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun iterator (qty data index min max)
  (let*
    ((num (get_int data index))
      (calc_min (if (< num min) num min))
      (calc_max (if (> num max) num max)))
    (if (> qty index)
      (iterator qty data (+ index 1) calc_min calc_max)
      (print calc_min calc_max))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (str_2 (string:substr str_1 1 (- (string:len str_1) 1)))
      (data (string:tokens str_2 " "))
      (first (get_int data 1)))
    (iterator 300 data 1 first first)))

(main)

;; cat DATA.lst | lfe falagosm.lfe
;; 79734 -79769
;; (lfe_io:print (array:get 0 count_list))

;; Print array recursive function
;;(defun print_arr (array qty idx)
 ;; (io:format "~p " (list (array:get idx array)))
  ;;(if (> (- qty 1) idx)
   ;; (print_arr array qty (+ idx 1))))