% ozc -c falagosm.oz

functor
import
  Application System Open

define
  local
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Int_Arr = {String.tokens {List getS($)} & }
    Ipt_Arr = {Map Int_Arr String.toInt}
    Qty = {List.length Ipt_Arr}
    In_Max = {Nth Ipt_Arr 1}

    fun {Get_Max List In_Max Qty Idx}
      local C_Max Const_B in
        if Idx == Qty
        then In_Max
        else 
          Const_B = {Nth List Idx + 1}
          C_Max = {Value.max In_Max Const_B} 
          if Idx < Qty - 1
          then {Get_Max List C_Max Qty Idx + 1}
          else C_Max
          end
        end
      end
    end

  in
    Num_Max = {Get_Max Ipt_Arr In_Max Qty 1}
    {System.printInfo Num_Max}
    {Application.exit 0}
  end
end

%% cat DATA.lst | ozengine falagosm.ozf
%% 
