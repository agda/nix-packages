let
  agda270pkgs = import (builtins.fetchTarball
    https://github.com/nixos/nixpkgs/tarball/2b0dd45aca6a260762395ca2e94beab247f455a7) {};

  locales = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux"
                     then "${pkgs.glibcLocales}/lib/locale/locale-archive"
                     else "";
  };

in {
  agda270 = final: prev: rec {
    agdaPackages = agda270pkgs.agdaPackages;

    standard-library = agdaPackages.standard-library;

    standard-library-classes = agdaPackages.mkDerivation {
      inherit (locales) LANG LC_ALL LOCALE_ARCHIVE;
      pname = "agda-stdlib-classes";
      version = "2.0";
      src = fetchFromGitHub {
        repo = "agda-stdlib-classes";
        owner = "omelkonian";
        rev = "2b42a6043296b4601134b8ab9371b37bda5d4424";
        sha256 = "sha256-kTqS9p+jjv34d4JIWV9eWAI8cw9frX/K9DHuwv56AHo=";
      };
      meta = { };
      libraryFile = "agda-stdlib-classes.agda-lib";
      everythingFile = "standard-library-classes.agda";
      buildInputs = [ standard-library ];
    };

    standard-library-meta = agdaPackages.mkDerivation {
      inherit (locales) LANG LC_ALL LOCALE_ARCHIVE;
      pname = "agda-stdlib-meta";
      version = "2.1.1";
      src = fetchFromGitHub {
        repo = "stdlib-meta";
        owner = "omelkonian";
        rev = "v2.1.1";
        sha256 = "qOoThYMG0dzjKvwmzzVZmGcerfb++MApbaGRzLEq3/4=";
      };
      meta = { };
      libraryFile = "agda-stdlib-meta.agda-lib";
      everythingFile = "Main.agda";
      buildInputs = [ standard-library standard-library-classes ];
    };

    sets = agdaPackages.mkDerivation {
      inherit (locales) LANG LC_ALL LOCALE_ARCHIVE;
      pname = "agda-sets";
      version = "2.1.1";
      src = pkgs.fetchFromGitHub {
        repo = "agda-sets";
        owner = "input-output-hk";
        rev = "f517d0d0c1ff1fd6dbac8b34309dea0e1aea6fc6";
        sha256 = "sha256-OsdDNNJp9NWDgDM0pDOGv98Z+vAS1U8mORWF7/B1D7k=";
      };
      meta = { };
      libraryFile = "abstract-set-theory.agda-lib";
      everythingFile = "src/abstract-set-theory.agda";
      buildInputs = [ standard-library standard-library-classes standard-library-meta ];
    };

    iog-prelude = customAgda.agdaPackages.mkDerivation {
      inherit (locales) LANG LC_ALL LOCALE_ARCHIVE;
      pname = "agda-prelude";
      version = "2.0";
      src = pkgs.fetchFromGitHub {
        repo = "iog-agda-prelude";
        owner = "input-output-hk";
        rev = "75e421ffb4741e8499f5c12104813cedbb7e67b7";
        sha256 = "sha256-sVSAiTRmZtg4FIUDp4n+tot0oIbxEu6dB5BLlaeXcg4=";
      };
      meta = { };
      libraryFile = "iog-prelude.agda-lib";
      everythingFile = "src/Everything.agda";
      buildInputs = [ standard-library standard-library-classes ];
    };

    agdaWithPkgs = p: customAgda.agda.withPackages { pkgs = p; ghc = pkgs.ghc; };

    agdaWithDeps = agdaWithPkgs
      [ standard-library standard-library-classes standard-library-meta sets iog-prelude ];
  };
}
