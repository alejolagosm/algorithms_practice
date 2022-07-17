% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm071.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred unwords(string::in, string::in, string::out) is det.
unwords(X, Y, X ++ " " ++ Y).

:- func getIdx(int, int, int, int) = int.
getIdx(Num_Div, Num_Idx, Num_A, Num_B) = R :-
(
  Num_Int = Num_A + Num_B,
  Num_B1 = Num_Int mod Num_Div,
  (if Num_B1 = 0
  then R = Num_Idx
  else
    R = getIdx(Num_Div, Num_Idx + 1, Num_B, Num_B1)
  )
).

:- pred calcIdx(list(int), list(int), list(int)).
:- mode calcIdx(in, in, out) is det.
calcIdx([], FullAns, FullAns).
calcIdx([X | Tail], PartAns, FullAns) :-
(
  Num_Idx = getIdx(X, 2, 0, 1),
  (if length(PartAns) = 0
  then PartAns1 = [Num_Idx]
  else PartAns1 = PartAns ++ [Num_Idx]),
  calcIdx(Tail, PartAns1, FullAns)
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
    map(det_to_int, InputList) = ValuesArr,
    calcIdx(ValuesArr, [], ResList),
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
% 132804 57057 22050 857744 71100 18810 607968 8100 66300 68100
% 1007598 73308 29400 298338 81603 95676 47340 1186800 270 684
% 123000 1015890 147480
