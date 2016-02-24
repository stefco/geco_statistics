# Introduction to GECo Statistics Reports

[![Documentation Status](https://readthedocs.org/projects/geco-statistics/badge/?version=latest)](http://geco-statistics.readthedocs.org/en/latest/?badge=latest)
[ ![Codeship Status for stefco/geco_stat](https://codeship.com/projects/e9762300-bd59-0133-0ed3-2a1d867cc1c8/status?branch=master)](https://codeship.com/projects/136547)

## Purpose

`geco_stat` can be used to easily generate histograms, statistics, and
anomaly reports for timing signals generated by LIGO interferometers. It is
meant to simplify the handling of massive amounts of diagnostic data by
providing a simple, organized interface to relevant statistics, easy
progress tracking for large jobs, effortless data visualization, and convenient
ways to combine reports, so that very long timeseries can be efficiently
analyzed in parallel and then recombined into single, monolithic reports
covering entire eras.

Future versions of `geco_statistics` will also provide tools for automating
report generation, reducing the amount of effort that has to go into creating
reports on LIGO's functioning.

## Dependencies

This is a python-2.6 compatible Python module intended for use in
LIGO production environments. Its python dependencies are minimal, which means
it should work out of the box on most python distributions for viewing and
manipulating existing reports generated using the package. At time of writing,
generating *new* reports requires tools installed in LIGO production
environments; it is intended primarily to be run on LIGO servers, though
future implementations may integrate remote access tools.

**If you are just interested in viewing existing diagnostic report data**, you
can use Python, though iPython is recommended for interactive use. [You can
install iPython from the project website.](http://ipython.org) If you are
running this module on a LIGO production environment, no additional
dependencies should be necessary.

You can get around any of these problems by just running `create_virtualenv.sh`
(though this does require virtualenv) and then running
`source env/bin/activate`, after which `python` will work just fine.
