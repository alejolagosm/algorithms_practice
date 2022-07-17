% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm029.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ " " ++ Y).

:- pred getIdx(list(int), list(int), list(int), list(int)).
:- mode getIdx(in, in, in, out) is det.
getIdx([], _, ResultList, ResultList).
getIdx([X | Tail], InitArr, PartAns, ResultList) :-
(
  det_index1_of_first_occurrence(InitArr, X) = Index,
  (if length(PartAns) = 0
  then PartAns1 = [Index]
  else PartAns1 = PartAns ++ [Index]),
  getIdx(Tail, InitArr, PartAns1, ResultList)
).

:- pred sortArr(list(int), int, int, int, int, list(int), list(int)).
:- mode sortArr(in, in, in, in, in, in, out) is det.
sortArr([], _, _, _, _, FullAns, FullAns).
sortArr([X | Tail], NPass, NSwapsR, NSwapsTotal, Prev, PartAns, FullAns) :-
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
    sortArr(Tail, NPass, NSwaps1, NSwapsTotal, Prev1, PartAns1, FullAns)
  else if length(Tail) = 0, NSwapsR = 0
  then
    NPass1 = NPass + 1,
    sortArr([], NPass1, NSwaps1, NSwapsTotal, Prev1, PartAns1, FullAns)
  else
    NPass1 = NPass + 1,
    NSwapsTotal1 = NSwapsTotal + NSwaps1,
    sortArr(PartAns1, NPass1, 0, NSwapsTotal1, 0, [], FullAns)
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
    sortArr(InitArr, 0, 0, 0, 0, [], ResultsArr),
    getIdx(ResultsArr, InitArr, [], FinalRes),
    map(int_to_string, FinalRes, StrIndexList),
    foldr(unwords, StrIndexList, "", FinalStr),
    io.print_line(strip(FinalStr), !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% cat DATA.lst | ./falagosm
% 20 3 16 17 9 5 6 10 19 13 18 14 2 11 1 22 7 8 15 21 4 23 12
