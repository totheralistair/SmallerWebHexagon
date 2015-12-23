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

Run `ruby test_smaller_web_hexagon.rb` to run the tests (must be inside the `test` folder).
Run `rackup config.ru` to get the web UI on port 9292
