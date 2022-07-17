/*
  $ mmc -f falagosm009.mc
  $ mmc --make falagosm009
*/

:- module falagosm009.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred isTriang(int::in, int::in, int::in, int::out) is det.
isTriang(Num1, Num2, Num3, Res) :-
(
  if Num3 =< Num2 + Num1, Num2 =< Num3 + Num1, Num1 =< Num2 + Num3
  then Res = 1
  else Res = 0
).

:- pred getTriang(list(string), string, string).
:- mode getTriang(in, in, out) is det.
getTriang([], FinalAns, strip(FinalAns)).
getTriang([Line | Tail], PartialAns, FinalAns) :-
(
  words_separator(char.is_whitespace, Line) = InputList,
  map(det_to_int, InputList) = NumList,
  det_index0(NumList, 0, Num1),
  det_index0(NumList, 1, Num2),
  det_index0(NumList, 2, Num3),
  isTriang(Num1, Num2, Num3, Res),
  PartialAns1 = PartialAns ++ " " ++ from_int(Res),
  getTriang(Tail, PartialAns1, FinalAns)
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
    getTriang(IptList, "", Res),
    io.print_line(Res, !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

/*
  $ cat DATA.lst | ./falagosm009
  1 0 1 0 0 0 0 1 0 1 1 1 1 0 0 1 1 1 0 1 0
*/
