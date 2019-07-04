{ stdenv
, fetchFromGitHub
, cmake
, zeromq
, pkgconfig
, libuuid
, cling
, pugixml
, gcc
, clang
, ncurses
, zlib
, openssl
}:
let
  xtl = stdenv.mkDerivation {
      name = "xtl";

      src = fetchFromGitHub {
          owner = "QuantStack";
          repo = "xtl";
          rev = "01be49d75867ee99d48bf061a913f98e12fc6704";
          sha256 = "0xy040b4b5a39kxqnj7r0bm64ic13szrli8ik95xvfh26ljh8c7q";
        };

      buildInputs = [ cmake clang ];

      preConfigure = ''
        export CC=${clang}/bin/cc
        export CXX=${clang}/bin/c++
      '';

      buildPhase = ''
          cmake
          '';
      };

  nlohmannJson = stdenv.mkDerivation {
      name = "nlohmannJson";
      src = fetchFromGitHub {
          owner = "nlohmann";
          repo = "json";
          rev = "e89c946451cfdb7392b12bc6c3674b548ea5c0ee";
          sha256 = "16rgp9rgdza82zcbh9r9i7k2yblkz2fd3ig64035fny2p6pxw6lm";
        };
      buildInputs = [ cmake clang ];

      preConfigure = ''
        export CXX=${clang}/bin/c++
      '';

      buildPhase = ''
          pwd
          ls -la
          cmake
          '';
        };

  cppzmq = stdenv.mkDerivation {
      name = "cppzmq";

      src = fetchFromGitHub {
          owner = "zeromq";
          repo = "cppzmq";
          rev = "d641d1de4c8aa7f2dc674d80b3a71469364b9534";
          sha256 = "0n8xfpydrqxbzdcpmamnw27r02rslxj2rf6hp4n79ljqm5smq385";
        };
      buildInputs = [ cmake zeromq clang ];

      preConfigure = ''
        export CC=${clang}/bin/cc
        export CXX=${clang}/bin/c++
      '';
    };

  cxxopts = stdenv.mkDerivation {
      name = "cxxopts";

      src = fetchFromGitHub {
          owner = "jarro2783";
          repo = "cxxopts";
          rev = "9990f73845d76106063536d7cd630ac15cb4a065";
          sha256 = "0hhw52plq7nyh1v040h1afw0kaq8rha7hvwyw8nnyyvb9kbnkqqs";
        };

      buildInputs = [ cmake clang ];

      preConfigure = ''
        export CC=${clang}/bin/cc
        export CXX=${clang}/bin/c++
      '';
  };

  xeus = stdenv.mkDerivation {
      name = "xeus";

      src = fetchFromGitHub {
          owner = "QuantStack";
          repo = "xeus";
          rev = "092cf4590aa6c5b6aa1956c4eaf2b6f77a98fa66";
          sha256 = "0ph2nv0c6ghl3za2k1ydv8g3iyjxc5iy4ys1v4i2r5yi2w4wlf70";
        };

        buildInputs = [ cmake zeromq cppzmq nlohmannJson openssl xtl pkgconfig libuuid clang ];

        configurePhase = ''
          export CC=${clang}/bin/cc
          export CXX=${clang}/bin/c++
          mkdir build
          cd build
          cmake -DBUILD_EXAMPLES=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out -DPKG_CONFIG_EXECUTABLE=${pkgconfig}/bin/pkg-config ..
        '';
      };

  xeusCling = stdenv.mkDerivation {
      name = "xeusCling";

      src = fetchFromGitHub {
          owner = "QuantStack";
          repo = "xeus-cling";
          rev = "1974c29977a87531dfd39377be32d713aa26ecf2";
          sha256 = "0i48ywiz7sgvln106phs0syd00kly0sirr8ib2hlri32j5awph8v";
        };

      buildInputs = [ cmake zeromq cppzmq xeus libuuid xtl pkgconfig cling pugixml cxxopts nlohmannJson clang ncurses zlib openssl ];

      configurePhase = ''
        export CC=${clang}/bin/cc
        export CXX=${clang}/bin/c++

        echo "=======> CHECK RTTI"
        llvm-config --has-rtti
        mkdir build
        cd build
        cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out ..
      '';
      };
in
  xeusCling
