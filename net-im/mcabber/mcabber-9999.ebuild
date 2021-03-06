# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
inherit flag-o-matic eutils mercurial

DESCRIPTION="A small Jabber console client with various features, like MUC, SSL, PGP"
HOMEPAGE="http://mcabber.com/"
EHG_REPO_URI="http://mcabber.com/hg"
S=hg/mcabber

LICENSE="GPL-2"
SLOT="0"

IUSE="crypt otr spell ssl modules"

LANGS="de en fr nl pl uk ru"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done;

RDEPEND="ssl? ( >=dev-libs/openssl-0.9.7-r1 )
	crypt? ( >=app-crypt/gpgme-1.0.0 )
	otr? ( >=net-libs/libotr-3.1.0 )
	spell? ( app-text/aspell )
	>=dev-libs/glib-2.0.0
	sys-libs/ncurses
	>=net-libs/loudmouth-1.4.3"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
cd $S
	./autogen.sh
	use crypt && append-flags -D_FILE_OFFSET_BITS=64 # bug #277888
	econf --with-gpgme-prefix=gpgme \
		$(use_enable crypt gpgme) \
		$(use_enable otr) \
		$(use_enable spell aspell) \
		$(use_with ssl) \
		$(use_enable modules) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
cd $S
	make install DESTDIR="${D}" || die "make install failed"
	# clean unneeded language documentation
	for i in ${LANGS}; do
		! use linguas_${i} && rm -rf "${D}"/usr/share/${PN}/help/${i}
	done

	dodoc AUTHORS ChangeLog NEWS README TODO mcabberrc.example
	dodoc doc/README_PGP.txt

	# contrib themes
	insinto /usr/share/${PN}/themes
	doins contrib/themes/*

	# contrib generic scripts
	exeinto /usr/share/${PN}/scripts
	doexe contrib/*.{pl,py,rb}

	# contrib event scripts
	exeinto /usr/share/${PN}/scripts/events
	doexe contrib/events/*
	dodir /usr/include/mcabber
	insinto /usr/include/mcabber
	sed 's!<gpgme.h>!"/usr/include/gpgme/gpgme.h"!;s!<config.h>!"/usr/include/mcabber/config.h"!' -i src/*.h
	doins mcabber/*.h
	doins *.h
}

pkg_postinst() {
	elog
	elog "MCabber requires you to create a subdirectory .mcabber in your home"
	elog "directory and to place a configuration file there."
	elog "An example mcabberrc was installed as part of the documentation."
	elog "To create a new mcabberrc based on the example mcabberrc, execute the"
	elog "following commands:"
	elog
	elog "  mkdir -p ~/.mcabber"
	elog "  bzcat ${ROOT}usr/share/doc/${PF}/mcabberrc.example.bz2 >~/.mcabber/mcabberrc"
	elog
	elog "Then edit ~/.mcabber/mcabberrc with your favorite editor."
	elog
	elog "As of MCabber version 0.8.2, there is also a wizard script"
	elog "with which you can create all necessary configuration options."
	elog "To use it, simply execute the following command (please note that you need"
	elog "to have dev-lang/ruby installed for it to work!):"
	elog
	elog "  ${ROOT}usr/share/${PN}/scripts/mcwizz.rb"
	elog
	elog
	elog "See the CONFIGURATION FILE and FILES sections of the mcabber"
	elog "manual page (section 1) for more information."
	elog
	elog "From version 0.9.0 on, MCabber supports PGP encryption of messages."
	elog "See README_PGP.txt for details."
	elog
	elog "Check out ${ROOT}usr/share/${PN} for contributed themes and event scripts."
	elog
}
