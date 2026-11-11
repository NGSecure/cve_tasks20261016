#!/usr/bin/env python
# pylint: disable=C0116,W0613

class NotImplemented(Exception):
    def __init__(self):
        super().__init__("This feature is not implemented, yet")
    pass