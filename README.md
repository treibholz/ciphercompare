ciphercompare
=============

Compares different SSL/TLS services of different providers in a generic way.

Ciphercompare is written in bash and requires only openssl, so it should run on
any unixoid operating system.

The results will be written in a CSV-file for further interpretation.

Ciphercompare does not judge the quality of any cipher!

usage:
------

Edit subject.cfg and ciphercompare.cfg to fit your needs. It should be self
explanatory.

    ./ciphercompare.sh

Results will be found in the csv you defined in ciphercompare.cfg.

known bugs:
-----------

* No error-handling at all.



