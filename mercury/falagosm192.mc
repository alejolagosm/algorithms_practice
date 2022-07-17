% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm192.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred str2integer(string::in, int::out) is det.
str2integer(X, string.det_to_int(X)).

:- pred getSumComb(list(int), list(int), int, int).
:- mode getSumComb(in, in, in, out) is det.
getSumComb(_, [], ResInt, ResInt).
getSumComb(Gang_Arms, [X | Tail], PartRes, ResInt) :-
(
  det_index1(Gang_Arms, X) = Const_N1,
  PartRes2 = PartRes + Const_N1,
  getSumComb(Gang_Arms, Tail, PartRes2, ResInt)
).

:- func getLengthMember(list(list(int)), list(int), list(int),
 int, int) = int.
getLengthMember([], _, _, _, _) = 0.
getLengthMember([X | Tail], Gang_P, Gang_Grd, C_Pis, C_Grd) = R :-
(
  getSumComb(Gang_P, X, 0, Sum_P),
  getSumComb(Gang_Grd, X, 0, Sum_Grd),
  (if Sum_P = C_Pis, Sum_Grd = C_Grd
  then R = length(X)
  else R = getLengthMember(Tail, Gang_P, Gang_Grd, C_Pis, C_Grd))
).

:- func generateList(int, int, list(int)) = list(int).
generateList(Idx, Limit, PartList) = R :-
(
  if length(PartList) = Limit
  then R = PartList
  else
    (if length(PartList) = 0
    then PartList1 = [Idx]
    else append(PartList, [Idx], PartList1)),
    R = generateList(Idx + 1, Limit, PartList1)
).

:- pred joinList(list(list(int)), list(int), list(list(int)), list(list(int))).
:- mode joinList(in, in, in, out) is det.
joinList([], _, TotalList, TotalList).
joinList([X | Tail], LJoin, PartList, TotalList) :-
(
  Const_A = [LJoin ++ X],
  (if length(det_index1(PartList, 1)) = 0
  then PartList1 = Const_A
  else PartList1 = PartList ++ Const_A),
  joinList(Tail, LJoin, PartList1, TotalList)
).

:- pred filterList(list(list(int)), int, list(list(int)), list(list(int))).
:- mode filterList(in, in, in, out) is det.
filterList([], _, TotalList, TotalList).
filterList([X | Tail], Limit, PartList, TotalList) :-
(
  (if length(X) = Limit
  then PartList1 = PartList ++ [X]
  else PartList1 = PartList),
  filterList(Tail, Limit, PartList1, TotalList)
).

:- pred getComb(list(int), int, list(list(int)),list(list(int))).
:- mode getComb(in, in, in, out) is det.
getComb([], _, TotalList, TotalList).
getComb([X | Tail], CombN, PartList, TotalList) :-
(
  (if CombN = 1
  then
    det_index1(PartList, 1) = Const_A,
    (if length(Const_A) = 0
    then PartList2 = [[X]]
    else PartList2 = PartList ++ [[X]])
  else
    getComb(Tail, CombN - 1, [[]], PartListT),
    Const_A = [X],
    joinList(PartListT, Const_A, [[]], TotalListX),
    PartList2 = PartList ++ TotalListX
  ),
  (if length(Tail) < CombN
  then
    getComb([], CombN, PartList2, TotalList)
  else
    getComb(Tail, CombN, PartList2, TotalList)
  )
).

:- func getGangMember(int, int, list(int), list(int), int) = int.
getGangMember(C_Pis, C_Grd, Gang_P, Gang_Grd, LngSubGang) = R :-
(
  PosibleList = generateList(1, length(Gang_P), []),
  getComb(PosibleList, LngSubGang, [[]], CombListX),
  filterList(CombListX, LngSubGang, [[]], ListTest),
  PartRes = getLengthMember(ListTest, Gang_P, Gang_Grd, C_Pis, C_Grd),
  (if PartRes = 0, LngSubGang > 1
  then R = getGangMember(C_Pis, C_Grd, Gang_P, Gang_Grd, LngSubGang - 1)
  else R = PartRes
  )
).

:- pred getGangters(int, int, list(int),
   list(int), list(string), string, string).
:- mode getGangters(in, in, in, in, in, in, out) is det.
getGangters(_, _, _, _, [], ResultStr, ResultStr).
getGangters(C_Pis, C_Grd, Gang_P, Gang_Grd, [X | Tail], PartStr, ResultStr) :-
(
  words_separator(char.is_whitespace, X) = StrList,
  (if length(StrList) = 1
  then
    ResN = getGangMember(C_Pis, C_Grd, Gang_P, Gang_Grd, length(Gang_P)),
    PartStr2 = PartStr ++ " " ++ string(ResN),
    getGangters(C_Pis, C_Grd, [], [], Tail, PartStr2, ResultStr)
  else if length(Tail) = 0
  then
    det_index1(StrList, 1) = Const_N1,
    det_index1(StrList, 2) = Const_N2,
    append(Gang_P, [string.det_to_int(Const_N1)], Gang_P2),
    append(Gang_Grd, [string.det_to_int(Const_N2)], Gang_Grd2),
    ResN = getGangMember(C_Pis, C_Grd, Gang_P2, Gang_Grd2, length(Gang_P2)),
    PartStr2 = PartStr ++ " " ++ string(ResN),
    getGangters(C_Pis, C_Grd, [], [], [], PartStr2, ResultStr)
  else
    det_index1(StrList, 1) = Const_N1,
    det_index1(StrList, 2) = Const_N2,
    append(Gang_P, [string.det_to_int(Const_N1)], Gang_P2),
    append(Gang_Grd, [string.det_to_int(Const_N2)], Gang_Grd2),
    getGangters(C_Pis, C_Grd, Gang_P2, Gang_Grd2, Tail, PartStr, ResultStr))
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
    det_index1(FileContents, 1) = Ipt_Data,
    words_separator(char.is_whitespace, Ipt_Data) = StrIpt_Data,
    det_index1(StrIpt_Data, 2) = Const_N1,
    C_Pis = string.det_to_int(Const_N1),
    det_index1(StrIpt_Data, 3) = Const_N2,
    C_Grd = string.det_to_int(Const_N2),
    det_drop(1, FileContents, GangList),
    det_drop(1, GangList, GangList2),
    getGangters(C_Pis, C_Grd, [], [], GangList2, "", ResultStr),
    io.print_line(strip(ResultStr), !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% cat DATA.lst | ./falagosm
% 6 6 6 6 7 8 12 8 10 11 10 9
