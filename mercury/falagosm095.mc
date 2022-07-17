% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm095.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, float, int, char.

:- pred str2integer(string::in, int::out) is det.
str2integer(X, string.det_to_int(X)).

:- pred getSum(list(string), int, float, float).
:- mode getSum(in, in, in, out) is det.
getSum([], _, FullSum, FullSum).
getSum([X | Tail], Idx, PartSum, FullSum) :-
(
  words_separator(char.is_whitespace, X) = StrList,
  det_index1(StrList, Idx) = Const_N,
  Num_N = string.det_to_float(Const_N),
  PartSum1 = PartSum + Num_N,
  getSum(Tail, Idx, PartSum1, FullSum)
).

:- pred getSq(list(string), int, int, float, float).
:- mode getSq(in, in, in, in, out) is det.
getSq([], _, _, FullSum, FullSum).
getSq([X | Tail], Idx1, Idx2, PartSum, FullSum) :-
(
  words_separator(char.is_whitespace, X) = StrList,
  det_index1(StrList, Idx1) = Const_N1,
  det_index1(StrList, Idx2) = Const_N2,
  Num_N1 = string.det_to_float(Const_N1),
  Num_N2 = string.det_to_float(Const_N2),
  PartSum1 = PartSum + (Num_N1 * Num_N2),
  getSq(Tail, Idx1, Idx2, PartSum1, FullSum)
).

:- func getCoefB(float, float, float, float, float) = float.
getCoefB(Num_N, Num_X, Num_Y, Num_XX, Num_XY) = R :-
  Var_Int1 = (Num_N * Num_XY) - (Num_X * Num_Y),
  Var_Int2 = (Num_N * Num_XX) - (Num_X * Num_X),
  R = Var_Int1 / Var_Int2.

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
    getSum(RootList, 2, 0.0, Num_X),
    getSum(RootList, 3, 0.0, Num_Y),
    getSq(RootList, 2, 2, 0.0, Num_XX),
    getSq(RootList, 2, 3, 0.0, Num_XY),
    Num_N = float(length(RootList)),
    Avg_X = Num_X / Num_N,
    Avg_Y = Num_Y / Num_N,
    Coef_B = getCoefB(Num_N, Num_X, Num_Y, Num_XX, Num_XY),
    Coef_A = Avg_Y - (Avg_X * Coef_B),
    ResultStr = string(Coef_B) ++ " " ++ string(Coef_A),
    io.print_line(strip(ResultStr), !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% cat DATA.lst | ./falagosm
% 1.6097618194945296 119.26159064054218
