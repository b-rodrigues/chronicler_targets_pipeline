let
 pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/b6ed7946a7917d29df2c3979b0b7c230f727119b.tar.gz") {};
 rpkgs = builtins.attrValues {
  inherit (pkgs.rPackages) quarto chronicler targets tarchetypes dplyr;
};
  tex = (pkgs.texlive.combine {
  inherit (pkgs.texlive) scheme-small amsmath framed fvextra environ fontawesome5 orcidlink pdfcol tcolorbox tikzfill;
});
 system_packages = builtins.attrValues {
  inherit (pkgs) R glibcLocalesUtf8 quarto;
};
housing = (buildRPackage {
            name = "housing";
            src = fetchgit {
                   url = "https://github.com/rap4all/housing/";
                   branchName = "fusen";
                   rev = "1c860959310b80e67c41f7bbdc3e84cef00df18e";
                   sha256 = "sha256-s4KGtfKQ7hL0sfDhGb4BpBpspfefBN6hf+XlslqyEn4=";
                 };
           propagatedBuildInputs = [
            dplyr ggplot2 janitor purrr readxl rlang rvest stringr tidyr
           ];
  });
  in
  pkgs.mkShell {
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";

    buildInputs = [  rpkgs tex system_packages housing ];
      
  }
