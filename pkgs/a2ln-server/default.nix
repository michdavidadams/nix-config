{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "a2ln-server";
  version = "1.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patri9ck";
    repo = "a2ln-server";
    rev = version;
    hash = "sha256-6SVAFeVB/YpddJhSHgjIF43i2BAmFFADMwlygp9IrSU=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pillow
    pygobject
    pyzmq
    qrcode
  ];

  pythonImportsCheck = [ "a2ln" ];

  meta = with lib; {
    description = "A way to display Android phone notifications on Linux (Server";
    homepage = "https://github.com/patri9ck/a2ln-server";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "a2ln-server";
  };
}
