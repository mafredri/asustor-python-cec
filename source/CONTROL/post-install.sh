#!/bin/sh

PKG_DIR=/usr/local/AppCentral/python-cec

case "$APKG_PKG_STATUS" in
	install)
		;;
	upgrade)
		;;
	*)
		;;
esac

(cd ${PKG_DIR}; ln -sf lib-${AS_NAS_ARCH} lib)

exit 0
