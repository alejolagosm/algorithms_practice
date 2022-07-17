% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm156.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- func todecimal(int) = int.
todecimal(X) = X - 48.

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ Y).

:- func calcLuhn(list(int), int, int) = int.
calcLuhn([], _, PartRes) = PartRes.
calcLuhn([X | Tail], Idx, PartRes) = R :-
(
  Res = Idx rem 2,
  (if Res = 0
  then
    Var_N1 = X * 2,
    (if Var_N1 >= 10
    then Var_N2 = Var_N1 - 9
    else Var_N2 = Var_N1),
    PartRes1 = PartRes + Var_N2
  else
    PartRes1 = PartRes + X
  ),
  R = calcLuhn(Tail, Idx + 1, PartRes1)
).

:- pred getStartList(list(char), list(int), list(int)).
:- mode getStartList(in, in, out) is det.
getStartList([], FullList, FullList).
getStartList([X | Tail], PartList, FullList) :-
(
  (if X = '?'
  then Const_N1 = -1
  else
    to_int(X) = Const_N,
    Const_N1 = Const_N - 48),
  (if length(PartList) = 0
  then PartList1 = [Const_N1]
  else PartList1 = PartList ++ [Const_N1]),
  getStartList(Tail, PartList1, FullList)
).

:- pred getNewList(list(int), int, int, int, int, list(int), list(int)).
:- mode getNewList(in, in, in, in, in, in, out) is det.
getNewList([], _, _, _, _, FullList, FullList).
getNewList([X | Tail], IdxC, IdxS, NumbS1, NumbS2, PartList, FullList) :-
(
  (if IdxC = IdxS
  then Const_N1 = NumbS2
  else if IdxC = IdxS + 1
  then Const_N1 = NumbS1
  else Const_N1 = X),
  (if length(PartList) = 0
  then PartList1 = [Const_N1]
  else PartList1 = PartList ++ [Const_N1]),
  getNewList(Tail, IdxC + 1, IdxS, NumbS1, NumbS2, PartList1, FullList)
).

:- pred getNewList2(list(int), int, int, list(int), list(int)).
:- mode getNewList2(in, in, in, in, out) is det.
getNewList2([], _, _, FullList, FullList).
getNewList2([X | Tail], IdxC, IdxS, PartList, FullList) :-
(
  (if IdxC = IdxS
  then Const_N1 = X + 1
  else Const_N1 = X),
  (if length(PartList) = 0
  then PartList1 = [Const_N1]
  else PartList1 = PartList ++ [Const_N1]),
  getNewList2(Tail, IdxC + 1, IdxS, PartList1, FullList)
).

:- func getCorrectArray(list(int), int) = list(int).
getCorrectArray(IptIntL, Idx) = R :-
(
  det_index1(IptIntL, Idx) = NumS1,
  det_index1(IptIntL, Idx + 1) = NumS2,
  getNewList(IptIntL, 1, Idx, NumS1, NumS2, [], PossibleList),
  reverse(PossibleList, TestList),
  Luhn = calcLuhn(TestList, 1, 0),
  Res = Luhn rem 10,
  (if Res = 0
  then R = PossibleList
  else R = getCorrectArray(IptIntL, Idx + 1))
).

:- func getCorrectNumber(list(int), int) = list(int).
getCorrectNumber(IptIntL, Idx) = R :-
(
  getNewList2(IptIntL, 1, Idx, [], PossibleList),
  reverse(PossibleList, TestList),
  Luhn = calcLuhn(TestList, 1, 0),
  Res = Luhn rem 10,
  (if Res = 0
  then R = PossibleList
  else R = getCorrectNumber(PossibleList, Idx))
).

:- pred doIter(list(string), string, string).
:- mode doIter(in, in, out) is det.
doIter([], FullStr, FullStr).
doIter([X | Tail], PartStr, FullStr) :-
(
  to_char_list(X, ChList),
  delete_elems(ChList, ['\n'], ChList2),
  (if member('?', ChList2)
  then
    getStartList(ChList2, [], IptIntL),
    det_index1_of_first_occurrence(ChList2, '?') = Idx,
    ResList = getCorrectNumber(IptIntL, Idx)
  else
    map(to_int, ChList2) = IntList,
    map(todecimal, IntList) = IptIntL,
    ResList = getCorrectArray(IptIntL, 1)),
  map(int_to_string, ResList, StrResList),
  foldr(unwords, StrResList, "", FinalStr),
  %trace [io(!IO)] (io.print_line(FinalStr, !IO)),
  (if length(PartStr) = 0
  then
    PartStr1 = FinalStr
  else
    PartStr1 = PartStr ++ " " ++ FinalStr),
  doIter(Tail, PartStr1, FullStr)
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
    list.det_drop(1, FileContents, ListStr),
    doIter(ListStr, "", Res),
    io.format("%s", [s(Res)], !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA.lst | ./falagosm
/*
3979657248496042 7647223959187362 8067011659981807 2459572485662886
1100897851084869 1445751644869652 5343839279572701 6468185641133534
2429008050561861 5692950171671827 9837628370117036 8411998760659889
2115009129209325 6301444365952491 2017302152625247 2143663823332654
8485571705934369 9829033539406802 2662366940323173 7169694373875899
5409977872449850 1350940844875014 9998550025190058 7606670178544717
9594597611821735 8093031265673844 2261847412380804 6042229468616992
1857648589974508 7414829637888642 1094375319463700 5724773338609882
9558521436072732 1568083652128701 5062000569484748 3415485042751830
1221791427357400 1859810065380281 1404469166891363 5629348619978698
1643344961453662 5955372884748887 2478873782920218 9143899220184034
3023244332303461 2692359266949097 7027609641907615 9442441575558534
*/
