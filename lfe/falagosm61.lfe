;; lfec -L falagosm61.lfe

(defun print (num_a)
  (io:format "~p " (list num_a)))

(defun get_int (lst ind)
  (let ((str (lists:nth ind lst)))
    (list_to_integer str)))

(defun remove_mult (sieve_arr idx n_lim step)
  (let ((sieve_arrnew (array:set idx 1 sieve_arr)))
    (if (< (+ idx step) (+ n_lim 1))
      (remove_mult sieve_arrnew (+ idx step) n_lim step)
      sieve_arrnew)))

(defun can_remove (sieve_arr idx n_lim)
  (let ((is_prime (array:get idx sieve_arr)))
    (if (< (* idx idx) n_lim)
      (if (=:= is_prime 0)
        (remove_mult sieve_arr (round (* idx idx)) n_lim idx)
        sieve_arr)
      sieve_arr)))

(defun is_prime (sieve_arr idx qty n_lim)
  (let ((sieve_arrnew (can_remove sieve_arr idx n_lim)))
    (if (< idx (+ qty 1))
      (is_prime sieve_arrnew (+ idx 1) qty n_lim)
      sieve_arrnew)))

(defun calc_primes (n_lim)
  (let*
    ((sieve_arr (array:new (+ n_lim 1) #(default 0)))
      (sieve_arr (array:set 0 1 sieve_arr))
      (sieve_arr (array:set 1 1 sieve_arr))
      (qty (round (+ (math:sqrt n_lim) 1)))
      (sieve_arr2 (is_prime sieve_arr 2 qty n_lim)))
    sieve_arr2))

(defun should_add (primes_arr is_prm idx)
    (if (=:= is_prm 0)
      (array:set (array:size primes_arr) idx primes_arr)
      primes_arr))

(defun do_primes (primes_arr sieve_arr idx qty)
  (let*
    ((is_prm (array:get idx sieve_arr))
      (primes_arrnew (should_add primes_arr is_prm idx)))
    (if (< idx qty)
      (do_primes primes_arrnew sieve_arr (+ idx 1) qty)
      primes_arrnew)))

(defun get_prime (primes_arr idx)
  (array:get idx primes_arr))

(defun do_iter (numbers primes_arr idx qty)
  (let*
    ((idx_search (get_int numbers idx))
      (res (get_prime primes_arr (- idx_search 1))))
    (print res)
    (if (> qty idx)
      (do_iter numbers primes_arr (+ idx 1) qty))))

(defun main ()
  (let*
    ((str_1 (io:get_line ""))
      (qty (get_int (string:tokens str_1 "\n") 1))
      (str_2 (io:get_line ""))
      (str_3 (string:tokens str_2 "\n"))
      (numbers (string:split str_3 " " 'all))
      (limit 3000000)
      (sieve_arr (calc_primes limit))
      (init_arr (array:new))
      (primes_arr (do_primes init_arr sieve_arr 2 limit)))
    (do_iter numbers primes_arr 1 qty)))

(main)

;; cat DATA.lst | lfe falagosm61.lfe
;;
