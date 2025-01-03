{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.devenv.flakeModule
  ];
  perSystem = {pkgs, ...}: {
    devenv = {
      modules = [self.devenvModule {env-help.enable = true;}];
      shells.default = {
        enterShell = ''
          printf "                 _        _
           ___ _ ___ _____| |_  ___| |_ __
          / -_) ' \ V /___| ' \/ -_) | '_ \\
          \___|_||_\_/    |_||_\___|_| .__/
                                     |_|\n" | ${pkgs.lolcat}/bin/lolcat
          printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"
        '';
        languages = {
          nix.enable = true;
        };
        packages = [
          pkgs.nerd-fonts.hack
        ];
        pre-commit = {
          default_stages = ["pre-push"];
          hooks = {
            actionlint.enable = true;
            alejandra.enable = true;
            check-added-large-files = {
              enable = true;
              stages = ["pre-commit"];
            };
            check-yaml.enable = true;
            deadnix.enable = true;
            detect-private-keys = {
              enable = true;
              stages = ["pre-commit"];
            };
            end-of-file-fixer.enable = true;
            flake-checker.enable = true;
            markdownlint.enable = true;
            mixed-line-endings.enable = true;
            nil.enable = true;
            no-commit-to-branch = {
              enable = true;
              stages = ["pre-commit"];
            };
            ripsecrets = {
              enable = true;
              stages = ["pre-commit"];
            };
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;
          };
        };
        scripts = {
          "demo" = {
            description = "Generates a demo GIF.";
            exec = ''
              PATH="${pkgs.bashInteractive}/bin:$PATH"
              ${pkgs.vhs}/bin/vhs "$DEVENV_ROOT"/demo.tape
            '';
          };
          "build" = {
            description = "Builds the project binary.";
            exec = ''
              ${pkgs.uutils-coreutils-noprefix}/bin/printf "DEMO SCRIPT: build"
            '';
          };
          "lint" = {
            description = "Lints the project.";
            exec = ''
              nix fmt "$DEVENV_ROOT" -- --quiet
            '';
          };
          "test" = {
            description = "Runs all unit tests.";
            exec = ''
              ${pkgs.uutils-coreutils-noprefix}/bin/printf "DEMO SCRIPT: test"
            '';
          };
        };
      };
    };
  };
}
