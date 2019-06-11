#! /usr/bin/python
# python3!
from __future__ import absolute_import, division, print_function

import re

imagelist = "images.list"
imagepatcher = "images.patcher"
destination_registry = "reg.pflaeging.net"

patchscript = "openshift-ansible-patcher.sh"
pullscript = "pull+push.sh"
# destination_project = "openshift"


patchfile = open(patchscript, "a")
pullfile = open(pullscript, "a")

images = open(imagelist, "r")
patcher = open(imagepatcher, "r")

for srcimage in images:
    if re.match('^#',srcimage) is None:
        sim = srcimage.strip('\n')
        (registry, srcproject, imagename) = sim.split("/")
        # print( "Source:", sim, "SourceProject:", srcproject, "Imagename & Version:", imagename)
        destimage = "%s/%s/%s" % (destination_registry, srcproject, imagename)
        print("docker pull", sim, "; docker tag", sim, destimage, "; docker push", destimage, file=pullfile) 

for srcimage in patcher:
    if re.match('^#',srcimage) is None:
        sim = srcimage.strip('\n')
        (registry, srcproject, imagename) = sim.split("/")
        # print( "Source:", sim, "SourceProject:", srcproject, "Imagename & Version:", imagename)
        destimage = "%s/%s/%s" % (destination_registry, srcproject, imagename)
        print("docker pull", sim, "; docker tag", sim, destimage, "; docker push", destimage, file=pullfile) 

        # simreplace = registry + '\/' + srcproject + '\/' + imagename
        # newsim = destination_registry + '\/' + srcproject + '\/' + imagename
        print("grep -lr --exclude-dir=.git -e \"%s\" openshift-ansible | xargs sed --in-place=.orig -e 's&%s&%s&g'" %(sim, sim, destimage), file=patchfile)

images.close()
patcher.close()
pullfile.close()
patchfile.close()