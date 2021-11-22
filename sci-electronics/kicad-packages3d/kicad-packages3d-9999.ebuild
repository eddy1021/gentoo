# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs cmake

DESCRIPTION="Electronic Schematic and PCB design tools 3D package libraries"
HOMEPAGE="https://gitlab.com/kicad/libraries/kicad-packages3D"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/kicad-packages3D.git"
	inherit git-r3
	# x11-misc-util/macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	MY_PV="${PV/_rc/-rc}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://gitlab.com/kicad/libraries/${PN}/-/archive/${MY_PV}/${MY_P}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN/3d/3D}-${MY_PV}" # check for directory hash
	KEYWORDS="~amd64 ~x86 ~arm64"
fi

IUSE="+occ"
LICENSE="CC-BY-SA-4.0"
SLOT="0"

DEPEND=""
RDEPEND=">=sci-electronics/kicad-5.99[occ=]"

CHECKREQS_DISK_BUILD="11G"
