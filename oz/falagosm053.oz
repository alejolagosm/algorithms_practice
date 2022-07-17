% ozc -c falagosm.oz

functor
import
  Application System Open

define
  local
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Qty = {String.toInt {Data getS($)}}

    fun {CanReach Ipt_A Ipt_B}
      local Row_A Row_B Col_A Col_B in
        Row_A = {Nth Ipt_A 1}
        Row_B = {Nth Ipt_B 1}
        Col_A = {Nth Ipt_A 2}
        Col_B = {Nth Ipt_B 2}
        if Row_A == Row_B then 1
        elseif Col_A == Col_B then 1
        elseif {Number.abs Col_A-Col_B}=={Number.abs Row_A-Row_B} then 1
        else 0
        end
      end
    end

    fun {GetPosition List}
      local Const_A Res in
        Const_A = {String.tokens {List getS($)} & }
        Res ={CanReach {Nth Const_A 1} {Nth Const_A 2}}
        Res
      end
    end

    proc {Outpn List Idx Qty}
      local
        Res = {GetPosition List}
      in
        if Res== 1
        then {System.printInfo "Y"}
        else {System.printInfo "N"}
        end
        {System.printInfo " "}
        if Idx < Qty
        then {Outpn List Idx+1 Qty}
        end
      end
    end

  in
    {Outpn Data 1 Qty}
    {Application.exit 0}
  end
end

%% cat DATA.lst | ozengine falagosm.ozf
%% N Y N Y N N N N Y N Y Y N N N Y Y Y N N Y N Y N N Y N N N
