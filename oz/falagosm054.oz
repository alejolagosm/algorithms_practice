% ozc -c falagosm.oz

functor
import
  Application System Open

define
  local
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Qty = {String.toInt {Data getS($)}}

    fun {GetRes Ipt_N Ipt_A}
      local 
        Const_A = Ipt_A + 1.0
        Const_B = Ipt_N * Ipt_N - 2.0 * Ipt_N * Ipt_A + 2.0 * Ipt_A * Ipt_A
        Const_C = 2.0 * (Ipt_N - Ipt_A)
      in
        if Const_A >= Ipt_N / 3.0
        then 0
        elseif {Int.'mod' {Float.toInt Const_B} {Float.toInt Const_C}} == 0 
        then {Float.toInt (Const_B / Const_C) * (Const_B / Const_C)}
        else {GetRes Ipt_N Const_A}
        end
      end
    end

    proc {Outpn List Idx Qty}
      local
        Const_N = {String.toFloat {Data getS($)}}
        Const_A = 2.0
        Res 
      in
        Res = {GetRes Const_N Const_A}
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
%% 40903660986409 49987855303681 46145949472561 28578700269025
%% 54497364066289 37827580070569 37807950499489
