% ozc -c falagosm.oz

functor
import
  Application System Open

define
  local
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Qty = {String.toInt {Data getS($)}}

    fun {SumTwo List}
      local Const_A Const_B in
        Const_A = {String.tokens {List getS($)} & }
        Const_B = {Map Const_A String.toInt}
        {Nth Const_B 1} + {Nth Const_B 2}
      end
    end

    proc {Outpn List Idx Qty}
      local
        Res = {SumTwo List}
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

%% cat DATA.lst | ozengine falagosm.ozf
%% 1255380 827825 918005 1353876 1476727 1054852 894646 1451614
%% 910166 715465 1537956 480616 756535 1275361
