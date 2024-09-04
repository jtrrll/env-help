# env-help

<!-- markdownlint-disable MD013 -->
![GitHub Actions CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/env-help/ci.yaml?branch=main&logo=github&label=CI)
![License](https://img.shields.io/github/license/jtrrll/env-help?label=License)
<!-- markdownlint-enable MD013 -->

A help message for development environments.
A [devenv](https://devenv.sh/) module written in [Nix](https://nixos.org/).

## Usage

1. Import the `devenvModule` within a [devenv](https://devenv.sh/) configuration.

   <!-- markdownlint-disable MD013 -->
   ```nix
   {
     outputs = inputs: {
       devShells."x86_64-linux".default = devenv.lib.mkShell {
         inherit inputs pkgs;
         modules = [
           inputs.env-help.devenvModule
           ...
         ];
       };
       ...
     };
     ...
   }
   ```
   <!-- markdownlint-enable MD013 -->

2. Enable `env-help` within a [devenv](https://devenv.sh/) configuration.

   <!-- markdownlint-disable MD013 -->
   ```nix
   {
     env-help = {
       enable = true;
       ...
     };
     scripts = {
      "example" = { 
        exec = ...;
        description = ...;
      };
       ...
     };
     ...
   }
   ```
   <!-- markdownlint-enable MD013 -->

3. Run `env-help` to list information about the development environment.

   <!-- markdownlint-disable MD013 -->
   ```sh
   env-help
   ```
   <!-- markdownlint-enable MD013 -->
