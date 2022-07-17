% $ mmc -f falagosm.mc
% $ mmc --make falagosm

:- module falagosm133.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, float, char, math.

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ " " ++ Y).

:- func moveBall(float, float, float, float,
                  float, float, float, float) = list(float).
moveBall(Pos_X, Pos_Y, Vel_X, Vel_Y, Const_Des,
           Ball_R, Table_W, Table_H) = R :-
(
  D_Time = 0.001,
  Height_T = Table_H,
  Width_T = Table_W,
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
  Tot_Vel = math.sqrt(Vel_X * Vel_X  + Vel_Y * Vel_Y),
  New_Vel = Tot_Vel - Const_Des * D_Time,
  (if Tot_Vel = 0.0
  then N_Factor = 0.0
  else N_Factor = New_Vel / Tot_Vel),
  VelN1_X = N_Factor * VelN_X,
  VelN1_Y = N_Factor * VelN_Y,
  R = [PosN_X, PosN_Y, VelN1_X, VelN1_Y]
).

:- func calcPos(float, float, float, float,
                  float, float, float, float, float) = list(int).
calcPos(Pos_X1, Pos_Y1, Vel_X1, Vel_Y1, Const_Des,
        Ball_R, Table_W, Table_H, Var_time) = R :-
(
  List_B1 = moveBall(Pos_X1, Pos_Y1, Vel_X1, Vel_Y1,
                  Const_Des, Ball_R, Table_W, Table_H),
  det_index1(List_B1, 1, PN_X1),
  det_index1(List_B1, 2, PN_Y1),
  det_index1(List_B1, 3, VN_X1),
  det_index1(List_B1, 4, VN_Y1),
  Tot_Vel = math.sqrt(VN_X1 * VN_X1  + VN_Y1 * VN_Y1),
  (if Tot_Vel =< 0.01
  then R = [round_to_int(PN_X1), round_to_int(PN_Y1)]
  else
    R = calcPos(PN_X1, PN_Y1, VN_X1, VN_Y1, Const_Des,
                Ball_R, Table_W, Table_H, Var_time + 0.001)
  )
).

:- func getPositions(string) = string.
getPositions(Params) = R :-
(
  words_separator(char.is_whitespace, Params) = InputList,
  map(det_to_float, InputList) = NumList,
  det_index0(NumList, 0, Table_W),
  det_index0(NumList, 1, Table_H),
  det_index0(NumList, 2, Pos_X1),
  det_index0(NumList, 3, Pos_Y1),
  det_index0(NumList, 4, Ball_R),
  det_index0(NumList, 5, Vel_X1),
  det_index0(NumList, 6, Vel_Y1),
  det_index0(NumList, 7, Const_Des),
  ResList = calcPos(Pos_X1, Pos_Y1, Vel_X1, Vel_Y1, Const_Des,
                    Ball_R, Table_W, Table_H, 0.0),
  map(int_to_string, ResList, StrList),
  foldr(unwords, StrList, "", FinalStr),
  R = FinalStr
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
    det_index1(FileContents, 1, IptList),
    Res = getPositions(IptList),
    io.print_line(Res, !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA.lst | ./falagosm
% 136 176
% 286 139 -> This would need to change the DATA.lst in the repo
