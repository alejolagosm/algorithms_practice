% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm099.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, float, char, math.

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ Y).

:- func calcY(float, float, float) = float.
calcY(DistX, N_Vel, N_Ang) = R :-
(
  Ang_Rad = N_Ang * math.pi / 180.0,
  Num_1 = tan(Ang_Rad) * DistX,
  Const_1 = 2.0 * N_Vel * N_Vel * cos(Ang_Rad) * cos(Ang_Rad),
  Const_2 = 9.81 / Const_1,
  Num_2 = Const_2 * DistX * DistX,
  R = Num_1 - Num_2
).

:- func calcHitD(int, list(int), int, int) = int.
calcHitD(DistX, SlopeL, N_Vel, N_Ang) = R :-
(
  Num_Y = calcY(float(DistX + 1), float(N_Vel), float(N_Ang)),
  Idx_Dist = DistX div 4,
  det_index0(SlopeL, Idx_Dist) = Const_N,
  WallHeight = float(Const_N * 4),
  (if Num_Y =< WallHeight
  then
    R = DistX
  else
    R = calcHitD(DistX + 1, SlopeL, N_Vel, N_Ang)
  )
).

:- pred doIter(list(string), list(int), string, string).
:- mode doIter(in, in, in, out) is det.
doIter([], _, FullStr, FullStr).
doIter([X | Tail], SlopeL, PartStr, FullStr) :-
(
  words_separator(char.is_whitespace, X) = InputList,
  map(det_to_int, InputList) = InitArr,
  (if length(InitArr) = 2
  then
    det_index1(InitArr, 1) = N_Vel,
    det_index1(InitArr, 2) = N_Angle,
    ResN = calcHitD(2, SlopeL, N_Vel, N_Angle),
    PartStr1 = PartStr ++ " " ++ string(ResN),
    doIter(Tail, SlopeL, PartStr1, FullStr)
  else
    SlopeL1 = InitArr,
    doIter(Tail, SlopeL1, PartStr, FullStr)
  )
).

main(!IO) :-
  io.stdin_stream(Stdin, !IO),
  read_lines(Stdin, [], !IO).

:- pred read_lines(io.text_input_stream::in,
                   list(string)::in,io::di,io::uo) is det.
read_lines(InFile, FileContents, !IO) :-
  io.read_line_as_string(InFile, Result, !IO),
  (
    Result = ok(Line),
    FileContents1 = FileContents ++ [Line],
    read_lines(InFile, FileContents1, !IO)
  ;
    Result = eof,
    det_index1(FileContents, 1) = St_List,
    words_separator(char.is_whitespace, St_List) = IptList,
    map(det_to_int, IptList) = SlopeL,
    list.det_drop(1, FileContents, ListStr),
    doIter(ListStr, SlopeL, "", Res),
    io.format("%s", [s(Res)], !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA099.lst | ./falagosm099
% 84 84 52 60 90 110 80 60 36
