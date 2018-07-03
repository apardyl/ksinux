#!/bin/sh

die () {
    echo "CRITICAL ERROR!!!"
    echo "Contact admin@ksi.ii.uj.edu.pl for help"
    echo "Power off in 5s"
    sleep 5
    echo "Kill power"
    echo o > /proc/sysrq-trigger
    sleep 1
    echo "If you are seeing this the kernel failed to power off gracefully, kernel panic in 10s"
    sleep 10
}

panic () {
    echo "!!!ERROR!!! $1"
    echo "Contact admin@ksi.ii.uj.edu.pl for help"
    echo "Dropping to shell"
    setsid cttyhack sh
    die
}

info () {
    echo "ksinux: $1"
}

ksilogo () {
    echo "
     /@@
     @     @@@@@
     ,@@.@@@@@
       @
      @
      @
       @# ,@@@@@@@
       @@
     @@
   @@
  @@
  @@
  @@
   @@@.
    @@@@@@@@@@@@@@%
       @@@@@@@@@@@@&
                  @@
                  @@
                 %@
           @@@@@@&
    "
}

zaionc () {
    echo "
                                                     WNNW
                                          WXXXW     WXKKKN
                                          NK00KNW   WXXXXXW
                        WWNNXXXXXXXNNNWW  WX0OO0XNW  NKKKXW
                   WNXKKK00000000OOOOOO0KXNXKK0O0KKXXKO0KXW
               WNXKK000KKKKXKKKKKKKKK00OOkkxk000KXX0kxk0KKW
             WXKKKKXXXXXXXXXXXXXXXXXXKKKK0Oxdk0KKXNNKOOKKKW
          WNXKKKXXXNXNNNNNNNNNNNNNNNXXXXXKK0kkOKKXNNX0OK00NW
         WXKKXXNNNNNNNNNNNNNNNNNNNNNNNNXXXXKK00KXXXNNXKKK0KKXN
        WK0KXNNNNNNNNNNNNNNNNWWWNNNNNNNNXXXXXXKXXXXNNNNNNNXK0O0XW
       WK0KXXNNNNNNNNNNNNNNWWWWWWNNNNNNNNXXXXXXXKKKNNWNKKNNXK0xd0W
      WKKXXNNNNNNNNNNNNNNNNWWWWNNNNNNNNNNNNXXXXXKKKXNNX0OXNNXKOdokXW
     WK0KXNNNNNNNNNNNNNNNNWWWWWNNNNNNNNNNNNNXXXXKKKXXXXXXNNNXK0koloON
    NK0KXXNNNNNNNNNNNNNNNNNWWNNNNNNNNNNNNNNNXXXXXXKKKKXXXXXXXK0OxollkN
   N0OKXXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXXXXXXKKKKKKXXXXKOdoooldK
  N0k0KXXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXXXXXXXXXKKK0000Okxdoddoo0
 W0kk0KXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXXXXXXXXKKKKK000Okkkkkxdoo0
 NOxO0KXXXNNNNNNNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKKKKKK0000000OkkkkxoodK
 NkxkO0KXXXXXXXXKKKKKKKKKKKKKKXXXXXXXXKKKKKKKKKKK000000OOOOOkkxddoldOX
 WKkxkO000KKKK000000000000000KKKKKKKKKKKKKK000000OOOOkkkkkkxxdoolldkXW
  WNK0OOOOOOOOOkkkkkkkkOOkkOOOOO000000000O0OOOOkkkkxxxddddddddddk0KNW
      WWWNNXXXXKKKK000000OOkkkkkkxxxxxxxxxxxxxxddddddxkOOOO0KXNNW
                         WWNNXXXXKK000000OkkkkkOO0KKXNW
                                         WWWWWWW"
}
