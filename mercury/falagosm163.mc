% $ mmc -f falagosm.mc
% $ mmc --make falagosm163

:- module falagosm163.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, float, char, math.

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ " " ++ Y).

:- func isCollision(list(float), list(float)) = int.
isCollision(PN_B1, PN_B2) = R :-
(
  det_index0(PN_B1, 0) = PN_X1,
  det_index0(PN_B1, 1) = PN_Y1,
  det_index0(PN_B2, 0) = PN_X2,
  det_index0(PN_B2, 1) = PN_Y2,
  Num_DX = PN_X1 - PN_X2,
  Num_DY = PN_Y1 - PN_Y2,
  Num_D = math.sqrt(Num_DX * Num_DX  + Num_DY * Num_DY),
  (if Num_D =< 40.0
  then R = 1
  else
    R = 0
  )
).

:- func calcCollision(list(float), list(float)) = list(list(float)).
calcCollision(PN_B1, PN_B2) = R :-
(
  det_index0(PN_B1, 0) = PN_X1,
  det_index0(PN_B1, 1) = PN_Y1,
  det_index0(PN_B2, 0) = PN_X2,
  det_index0(PN_B2, 1) = PN_Y2,
  Num_DX = PN_X1 - PN_X2,
  Num_DY = PN_Y1 - PN_Y2,
  Num_D = sqrt(Num_DX * Num_DX  + Num_DY * Num_DY),
  det_index0(PN_B1, 2) = VN_X1,
  det_index0(PN_B1, 3) = VN_Y1,
  det_index0(PN_B2, 2) = VN_X2,
  det_index0(PN_B2, 3) = VN_Y2,
  Num_VXC = (VN_X1 + VN_X2) / 2.0,
  Num_VYC = (VN_Y1 + VN_Y2) / 2.0,
  Num_UX = VN_X1 - Num_VXC,
  Num_UY = VN_Y1 - Num_VYC,
  Num_UR = (Num_UX * Num_DX  + Num_UY * Num_DY) / Num_D,
  Num_UXR = (Num_UR * Num_DX) / Num_D,
  Num_UYR = (Num_UR * Num_DY) / Num_D,
  VNew_X1 = VN_X1 - 2.0 * Num_UXR,
  VNew_Y1 = VN_Y1 - 2.0 * Num_UYR,
  VNew_X2 = VN_X2 + 2.0 * Num_UXR,
  VNew_Y2 = VN_Y2 + 2.0 * Num_UYR,
  ListB1 = [PN_X1, PN_Y1, VNew_X1, VNew_Y1],
  ListB2 = [PN_X2, PN_Y2, VNew_X2, VNew_Y2],
  R = [ListB1, ListB2]
).

:- func moveBall(float, float, float, float) = list(float).
moveBall(Pos_X, Pos_Y, Vel_X, Vel_Y) = R :-
(
  D_Time = 0.001,
  Ball_R = 20.0,
  Height_T = 300.0,
  Width_T = 600.0,
  Pos_TempX = Pos_X + Vel_X * D_Time,
  (if Pos_TempX >= Width_T - Ball_R
  then
    PosN_X = Pos_X + (2.0 * (Ball_R - (Width_T - Pos_X))) - (Vel_X * D_Time),
    VelN_X = Vel_X * -1.0
  else if Pos_TempX =< Ball_R
  then
    PosN_X = Pos_X + (2.0 * (Ball_R - Pos_X)) - (Vel_X * D_Time),
    VelN_X = Vel_X * -1.0
  else
    PosN_X = Pos_TempX,
    VelN_X = Vel_X
  ),
  Pos_TempY = Pos_Y + Vel_Y * D_Time,
  (if Pos_TempY >= Height_T - Ball_R
  then
    PosN_Y = Pos_Y + (2.0 * (Ball_R - (Height_T - Pos_Y))) - (Vel_Y * D_Time),
    VelN_Y = Vel_Y * -1.0
  else if Pos_TempY =< Ball_R
  then
    PosN_Y = Pos_Y + (2.0 * (Ball_R - Pos_Y)) - (Vel_Y * D_Time),
    VelN_Y = Vel_Y * -1.0
  else
    PosN_Y = Pos_TempY,
    VelN_Y = Vel_Y
  ),
  Tot_Vel = sqrt(Vel_X * Vel_X  + Vel_Y * Vel_Y),
  New_Vel = Tot_Vel - 5.0 * D_Time,
  (if Tot_Vel = 0.0
  then N_Factor = 0.0
  else N_Factor = New_Vel / Tot_Vel),
  VelN1_X = N_Factor * VelN_X,
  VelN1_Y = N_Factor * VelN_Y,
  R = [PosN_X, PosN_Y, VelN1_X, VelN1_Y]
).

:- func calcPos(float, float, float, float,
                  float, float, float, float, float) = list(int).
calcPos(Pos_X1, Pos_Y1, Vel_X1, Vel_Y1,
        Pos_X2, Pos_Y2, Vel_X2, Vel_Y2, Var_time) = R :-
(
  PN_B1 = moveBall(Pos_X1, Pos_Y1, Vel_X1, Vel_Y1),
  PN_B2 = moveBall(Pos_X2, Pos_Y2, Vel_X2, Vel_Y2),
  EvalCol = isCollision(PN_B1, PN_B2),
  (if EvalCol = 1
  then
    ResultsCol = calcCollision(PN_B1, PN_B2),
    det_index1(ResultsCol, 1, List_B1),
    det_index1(ResultsCol, 2, List_B2)
  else
    List_B1 = PN_B1,
    List_B2 = PN_B2
  ),
  det_index1(List_B1, 1, PN_X1),
  det_index1(List_B1, 2, PN_Y1),
  det_index1(List_B1, 3, VN_X1),
  det_index1(List_B1, 4, VN_Y1),
  det_index1(List_B2, 1, PN_X2),
  det_index1(List_B2, 2, PN_Y2),
  det_index1(List_B2, 3, VN_X2),
  det_index1(List_B2, 4, VN_Y2),
  (if Var_time + 0.1 >= 10.0
  then R = [round_to_int(PN_X1), round_to_int(PN_Y1),
            round_to_int(PN_X2), round_to_int(PN_Y2)]
  else
    R = calcPos(PN_X1, PN_Y1, VN_X1, VN_Y1,
                PN_X2, PN_Y2, VN_X2, VN_Y2, Var_time + 0.001)
  )
).

:- pred getPositions(list(string), string, string).
:- mode getPositions(in, in, out) is det.
getPositions([], FinalAns, strip(FinalAns)).
getPositions([X | Tail], PartialAns, FinalAns) :-
(
  words_separator(char.is_whitespace, X) = InputList,
  map(det_to_float, InputList) = NumList,
  det_index0(NumList, 0, Pos_X1),
  det_index0(NumList, 1, Pos_Y1),
  det_index0(NumList, 2, Pos_X2),
  det_index0(NumList, 3, Pos_Y2),
  det_index0(NumList, 4, Vel_X1),
  det_index0(NumList, 5, Vel_Y1),
  det_index0(NumList, 6, Vel_X2),
  det_index0(NumList, 7, Vel_Y2),
  ResList = calcPos(Pos_X1, Pos_Y1, Vel_X1, Vel_Y1,
                  Pos_X2, Pos_Y2, Vel_X2, Vel_Y2, 0.0),
  map(int_to_string, ResList, StrList),
  foldr(unwords, StrList, "", FinalStr),
  PartialAns1 = PartialAns ++ " " ++ FinalStr,
  getPositions(Tail, PartialAns1, FinalAns)
).

main(!IO) :-
  io.stdin_stream(Stdin, !IO),
  read_lines(Stdin, [], !IO).

:- pred read_lines(io.text_input_stream::in,
  list(string)::in, io::di, io::uo) is det.

read_lines(InFile, FileContents, !IO) :-
  io.read_line_as_string(InFile, Result, !IO),
  (
    Result = ok(Line),
    FileContents1 = FileContents ++ [Line],
    read_lines(InFile, FileContents1, !IO)
  ;
    Result = eof,
    det_drop(1, FileContents, IptList),
    getPositions(IptList, "", Res),
    io.print_line(Res, !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA.lst | ./falagosm163
% 413 96 101 54  424 264 268 160  22 135 424 99  571 252 93 122
