% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm027.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred str2integer(string::in, int::out) is det.
str2integer(X, string.det_to_int(X)).

:- pred calcValues(list(int), int, int, int, int, list(int), list(int)).
:- mode calcValues(in, in, in, in, in, in, out) is det.
calcValues([], _, _, _, _, FullAns, FullAns).
calcValues([X | Tail], NPass, NSwapsR, NSwapsTotal, Prev, PartAns, FullAns) :-
(
  (if Prev = 0 then N_1 = X else N_1 = Prev),
  (if length(Tail) >= 1
    then det_index1(Tail, 1) = N_2
    else N_2 = X),
  (if N_1 =< N_2
  then
    N_3 = N_1,
    NSwaps1 = NSwapsR,
    Prev1 = 0
  else if length(Tail) >= 1
  then
    N_3 = N_2,
    NSwaps1 = NSwapsR + 1,
    Prev1 = N_1
  else
    N_3 = N_1,
    NSwaps1 = NSwapsR,
    Prev1 = 0
  ),
  (if length(PartAns) = 0
  then PartAns1 = [N_3]
  else PartAns1 = PartAns ++ [N_3]),
  (if length(Tail) >= 1
  then
    calcValues(Tail, NPass, NSwaps1, NSwapsTotal, Prev1, PartAns1, FullAns)
  else if length(Tail) = 0, NSwapsR = 0
  then
    NPass1 = NPass + 1,
    PartAns2 = [NPass1] ++ [NSwapsTotal],
    calcValues([], NPass1, NSwaps1, NSwapsTotal, Prev1, PartAns2, FullAns)
  else
    NPass1 = NPass + 1,
    NSwapsTotal1 = NSwapsTotal + NSwaps1,
    calcValues(PartAns1, NPass1, 0, NSwapsTotal1, 0, [], FullAns)
  )
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
    calcValues(InitArr, 0, 0, 0, 0, [], ResultsArr),
    det_index1(ResultsArr, 1) = NPass,
    io.format("%i ", [i(NPass)], !IO),
    det_index1(ResultsArr, 2) = NSwaps,
    io.format("%i ", [i(NSwaps)], !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% cat DATA.lst | ./falagosm
% 14 85
