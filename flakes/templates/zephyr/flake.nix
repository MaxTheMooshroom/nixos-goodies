{
  inputs.nixpkgs.url = "nixpkgs/release-23.11";

  inputs.zephyr-rtos = {
    url = "github:katyo/zephyr-rtos.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, zephyr-rtos, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ zephyr-rtos.overlays.default ];
      });
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          # pkgs32 = pkgs.??;
          zephyrSdk = pkgs.mkZephyrSdk {  };
        in
        {
          default = zephyrSdk.overrideAttrs (prev: with pkgs; {
            buildInputs = [
              # pkgs32.SDL2 # for native_sim build target
              python3Packages.tkinter # for gui menuconfig
            ] ++ prev.buildInputs;

            nativeBuildInputs = with pkgs; [
              pkg-config
            ];
          });
        });
    };
}
