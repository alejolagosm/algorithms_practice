% ozc -c falagosm078.oz

functor
import
  Application System Open

define
  local
    Data = {New class $ from Open.file Open.text end init(name:stdin)}
    Params = {Map {String.tokens {Data getS($)} & } String.toInt}
    N_points = {Nth Params 1}
    Alpha = 1.0 / ({Int.toFloat {Nth Params 2}} - 1.0)
    Points = {List.make N_points}

    proc {GetPointsList Ipt_List Points Idx Qty}
      local Data in
        Data = {Map {String.tokens {Ipt_List getS($)} & } String.toFloat}
        {Nth Points Idx} = Data
        if Idx < Qty
        then {GetPointsList Ipt_List Points Idx+1 Qty}
        end
      end
    end

    fun {CalcPoint Ipt_P1 Ipt_P2 Dist}
      local
        Point_X1 = {Nth Ipt_P1 1}
        Point_X2 = {Nth Ipt_P2 1}
        Point_Y1 = {Nth Ipt_P1 2}
        Point_Y2 = {Nth Ipt_P2 2}
        X3 = Point_X1 * ( 1.0 - Dist) + Dist * Point_X2
        Y3 = Point_Y1 * ( 1.0 - Dist) + Dist * Point_Y2
        Res = {List.make 2}
      in
        {Nth Res 1} = X3
        {Nth Res 2} = Y3
        Res
      end
    end

    proc {GetNewPoints Ipt_List Out_List Qty Idx Dist}
      local Ipt_P1 Ipt_P2 in
        Ipt_P1 = {Nth Ipt_List Idx}
        Ipt_P2 = {Nth Ipt_List Idx + 1}
        {Nth Out_List Idx} = {CalcPoint Ipt_P1 Ipt_P2 Dist}  
        if Idx+1 < Qty
        then {GetNewPoints Ipt_List Out_List Qty Idx + 1 Dist}
        end
      end
    end

    fun {GetCoord Ipt_List Alpha}
      local
        Qty = {List.length Ipt_List}
        Out_List = {List.make Qty-1}
      in
        {GetNewPoints Ipt_List Out_List Qty 1 Alpha}
        if {List.length Out_List} == 1
        then Out_List
        else {GetCoord Out_List Alpha}
        end
      end
    end

    proc {GetBezier Ipt_List Alpha Idx}
      local
        N_points = (1.0 / Alpha) + 1.0
        Res_List
        Res_Points
      in
        if Idx < N_points + 1.0
        then Res_List = {GetCoord Ipt_List Idx * Alpha}
        end
        Res_Points = {Nth Res_List 1}
        {System.print {Float.toInt {Nth Res_Points 1}}}
        {System.printInfo " "}
        {System.print {Float.toInt {Nth Res_Points 2}}}
        {System.printInfo " "}
        if Idx < N_points - 1.0
        then {GetBezier Ipt_List Alpha Idx + 1.0}
        end
      end
    end

  in
    {GetPointsList Data Points 1 N_points}
    {GetBezier Points Alpha 0.0}
    {Application.exit 0}
  end
end

%% cat DATA.lst | ozengine falagosm078.ozf
%% 494 492 458 504 429 515 407 525 391 534 382 542 377 548
%% 377 554 382 559 390 564 402 567 417 570 434 573 452 574
%% 473 575 494 576 515 575 537 574 558 573 577 570 596 567
%% 612 562 625 556 636 549 643 541 646 532 644 520 638 507
%% 626 492 607 475 583 455 551 433
