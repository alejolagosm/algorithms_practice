% $ mmc -f falagosm.mc
% $ mmc --make falagosm

:- module falagosm028.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, float, char.

:- func calcBMI(float, float) = string.
calcBMI(N_Height, N_Weight) = R :-
(
  N_Bmi = N_Weight / (N_Height * N_Height),
  (if N_Bmi =< 18.5
  then
    R = "under"
  else if N_Bmi =< 25.0
  then
    R = "normal"
  else if N_Bmi =< 30.0
  then
    R = "over"
  else
    R = "obese"
  )
).

:- pred calcRes(list(string), string, string).
:- mode calcRes(in, in, out) is det.
calcRes([], FinalAns, strip(FinalAns)).
calcRes([Line | Tail], PartialAns, FinalAns) :-
(
  words_separator(char.is_whitespace, Line) = InputList,
  map(det_to_float, InputList) = NumList,
  det_index0(NumList, 0, N_Weight),
  det_index0(NumList, 1, N_Height),
  Res = calcBMI(N_Height, N_Weight),
  PartialAns1 = PartialAns ++ " " ++ Res,
  calcRes(Tail, PartialAns1, FinalAns)
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
    calcRes(IptList, "", Res),
    io.print_line(Res, !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA.lst | ./falagosm
% over under over under obese obese over under under obese under
% under obese obese over under obese under obese over over under
% normal normal obese normal normal
