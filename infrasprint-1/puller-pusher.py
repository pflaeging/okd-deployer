#! /usr/bin/python
# python3!
from __future__ import absolute_import, division, print_function

import re

imagelist = "images.list"
destination_registry = "reg.pflaeging.net"
# destination_project = "openshift"

images = open(imagelist, "r")

for srcimage in images:
    if re.match('^#',srcimage) is None:
        sim = srcimage.strip('\n')
        (registry, srcproject, imagename) = sim.split("/")
        # print( "Source:", sim, "SourceProject:", srcproject, "Imagename & Version:", imagename)
        destimage = "%s/%s/%s" % (destination_registry, srcproject, imagename)
        print("docker pull", sim, "; docker tag", sim, destimage, "; docker push", destimage) 
