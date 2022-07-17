% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm072.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- func genSequence(int, int, int, int, list(int)) = list(int).
genSequence(Idx, Limit, N_Seed, Num_Xcur, PartAns) = R :-
(
  Num_A = 445,
  Num_C = 700001,
  Num_M = 2097152,
  Num_Next = (Num_A * Num_Xcur + Num_C) rem Num_M,
  (if length(PartAns) = 0
  then PartAns1 = [Num_Next]
  else PartAns1 = PartAns ++ [Num_Next]),
  (if Idx = Limit
  then
    R = PartAns1
  else
    R = genSequence(Idx + 1, Limit, N_Seed, Num_Next, PartAns1)
  )
).

:- func getWord(list(int), int, list(char), list(char), string) = string.
getWord([], _,  _, _, PartAns) = PartAns.
getWord([X | Tail], Idx, VowelL, ConsonL, PartAns) = R :-
(
  Num_Choose = Idx rem 2,
  (if Num_Choose = 0
  then
    Idx_Vowel = X rem 5,
    det_index0(VowelL, Idx_Vowel) = Next_Char
  else
    Idx_Conson = X rem 19,
    det_index0(ConsonL, Idx_Conson) = Next_Char
  ),
  char_to_string(Next_Char, NextStr),
  PartAns1 = PartAns ++ NextStr,
  R = getWord(Tail, Idx + 1, VowelL, ConsonL, PartAns1)
).

:- pred doIter(list(int), list(char), list(char), int, string, string).
:- mode doIter(in, in, in, in, in, out) is det.
doIter([], _, _, _, FullStr, FullStr).
doIter([X | Tail], VowelL, ConsonL, N_Seed, PartStr, FullStr) :-
(
  ListSeq = genSequence(1, X, N_Seed, N_Seed, []),
  RandWord = getWord(ListSeq, 1, VowelL, ConsonL, ""),
  (if length(PartStr) = 0
  then PartStr1 = RandWord
  else PartStr1 = PartStr ++ " " ++ RandWord),
  det_index1(ListSeq, length(ListSeq)) = Next_Seed,
  doIter(Tail, VowelL, ConsonL, Next_Seed, PartStr1, FullStr)
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
    VowelL = ['a','e','i','o','u'],
    Chars1 = ['b','c','d','f','g','h','j','k','l','m'],
    Chars2 = ['n','p','r','s','t','v','w','x','z'],
    ConsonL = Chars1 ++ Chars2,
    det_index1(FileContents, 1) = Ipt_Data,
    words_separator(char.is_whitespace, Ipt_Data) = StrIpt_List,
    det_index1(StrIpt_List, 2) = Const_N1,
    Num_Seed = string.det_to_int(Const_N1),
    det_index1(FileContents, 2) = RootList,
    words_separator(char.is_whitespace, RootList) = InputList,
    map(det_to_int, InputList) = InitArr,
    doIter(InitArr, VowelL, ConsonL, Num_Seed, "", Res),
    io.print_line(strip(Res), !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA.lst | ./falagosm
% xomenov tegeb wafa zabesego gutuf giduci pulofu tefogu
% fizihuc jacataf vuwopi nuv sogi lixa kite cugofog tikanep
% hewelabo zoto tok
