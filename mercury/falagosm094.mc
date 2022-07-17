% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm094.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred str2integer(string::in, int::out) is det.
str2integer(X, string.det_to_int(X)).

:- pred getSumSq(list(int), int, int).
:- mode getSumSq(in, in, out) is det.
getSumSq([], FullSum, FullSum).
getSumSq([X | Tail], PartSum, FullSum) :-
(
  PartSum1 = PartSum + (X * X),
  getSumSq(Tail, PartSum1, FullSum)
).

:- pred getSquares(list(string), string, string).
:- mode getSquares(in, in, out) is det.
getSquares([], FinalStr, FinalStr).
getSquares([Line | Tail], PartialStr, FinalStr) :-
(
  words_separator(char.is_whitespace, Line) = StrList,
  map(str2integer, StrList, IntegerList),
  getSumSq(IntegerList, 0, ResSq),
  PartialStr1 = PartialStr ++ from_int(ResSq) ++ " ",
  getSquares(Tail, PartialStr1, FinalStr)
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
    det_drop(1, FileContents, RootList),
    getSquares(RootList, "", ResultStr),
    io.print_line(strip(ResultStr), !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% cat DATA.lst | ./falagosm
% 65 1147 302 473 759 189 174 1129 97 1741 1062 2064 17 949 1962 285 531
