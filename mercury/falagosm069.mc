% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm069.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred str2integer(string::in, int::out) is det.
str2integer(X, string.det_to_int(X)).

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ " " ++ Y).

:- func calcFibIdx(int, int, int, int) = int.
calcFibIdx(Divisor, Count, FibPrev, FibNext) = R :-
(
  Const_Div = FibPrev + FibNext,
  Const_Mod = Const_Div mod Divisor,
  (if Const_Mod = 0
  then R = Count
  else
    R = calcFibIdx(Divisor, Count + 1, FibNext, Const_Mod)
  )
).

:- pred getFibIdx(list(int), list(int), list(int)).
:- mode getFibIdx(in, in, out) is det.
getFibIdx([], FullAns, FullAns).
getFibIdx([X | Tail], PartAns, FullAns) :-
(
  Idx_X = calcFibIdx(X, 2, 0, 1),
  (if length(PartAns) = 0
  then PartAns1 = [Idx_X]
  else PartAns1 = PartAns ++ [Idx_X]),
  getFibIdx(Tail, PartAns1, FullAns)
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
    det_index1(FileContents, 2) = RootList,
    words_separator(char.is_whitespace, RootList) = InputList,
    map(det_to_int, InputList) = InitArr,
    getFibIdx(InitArr, [], ResList),
    map(int_to_string, ResList, StrList),
    foldr(unwords, StrList, "", FinalStr),
    io.print_line(strip(FinalStr), !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% cat DATA.lst | ./falagosm
% 1176 900 900 54 100 3300 840 96 1246 396
% 1592 2064 270 2100 264 3040 552 300 1000
