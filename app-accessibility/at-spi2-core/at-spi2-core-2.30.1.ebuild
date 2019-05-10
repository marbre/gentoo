# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org meson multilib-minimal systemd virtualx xdg

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
IUSE="X gtk-doc +introspection"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 s390 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

RDEPEND="
	>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.36:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54.0:= )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

PATCHES=(
	# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
	"${FILESDIR}/${PN}-2.0.2-disable-teamspaces-test.patch"
)

multilib_src_configure() {
	local emesonargs=(
		-Denable_docs=$(multilib_native_usex gtk-doc true false)
		-Denable-introspection=$(multilib_native_usex introspection)
		-Denable-x11=$(usex X)
		-Dsystemd_user_dir="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	virtx meson_src_test
}

multilib_src_install() {
	meson_src_install
}
