# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The Original ATT Korn Shell"
HOMEPAGE="http://www.kornshell.com/"

MY_PV=$(ver_rs 3 - 4 .)
SRC_URI="https://github.com/ksh93/${PN}/archive/v${MY_PV}/ksh-v${MY_PV}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	# disable register for debugging
	sed -i 1i"#define register" src/lib/libast/include/ast.h || die
}

src_compile() {
	local extraflags=(
		"-Wno-unknown-pragmas"
		"-Wno-missing-braces"
		"-Wno-unused-result"
		"-Wno-return-type"
		"-Wno-int-to-pointer-cast"
		"-Wno-parentheses"
		"-Wno-unused"
		"-Wno-unused-but-set-variable"
		"-Wno-cpp"
		"-Wno-maybe-uninitialized"
		"-Wno-lto-type-mismatch"
		"-P"
	)
	append-cflags $(test-flags-CC ${extraflags[@]})
	filter-flags '-fdiagnostics-color=always' # https://github.com/ksh93/ksh/issues/379
	export CCFLAGS="${CFLAGS} -fno-strict-aliasing"

	tc-export AR CC LD NM

	sh bin/package make SHELL="${BROOT}"/bin/sh || die
}

src_test() {
	# test tries to catch IO error
	addwrite /proc/self/mem

	# arith.sh uses A for tests
	unset A

	sh bin/shtests --compile || die
}

src_install() {
	local myhost="$(sh bin/package host)"
	cd "arch/${myhost}" || die

	into /
	dobin bin/ksh
	dosym ksh /bin/rksh

	newman man/man1/sh.1 ksh.1
}
