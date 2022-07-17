%% ozc -c falagosm.oz

functor
import
  System Open

define
  local Data X_const Y_const Z_const Qty Input K_const Last in
    Data={New Open.file init(name:stdin flags:[read])}
    {Data read(list:X_const size:all)}
    {String.token X_const &\n Y_const Z_const}
    Qty = {String.toInt Y_const}
    Input = {String.tokens Z_const & }
    K_const = {String.tokens {List.nth Input Qty} &\n}
    Last = {String.toInt {List.nth K_const 1}}

    fun {Solve IptList Idx}
      local
        B_sum = {String.toInt {List.nth IptList Idx}}
        J_const = Idx-1
      in
        if J_const == 0
        then B_sum
        else B_sum + {Solve IptList J_const}
        end
      end
    end

    {System.show Last+{Solve Input Qty-1}}
  end
end

%% cat DATA.lst | ozengine falagosm.ozf
%% 27455