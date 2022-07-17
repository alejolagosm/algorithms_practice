% ozc -c falagosm.oz

functor
import
  Application System Open

define
  local
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Qty_Iter = {String.toInt {Data getS($)}}

    fun {Calc_F List_X List_Coef Qty Idx Res}
      local
        L_Int1
        L_Int2
        C_Int3
        F_Res
        New_Res
      in
        L_Int1 = {Nth List_Coef Idx}
        L_Int2 = {List.zip List_X L_Int1 Number.'*'}
        C_Int3 = {Nth {Nth List_Coef Qty + 1} Idx}
        F_Res = {FoldR L_Int2 fun {$ X Y} X + Y end 0.0} - C_Int3
        New_Res = Res + F_Res * F_Res
        if Idx < Qty
        then {Calc_F List_X List_Coef Qty Idx + 1 New_Res}
        else New_Res
        end
      end
    end

    fun {Do_Map Ipt_L Idx D_X}
      {List.mapInd Ipt_L fun {$ I X} if I == Idx then X + D_X else X end end}
    end

    proc {Calc_Grad List_G List_X List_Coef Res_F D_X Qty Idx}
      local
        Res_F_Idx
        New_L_X = {Do_Map List_X Idx D_X}
      in
        Res_F_Idx = {Calc_F New_L_X List_Coef Qty 1 0.0}
        {Nth List_G Idx} = (Res_F_Idx - Res_F) / D_X
        if Idx < Qty
        then {Calc_Grad List_G List_X List_Coef Res_F D_X Qty Idx + 1}
        end
      end
    end

    fun {Calc_Iter List_Coef List_X Qty Step Iter_N}
      local
        Res_Iter = Iter_N + 1
        D_X = Step / 10.0
        Res_F
        List_G = {List.make Qty}
        List_Gmod
        List_Xnew = {List.make Qty}
        Res_Fnew
        New_Step
        List_Xnext
      in
        Res_F = {Calc_F List_X List_Coef Qty 1 0.0}
        if Res_F < 0.0001
        then Res_Iter - 1
        else
          {Calc_Grad List_G List_X List_Coef Res_F D_X Qty 1}
          List_Gmod = {List.map List_G fun {$ X} X * Step end}
          List_Xnew = {List.zip List_X List_Gmod Number.'-'}
          Res_Fnew = {Calc_F List_Xnew List_Coef Qty 1 0.0}
          if Res_Fnew < Res_F
          then
            List_Xnext = List_Xnew
            New_Step = {Value.min 0.1 Step * 1.25}
          else
            New_Step = Step / 1.25
            List_Xnext = List_X
          end
          {Calc_Iter List_Coef List_Xnext Qty New_Step Res_Iter}
        end
      end
    end

    proc {Get_Coef Data Coef_List Qty Idx}
      local
        Const_A = {String.tokens {Data getS($)} & }
        Const_B = {Map Const_A String.toFloat}
      in
        {Nth Coef_List Idx} = Const_B
        if Idx < Qty
        then {Get_Coef Data Coef_List Qty Idx + 1}
        end
      end
    end

    proc {Do_iter Data Qty_Iter Idx}
      local
        Coef_N = {String.toInt {Data getS($)}}
        List_A = {List.make Coef_N + 1}
        List_X = {List.map {List.make Coef_N} fun {$ A} 0.0 end}
        Step_N = 0.01
        Iter
      in
        {Get_Coef Data List_A Coef_N + 1 1}
        Iter = {Calc_Iter List_A List_X Coef_N Step_N 0}
        {System.printInfo Iter}
        {System.printInfo " "}
        if Idx < Qty_Iter
        then {Do_iter Data Qty_Iter Idx + 1}
        end
      end
    end

  in
    {Do_iter Data Qty_Iter 1}
    {Application.exit 0}
  end
end

%% cat DATA.lst | ozengine falagosm.ozf
%% 224 84 159 162
