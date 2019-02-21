#!/usr/bin/env python

import sys
from importlib import util

sys.exit(util.find_spec(sys.argv.pop()) is None)
