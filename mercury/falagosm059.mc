% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm059.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- func todecimal(int) = int.
todecimal(X) = X - 48.

:- func getClues(list(int), int, list(int), int, int) = string.
getClues([], _, _, Hint, Hit) = int_to_string(Hit) ++ "-"
                                  ++ int_to_string(Hint).
getClues([X | Tail], Idx, InitList, Hint, Hit) = R :-
(
  (if member(X, InitList)
  then
    det_index1_of_first_occurrence(InitList, X) = Index,
    (if Index = Idx
    then
      Hit1 = Hit + 1,
      Hint1 = Hint
    else
      Hit1 = Hit,
      Hint1 = Hint + 1
    )
  else
    Hit1 = Hit,
    Hint1 = Hint
  ),
  R = getClues(Tail, Idx + 1, InitList, Hint1, Hit1)
).

:- pred doIter(list(string), list(int), string, string).
:- mode doIter(in, in, in, out) is det.
doIter([], _, FullStr, FullStr).
doIter([X | Tail], CorrectList, PartStr, FullStr) :-
(
  to_char_list(X, ChList),
  map(to_int, ChList) = IntList,
  map(todecimal, IntList) = IptIntL,
  HintStr = getClues(IptIntL, 1, CorrectList, 0, 0),
  (if length(PartStr) = 0
  then
    PartStr1 = HintStr
  else
    PartStr1 = PartStr ++ " " ++ HintStr),
  doIter(Tail, CorrectList, PartStr1, FullStr)
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
    det_index1(FileContents, 1) = Ipt_Data,
    words_separator(char.is_whitespace, Ipt_Data) = StrIpt_List,
    det_index1(StrIpt_List, 1) = Const_L1,
    to_char_list(Const_L1, ChList1),
    map(to_int, ChList1) = IntList,
    map(todecimal, IntList) = CorrectList,
    det_index1(FileContents, 2) = Ipt_Guesses,
    words_separator(char.is_whitespace, Ipt_Guesses) = StrIpt_Data,
    doIter(StrIpt_Data, CorrectList, "", Res),
    io.print_line(strip(Res), !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA.lst | ./falagosm
% 0-3 1-0 0-3 1-1 1-0 0-3 0-2 1-0 2-1 0-2 0-2 0-2
