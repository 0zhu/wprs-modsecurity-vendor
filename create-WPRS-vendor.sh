#!/bin/bash
# https://github.com/zhubanRuban/wprs-modsecurity-vendor

# source repo settings
BASENAME=wordpress-modsecurity-ruleset
REPO=https://github.com/Rev3rseSecurity/${BASENAME}
BRANCH=master

# destination repo settings
DESTBASENAME=wprs-modsecurity-vendor
DESTREPO=https://github.com/zhubanRuban/${DESTBASENAME}
DESTBRANCH=master

# modsecurity vendor properties
VENDESC="Modsecurity Vendor created from ${BRANCH} branch of ${REPO}"
VENDNAME="WordPress ModSecurity Rule Set (WPRS)"
VENDURL="${DESTREPO}"

wget -qO ${BRANCH} ${REPO}/archive/${BRANCH}.zip
unzip -q ${BRANCH}; rm -f ${BRANCH}
DISTR=$(date +%Y%m%d)
ARCHIVE=${BASENAME}-${BRANCH}-${DISTR}.zip
zip -qr ${ARCHIVE} ${BASENAME}-${BRANCH}/*.conf
rm -rf ${BASENAME}-${BRANCH}
MD5SUM=$(md5sum ${ARCHIVE}|awk '{print $1}')
SHA512SUM=$(sha512sum ${ARCHIVE}|awk '{print $1}')

YAMLFILE=meta_${BASENAME}-${BRANCH}.yaml
(
	echo "--- "
	for MODSECVER in 2.9.0 2.9.2; do
		echo "${MODSECVER}: "
		echo "  MD5: ${MD5SUM}"
		echo "  SHA512: ${SHA512SUM}"
		echo "  distribution: ${DISTR}"
		echo "  url: ${DESTREPO}/raw/${DESTBRANCH}/${ARCHIVE}"
	done
	for MODSECVER in 2.9.3 2.9.4 2.9.5 2.9.6 2.9.7 3.0.0 3.0.1 3.0.2 3.0.3 3.0.4; do
		echo "${MODSECVER}: "
		echo "  MD5: ${MD5SUM}"
		echo "  SHA512: ${SHA512SUM}"
		echo "  defaulted: 1"
		echo "  distribution: ${DISTR}"
		echo "  url: ${DESTREPO}/raw/${DESTBRANCH}/${ARCHIVE}"
	done
	echo "attributes: "
	echo "  description: ${VENDESC}"
	echo "  name: ${VENDNAME}"
	echo "  vendor_url: ${VENDURL}"
) > ${YAMLFILE}
echo -e "Archive:\t${ARCHIVE}\nYAML:\t\t${YAMLFILE}"
