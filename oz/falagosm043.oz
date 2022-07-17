% ozc -c falagosm.oz

functor
import
  Application System Open

define
  local
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Qty = {String.toInt {Data getS($)}}

    fun {GetRand List}
      local Const_A Const_B in
        Const_A = {List getS($)}
        Const_B = {String.toFloat Const_A}*6.0+1.0
        {Float.toInt {Float.floor Const_B}}
      end
    end

    proc {Outpn List Idx Qty}
      local
        Res = {GetRand List}
      in
        {System.print Res}
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

%% cat DATA043.lst | ozengine falagosm.ozf
%% 4 3 1 1 3 5 1 5 4 3 1 6 1 4 5 6 6 6 5 1 5 3 3 5 6 1 4 5 4 2
