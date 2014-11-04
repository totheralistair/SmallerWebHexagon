Smaller Web Hexagon
==========

Illustration of the hexagon, for an almost nul system that has
one primary (left) port and two secondary (right) ports.

It simply calculates the formula:

    result = input * rate
e.g.
    result = 100 * 1.1 = 110


The one primary port is connected to the requesting side,
accepts "input" and reports "result".

The first of the two secondary ports looks up the rate in a database.
The second of the two secondary ports logs the request.


Run `rackup config.ru` to get the web UI on port 9292
Run test_whatnot to run the tests.


