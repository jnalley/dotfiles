#!/usr/bin/env python

import sys

try:
    from importlib import util
except:
    sys.exit(1)

sys.exit(util.find_spec(sys.argv.pop()) is None)
