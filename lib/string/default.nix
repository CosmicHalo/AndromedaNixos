_: rec {
  /*
  * replaceText ["lazy" "color"] [true "red"] "@lazy@ @color@"
  */
  replaceText = input: output: text:
    builtins.replaceStrings (builtins.map (x: ''"@${x}@"'') input) output text;

  replaceTextInFile = input: output: file:
    replaceText input output
    (builtins.readFile file);
}
