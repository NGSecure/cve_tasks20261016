#!/usr/bin/env python
# pylint: disable=C0116,W0613

import requests

def get_url():
    contents = requests.get('https://api.thecatapi.com/v1/images/search').json()
    url = contents[0]['url']
    return url
