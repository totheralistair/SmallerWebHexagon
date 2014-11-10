Smaller Web Hexagon
==========

Illustration of a simple hexagon
one user (left) port and one db (right) port.

It simply calculates the formula:

    result = input * rate
e.g.
    result = 100 * 1.1 = 110


The user port is connected to either the web or to a test harness, with or without the server adapter,
The db port looks up the rate in a database, either in-the-code db, or from a file.

The startup decides how the wiring goes.

Run test_smaller_web_hexagon to run the tests.
Run `rackup config.ru` to get the web UI on port 9292

Note Nov 10 : Kevin Rutherford just pointed out to me that when I cribbed this code over
from https://github.com/totheralistair/SmallWebHexagon, I didn't move the Rack Requests
over from inside the hexagon to the adaptor. He so right. Boo. OK, major revision on it's way
when he or I get a chance. oog, as they say.


