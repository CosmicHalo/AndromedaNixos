{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "catppuccin-plymouth";
  pname = "catppuccin-plymouth";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "67759fbe15eb9490d096ef8014d9f92fc5748fe7";
    hash = "sha256-quBSH8hx3gD7y1JNWAKQdTk3CmO4t1kVo4cOGbeWlNE=";
  };

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes
  '';

  buildPhase = "";

  installPhase = ''
    cp -r themes/catppuccin-frappe $out/share/plymouth/themes/
    cat themes/catppuccin-frappe/catppuccin-frappe.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/catppuccin-frappe/catppuccin-frappe.plymouth

    cp -r themes/catppuccin-latte $out/share/plymouth/themes/
    cat themes/catppuccin-latte/catppuccin-latte.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/catppuccin-latte/catppuccin-latte.plymouth

    cp -r themes/catppuccin-macchiato $out/share/plymouth/themes/
    cat themes/catppuccin-macchiato/catppuccin-macchiato.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/catppuccin-macchiato/catppuccin-macchiato.plymouth

    cp -r themes/catppuccin-mocha $out/share/plymouth/themes/
    cat themes/catppuccin-mocha/catppuccin-mocha.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/catppuccin-mocha/catppuccin-mocha.plymouth
  '';

  meta = {
    description = "Soothing pastel theme for Plymouth";
    homepage = "https://github.com/catppuccin/plymouth";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [matthewpi];
  };
}
