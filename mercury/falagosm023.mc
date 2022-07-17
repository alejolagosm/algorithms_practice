% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm023.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, integer, int, char.

:- pred str2integer(string::in, int::out) is det.
str2integer(X, string.det_to_int(X)).

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ " " ++ Y).

:- pred genBArr(int, int, list(int), list(int), list(int)).
:- mode genBArr(in, in, in, in, out) is det.
genBArr(_,_,[], FullList, FullList).
genBArr(Prev, Count, [X | Tail], PartialList, FullList) :-
(
  if det_index1(Tail, 1) = -1
  then
    (if Prev < X then N_1 = X else N_1 = Prev),
    genBArr(Prev, Count, [], PartialList ++ [N_1] ++ [Count], FullList)
  else
    (if Prev = 0 then N_1 = X else N_1 = Prev),
    (if length(Tail) >= 1
      then det_index1(Tail, 1) = N_2
      else N_2 = X),
    (if N_1 < N_2 then N_3 = N_1 else N_3 = N_2),
    (if N_1 < N_2 then Count2 = Count else Count2 = Count + 1),
    (if N_1 < N_2 then Prev2 = 0 else Prev2 = N_1),
    genBArr(Prev2, Count2, Tail, PartialList ++ [N_3], FullList)
).

:- func getValues(list(int), int) = int.
getValues([], PartSum) = PartSum.
getValues([X | Xs], PartSum) = R :-
  if length(Xs) < 1
  then
    R = getValues([],PartSum)
  else
    N_1 = (X + PartSum) * 113,
    N_2 = N_1 rem 10000007,
    R = getValues(Xs, N_2).

main(!IO) :-
  io.read_line_as_string(Entry, !IO),
  ( if
    Entry = ok(String)
  then
    StrValues = string.words(String),
    map(str2integer, StrValues, IntValues),
    genBArr(0, 0, IntValues,[],ResList),
    det_index1(ResList, length(ResList)) = Count,
    ResCSum = getValues(ResList, 0),
    %map(int_to_string, ResList, StrList),
    %foldr(unwords, StrList, "", FinalStr),
    %io.print_line(strip(FinalStr), !IO),
    io.format("%i ", [i(Count)], !IO),
    io.format("%i ", [i(ResCSum)], !IO)
  else
    true).

% cat DATA.lst | ./falagosm
% 35 8834818
