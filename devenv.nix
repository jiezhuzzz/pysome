{
  pkgs,
  lib,
  config,
  ...
}: {
  env.UV_PYTHON_DOWNLOADS = lib.mkForce "auto";
  env.UV_PYTHON_PREFERENCE = lib.mkForce "managed";
  languages = {
    python = {
      enable = true;
      uv = {
        enable = true;
        sync.enable = true;
      };
    };
  };
  enterShell = ''
    ln -sfn ${config.env.DEVENV_STATE}/venv .venv
  '';

  packages = with pkgs; [
    just
  ];

  treefmt = {
    enable = true;
    config.programs = {
      # GitHub Actions
      actionlint.enable = true;
      # Nix
      alejandra.enable = true;
      statix.enable = true;
      # Python
      ruff-check.enable = true;
      ruff-format.enable = true;
      # Shell
      shfmt.enable = true;
      shellcheck.enable = true;
      # Markdown
      mdformat.enable = true;
      # YAML
      yamlfmt.enable = true;
      # Just
      just.enable = true;
      # Spelling
      typos.enable = true;
      autocorrect.enable = true;
    };
    config.settings.formatter = {
      # TOML
      tombi = {
        command = "${pkgs.tombi}/bin/tombi";
        includes = ["*.toml"];
        options = ["format"];
      };
    };
  };

  git-hooks.package = pkgs.prek;
  git-hooks.hooks = {
    # Format
    treefmt.enable = true;
    # Python
    uv-lock.enable = true;
    # Git
    convco.enable = true;
    check-branch = {
      enable = true;
      name = "Check branch name";
      entry = "uvx commit-check --branch";
      language = "system";
      pass_filenames = false;
    };
  };
  # See full reference at https://devenv.sh/reference/options/
}
