% mmc -f falagosm.mc
% mmc --make falagosm

:- module falagosm047.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int, char.

:- pred doDechiper(list(char), list(char), int, string, string).
:- mode doDechiper(in, in, in, in, out) is det.
doDechiper([], _, _, FullStr, FullStr).
doDechiper([Char | Tail], Alphabet, Cipher, PartStr, FullStr) :-
(
  det_index0_of_first_occurrence(Alphabet, Char) = IdxSt,
  (if IdxSt = 26
  then IdxDc = 26
  else IdxDc = IdxSt - Cipher),
  (if IdxDc < 0
  then IdxDc2 = IdxDc + 26
  else IdxDc2 = IdxDc),
  det_index0(Alphabet, IdxDc2) = DcChar,
  char_to_string(DcChar, DcString),
  PartStr1 = PartStr ++ DcString,
  doDechiper(Tail, Alphabet, Cipher, PartStr1, FullStr)
).

:- pred getSentence(list(string), list(char), int, string, string).
:- mode getSentence(in, in, in, in, out) is det.
getSentence([], _, _, FullStr, FullStr).
getSentence([X | Tail], Alphabet, Cipher, PartStr, FullStr) :-
(
  to_char_list(X) = Chars,
  doDechiper(Chars, Alphabet, Cipher, "", DcWord),
  (if length(PartStr) = 0
  then PartStr1 = DcWord
  else PartStr1 = PartStr ++ " " ++ DcWord),
  getSentence(Tail, Alphabet, Cipher, PartStr1, FullStr)
).

:- pred doIter(list(string), list(char), int, string, string).
:- mode doIter(in, in, in, in, out) is det.
doIter([], _, _, FullStr, FullStr).
doIter([Sentence | Tail], Alphabet, Cipher, PartStr, FullStr) :-
(
  words_separator(char.is_whitespace, Sentence) = IptStrList,
  getSentence(IptStrList, Alphabet, Cipher, "", DcSentence),
  %trace [io(!IO)] (io.print_line(DcSentence, !IO)),
  (if length(PartStr) = 0
  then PartStr1 = DcSentence
  else PartStr1 = PartStr ++ " " ++ DcSentence),
  doIter(Tail, Alphabet, Cipher, PartStr1, FullStr)
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
    words_separator(char.is_whitespace, Ipt_Data) = StrIpt_Data,
    det_index1(StrIpt_Data, 2) = Const_N1,
    Cipher = string.det_to_int(Const_N1),
    Chars1 = ['A','B','C','D','E','F','G','H','I','J','K','L','M'],
    Chars2 = ['N','O','P','Q','R','S','T','U','V','W','X','Y','Z','.'],
    Alphabet = Chars1 ++ Chars2,
    list.det_drop(1, FileContents, ListStr),
    doIter(ListStr, Alphabet, Cipher, "", FinalDecipher),
    io.print_line(FinalDecipher,!IO)
  ;
    Result = error(IOError),
    Msg = io.error_message(IOError),
    io.stderr_stream(Stderr, !IO),
    io.write_string(Stderr, Msg, !IO),
    io.set_exit_status(1, !IO)
  ).

% $ cat DATA.lst | ./falagosm
/*
  A NIGHT AT THE OPERA THE ONCE AND FUTURE KING ARE WONDERS MANY TOLD.
  CARTHAGE MUST BE DESTROYED TO US IN OLDEN STORIES.
  AND SO YOU TOO BRUTUS GREENFIELDS ARE GONE NOW MET A WOMAN AT THE WELL.
  THE DEAD BURY THEIR OWN DEAD AND FORGIVE US OUR DEBTS.
  IN ANCIENT PERSIA THERE WAS A KING THE SECRET OF HEATHER ALE.
  LOVEST THOU ME PETER WHO WANTS TO LIVE FOREVER.
*/
