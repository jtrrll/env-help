# env-help

<!-- markdownlint-disable MD013 -->
![GitHub Actions CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/env-help/ci.yaml?branch=main&logo=github&label=CI)
![License](https://img.shields.io/github/license/jtrrll/env-help?label=License)
<!-- markdownlint-enable MD013 -->

A help message for development environments.
A [devenv](https://devenv.sh/) module written in [Nix](https://nixos.org/).

## Usage

<!-- markdownlint-disable MD029 -->
1. Import this module in your `devenv` config.

<!-- markdownlint-disable MD013 -->
   ```sh
   {inputs, ...}: {
     imports = [
       inputs.env-help.devenvModule
     ];
     ...
   }
   ```
<!-- markdownlint-enable MD013 -->

2. Enable the module in a `devenv` shell config.

<!-- markdownlint-disable MD013 -->
   ```sh
   {
     env-help = {
       enable = true;
       ...
     };
     scripts = {
       ...
     };
   }
   ```
<!-- markdownlint-enable MD013 -->

3. Run `env-help` to list information about the development environment.

<!-- markdownlint-disable MD013 -->
   ```sh
   env-help
   ```
<!-- markdownlint-enable MD013 -->
<!-- markdownlint-enable MD029 -->
