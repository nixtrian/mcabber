# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/quassel/quassel-9999.ebuild,v 1.31 2010/01/07 15:42:56 fauli Exp $

EAPI="2"

inherit cmake-utils eutils git

EGIT_REPO_URI="http://isbear.unixzone.org.ua/source/mcabber-mpd"
EGIT_BRANCH="master"

DESCRIPTION="Mcabber module to publish your MPD music via PEP."
HOMEPAGE="http://isbear.unixzone.org.ua/source"

LICENSE="GPL-3"
SLOT="0"

RDEPEND=">net-im/mcabber-0.9.10[modules]
         net-im/mcabber-module-tune"

DEPEND="${RDEPEND}"

src_install() {
	cmake-utils_src_install
}
