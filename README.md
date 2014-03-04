ciphercompare
=============

Compares different SSL/TLS services of different providers in a generic way.

ciphercompare is written in bash and requires only openssl, so it should run on
any unixoid operating system.

usage:
------

Edit subject.cfg and ciphercompare.cfg to fit your needs. It should be self
explanatory.

`bash
# ./ciphercompare.sh
`

Results will be found in the csv you defined in ciphercompare.cfg.

Known Bugs:
-----------

    * No error-handling at all.

