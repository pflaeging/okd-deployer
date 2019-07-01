#!/bin/bash
# <peter@pflaeging.net>

if [ $# -eq 0 ]
    then echo "usage $0 user1 user2 ..." 
fi


for user in $@
    do echo "Creating user: $user"
    # as cluster-admin
    oc create user $user.admin
    oc create identity Administrators:$user.admin
    oc create useridentitymapping Administrators:$user.admin $user.admin
    oc adm groups add-users admin-users $user.admin
done