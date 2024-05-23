{ config, pkgs, ... }:

let

  # pkgsUnstable = import <nixpkgs-unstable> {};

in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "joshua";
  home.homeDirectory = "/home/joshua";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.rofi
    pkgs.yadm
    pkgs.autorandr
    pkgs.dmenu
    pkgs.ffcast
    pkgs.kubernetes-helm
    pkgs.jira-cli-go
    pkgs.kitty
    pkgs.kubectl
    # pkgs.neovim
    pkgs.haskellPackages.kmonad
    pkgs.nitrogen
    pkgs.picom
    pkgs.qutebrowser
    pkgs.rofimoji
    pkgs.shellcheck
    pkgs.sshpass
    pkgs.tldr
    pkgs.vault
    pkgs.maim
    pkgs.xdotool
    pkgs.redis
    pkgs.calc
    pkgs.chromium
    pkgs.starship
    pkgs.hyperfine
    pkgs.kubetail
    pkgs.lxappearance
    pkgs.up
    pkgs.virt-manager
    pkgs.awscli2
    pkgs.bat
    #pkgs.nodejs_22
    pkgs.skopeo # interact with remote oci registries
    pkgs.slop # For use with screen_record
    pkgs.fzf
    pkgs.fd
    pkgs.ripgrep
    pkgs.cargo
    pkgs.volctl
    pkgs.unclutter

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/joshua/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
