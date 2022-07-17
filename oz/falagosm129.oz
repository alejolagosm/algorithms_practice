% ozc -c falagosm.oz

functor
import
  Application System Open

define
  local
    Letters_1 = ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N"]
    Letters_2 = ["O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"]
    Prev_1 = {List.append {List.number 0 9 1} Letters_1}
    Pos_Comb = {List.append Prev_1 Letters_2}
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Qty_Iter = {String.toInt {Data getS($)}}

    fun {Get_Numbcomb Qt_N Qt_K}
      if Qt_K == 0.0
      then 1.0
      else Qt_N * {Get_Numbcomb Qt_N - 1.0 Qt_K - 1.0}  / Qt_K
      end
    end

    proc {Get_Position I_List Qty_N Qty_K Qty_I V_Change St_V End_V Var_J}
      local
        V_Pnt
        V_Int
        V_Int2
        V_Int3
        V_Int4
        E_V2
      in
        if Qty_I < End_V
        then
          V_Pnt = {Nth I_List Var_J + V_Change + 1}
          {System.printInfo V_Pnt}
          V_Int = Qty_N - Var_J - 1
          V_Int2 = Qty_K - 1
          V_Int3 = Qty_I - St_V
          V_Int4 = Var_J + V_Change + 1
          {Get_Comb I_List V_Int V_Int2 V_Int3 V_Int4}
        else
          V_Int = End_V
          V_Int2 = (V_Int - St_V) * (Qty_N - Var_J - Qty_K)
          V_Int3 = Qty_N - Var_J - 1
          V_Int4 = {Int.'div' V_Int2 V_Int3}
          E_V2 = V_Int + V_Int4
          {Get_Position I_List Qty_N Qty_K Qty_I V_Change V_Int E_V2 Var_J + 1}
        end
      end
    end

    proc {Get_Comb Ipt_List Qty_N Qty_K Qty_I V_Change}
      local
        Num_Float = {Get_Numbcomb {Int.toFloat Qty_N} {Int.toFloat Qty_K}}
        Num_Comb = {Float.toInt Num_Float}
        Var_Pnt
      in
        if Qty_K > 1
        then
          local
            St_V = 0
            End_V = {Int.'div' Num_Comb * Qty_K Qty_N}
            Var_J = 0
          in
            {Get_Position Ipt_List Qty_N Qty_K Qty_I V_Change St_V End_V Var_J}
          end
        else
          Var_Pnt = {Nth Ipt_List Qty_I + V_Change + 1}
          {System.printInfo Var_Pnt}
        end
      end
    end

    fun {Get_Params Data}
      local
        Const_A = {String.tokens {Data getS($)} & }
        Const_B = {Map Const_A String.toInt}
      in
        Const_B
      end
    end

    proc {Do_iter Data Ipt_List Qty_Iter Idx}
      local
        Params = {Get_Params Data}
        Qty_N = {Nth Params 1}
        Qty_K = {Nth Params 2}
        Qty_I = {Nth Params 3}
        Pos_List = {List.take Ipt_List Qty_N}
      in
        {Get_Comb Pos_List Qty_N Qty_K Qty_I 0}
        {System.printInfo " "}
        if Idx < Qty_Iter
        then {Do_iter Data Ipt_List Qty_Iter Idx + 1}
        end
      end
    end

  in
    {Do_iter Data Pos_Comb Qty_Iter 1}
    {Application.exit 0}
  end
end

%% cat DATA.lst | ozengine falagosm.ozf
%% 23789ABCDFGJQTU 12346789ACEGIJNOPQS F 24589BCFHKPRTV 4ACEFIMN
%% 14569BCEHKNPW 3489B 2347ACDEFGMPRU 1235CEFGHJKOPTU 245678BEJOQTUV
%% 234678AHIMOPVWX 37CDGIJMNS 9BJ 012346789ABCDEFGHIKLMNOP 379CDEHJKT 
%% 4FHIJORS 0236789ABCDEFGIJKLNPQRVWX 3567AEHINOQVX
