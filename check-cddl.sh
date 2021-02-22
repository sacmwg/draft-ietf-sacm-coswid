kdrfc -3 draft-ietf-sacm-coswid.md
LANG=C xpath draft-ietf-sacm-coswid.xml "//sourcecode[@type='CDDL']/text()" >.extracted.cddl
cddl .extracted.cddl g
