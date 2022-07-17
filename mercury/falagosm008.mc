/*
  $ mmc -f falagosm008.mc
  $ mmc --make falagosm008
*/

:- module falagosm008.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- func generateSeq(int, int, int, int, list(int)) = list(int).
generateSeq(ValSt, ValCur, Step, Limit, PartList) = R :-
(
  if length(PartList) = Limit
  then R = PartList
  else
    (if length(PartList) = 0
    then
      ValNext = ValSt,
      PartList1 = [ValSt]
    else 
      ValNext = ValCur + Step,
      append(PartList, [ValNext], PartList1)),
    R = generateSeq(ValSt, ValNext, Step, Limit, PartList1)
).

:- pred getSumSeq(list(int), int, int).
:- mode getSumSeq(in, in, out) is det.
getSumSeq([], ResInt, ResInt).
getSumSeq([X | Tail], PartRes, ResInt) :-
(
  PartRes1 = PartRes + X,
  getSumSeq(Tail, PartRes1, ResInt)
).

:- pred getSums(list(string), string, string).
:- mode getSums(in, in, out) is det.
getSums([], FinalAns, strip(FinalAns)).
getSums([Line | Tail], PartialAns, FinalAns) :-
(
  words_separator(char.is_whitespace, Line) = InputList,
  map(det_to_int, InputList) = NumList,
  det_index0(NumList, 0, ValSt),
  det_index0(NumList, 1, Step),
  det_index0(NumList, 2, Limit),
  ListSeq = generateSeq(ValSt, 0, Step, Limit, []),
  getSumSeq(ListSeq, 0, Res),
  PartialAns1 = PartialAns ++ " " ++ from_int(Res),
  getSums(Tail, PartialAns1, FinalAns)
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
    det_drop(1, FileContents, IptList),
    getSums(IptList, "", Res),
    io.print_line(Res, !IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).


% $ cat DATA.lst | ./falagosm008
% 37550 87696 8580 399 1387 20736 812 3485
