#!/usr/bin/env python
# pylint: disable=C0116,W0613

import time
import datetime

starttime = time.time()
# ...
def get_uptime():
    """
    Returns the number of seconds since the program started.
    """
    # do return startTime if you just want the process start time
    uptime = time.time() - starttime
    return str(datetime.timedelta(seconds=round(uptime)))