#! /bin/sh

sed -i -e '$a\' certs/certificate.crt
sed -i -e '$a\' certs/private.key
sed -i -e '$a\' certs/ca_bundle.crt
