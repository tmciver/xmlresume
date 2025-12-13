{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    jre
    fop
    saxonb
    xalanc
  ];
}
