#!/usr/bin/env python
# pylint: disable=C0116,W0613

import requests

def get_url():
    contents = requests.get('https://random.dog/woof.json').json()    
    url = contents['url']
    return url
