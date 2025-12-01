{
  description = "A C++ template using cmake for nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "template";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
          ];

          buildInputs = with pkgs; [
            libGL
            libGLU
            xorg.libX11
            xorg.libXrandr
            xorg.libXinerama
            xorg.libXcursor
            xorg.libXi
            xorg.libXxf86vm
            wayland
            wayland-protocols
            wayland-scanner
            libxkbcommon
            glew
            glm
          ];

          cmakeFlags = [];

          meta = with pkgs.lib; {
            homepage = "https://github.com/MordragT/nix-templates/tree/master/cpp";
            description = "A C++ template using cmake for nix";
            license = licenses.mit;
            platforms = platforms.all;
            maintainers = with maintainers; [mordrag];
          };
        };

        devShells.default = pkgs.mkShell {
          # Inherit build inputs from the package
          inputsFrom = [ self.packages.${system}.default ];

          # Add dev-only tools
          packages = with pkgs; [
            just
            mesa-demos  # for glxinfo, glxgears
            gdb         # debugger
            clang-tools # clangd for LSP
          ];

          shellHook = ''
            echo "C++ OpenGL dev environment loaded!"
          '';
        };
      }
    )
    // {
      overlays.default = final: prev: {
        template = self.packages."${final.system}".default;
      };
    };
}
