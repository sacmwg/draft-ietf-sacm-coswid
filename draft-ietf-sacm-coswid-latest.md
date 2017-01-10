---
title: Concise Software Identifiers
abbrev: COSWID
docname: draft-ietf-sacm-coswid-latest
stand_alone: true
ipr: trust200902
area: Security
wg: SACM Working Group
kw: Internet-Draft
cat: std
pi:
  toc: yes
  sortrefs: yes
  symrefs: yes

author:
- ins: H. Birkholz
  name: Henk Birkholz
  org: Fraunhofer SIT
  abbrev: Fraunhofer SIT
  email: henk.birkholz@sit.fraunhofer.de
  street: Rheinstrasse 75
  code: '64295'
  city: Darmstadt
  country: Germany
- ins: J. Fitzgerald-McKay
  name: Jessica Fitzgerald-McKay
  org: Department of Defense
  email: jmfitz2@nsa.gov
  street: 9800 Savage Road
  city: Ft. Meade
  region: Maryland
  country: USA
- ins: C. Schmidt
  name: Charles Schmidt
  org: The MITRE Corporation
  email: cmschmidt@mitre.org
  street: 202 Burlington Road
  city: Bedford
  region: Maryland
  code: '01730'
  country: USA
- ins: D. Waltermire
  name: David Waltermire
  org: National Institute of Standards and Technology
  abbrev: NIST
  email: david.waltermire@nist.gov
  street: 100 Bureau Drive
  city: Gaithersburg
  region: Maryland
  code: '20877'
  country: USA

normative:
  RFC2119:
  RFC7049: cbor
  X.1520:
    title: "Recommendation ITU-T X.1520 (2014), Common vulnerabilities and exposures"
    date: 2011-04-20
  SAM:
    title: >
      Information technology - Software asset management - Part 5: Overview and vocabulary
    date: 2013-11-15
    seriesinfo:
      ISO/IEC: 19770-5:2013
  SWID:
    title: >
      Information technology - Software asset management - Part 2: Software identification tag'
    date: 2015-10-01
    seriesinfo:
      ISO/IEC: 19770-2:2015
  I-D.ietf-cose-msg: cose-msg

informative:
  I-D.greevenbosch-appsawg-cbor-cddl: cddl
  I-D-birkholz-tuda:
    -: tuda
    title: Time-Based Uni-Directional Attestation
    date: 2017-01-09
    seriesinfo:
      Internet-Draft: draft-birkholz-tuda-03
    author:
      - ins: A. Fuchs
        name: Andreas Fuchs
      - ins: H. Birkholz
        name: Henk Birkholz
      - ins: I. McDonald
        name: Ira E McDonald
      - ins: C. Bormann
        name: Carsten Bormann

--- abstract 

This document defines a concise representation of ISO 19770-2:2015 Software Identifiers (SWID tags) that is interoperable with the XML schema definition of ISO 19770-2:2015. 

--- middle

# Introduction

SWID tags have several use-applications including but not limited to:

* Software Inventory Management, a part of the Software Asset Management {{SAM}} process, which requires an accurate list of discernible deployed software instances.

* Vulnerability Assessment, which requires a semantic link between standardized vulnerability descriptions and IT-assets {{X.1520}}.

* Remote Attestation, which requires a link between golden (well-known) measurements and software instances {{-tuda}}.

SWID tags, as defined in ISO-19770-2:2015 {{SWID}}, provide a standardized format for a record that identifies and describes a specific release of a software product. Different software products, and even different releases of a particular software product, each have a different SWID tag record associated with them. In addition to defining the format of these records, ISO-19770-2:2015 defines requirements concerning the SWID tag lifecycle. Specifically, when a software product is installed on an endpoint, that product's SWID tag is also installed. Likewise, when the product is uninstalled or replaced, the SWID tag is deleted or replaced, as appropriate. As a result, ISO-19770-2:2015 describes a system wherein there is a correspondence between the set of installed software products on an endpoint, and the presence on that endpoint of the SWID tags corresponding to those products.

SWID tags are meant to be flexible and able to express a broad set of metadata about a software product. Moreover, there are multiple types of SWID tags, each providing different types of information. For example, a "corpus tag" is used to describe an application's installation image on an installation media, while a "patch tag" is meant to describe a patch that modifies some other application. While there are very few required fields in SWID tags, there are many optional fields that support different uses of these different types of tags. While a SWID tag that consisted only of required fields could be a few hundred bytes in size, a tag containing many of the optional fields could be many orders of magnitude larger.

This document defines a more concise representation of SWID tags in the Concise Binary Object Representation (CBOR) {{-cbor}}.  This is described via the CBOR Data Definition Language (CDDL) {{-cddl}}.  The resulting Concise SWID data definition is interoperable with the XML schema definition of ISO-19770-2:2015 {{SWID}}. The vocabulary, i.e., the CDDL names of the types and members used in the Concise SWID data definition, is mapped to more concise labels represented as small integers. The names used in the CDDL and the mapping to the CBOR representation using integer labels is based on the vocabulary of the XML attribute and element names defined in ISO-19770-2:2015.

Real-world instances of SWID tags can be fairly large, and the communication of SWID tags in use-applications such as those described earlier can cause a large amount of data to be transported. This can be larger than acceptable for constrained devices and networks. Concise SWID tags significantly reduce the amount of data transported as compared to a typical SWID tag. This reduction is enable through the use of CBOR, which maps human-readable labels of that content to more concise integer labels (indices). This allows SWID tags to be part of an enterprise security solution for a wider range of endpoints and environments.

## Requirements notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in RFC
2119, BCP 14 {{RFC2119}}.

# Concise SWID data definition

The following is a CDDL representation of the ISO-19770-2:2015 {{SWID}} XML schema definition of SWID tags. This representation includes all SWID tag fields and thus supports all SWID tag use cases. The CamelCase notation used in the XML schema definition is changed to hyphen-separated notation (e.g. ResourceCollection is named resource-collection in the Concise SWID data definition). The human-readable names of members are mapped to integer indices via a block of rules at the bottom of the Concise SWID data definition. The 48 character strings of the SWID vocabulary that would have to be stored or transported in full if using the original vocabulary are replaced.

~~~ CDDL

concise-software-identity = {
  global-attributes,
  ? entity-entry,
  ? evidence-entry,
  ? link-entry,
  ? software-meta-entry,
  ? payload-entry,
  ? any-element-entry,
  ? corpus,
  ? patch,
  ? media,
  swid-name,
  ? supplemental,
  tag-id,
  ? tag-version,
  ? version,
  ? version-scheme,
}

NMTOKEN = text
NMTOKENS = text

date-time = time
any-uri = text
label = text / int

any-attribute = (
  label => text / int / [ 2* text ] / [ 2* int ]
)

any-element-map = {
  global-attributes,
  * label => any-element-map / [ * any-element-map ],
} 

global-attributes = (
  ? lang,
  * any-attribute,
)

resource-collection = (
  ? directory-entry,
  ? file-entry,
  ? process-entry,
  ? resource-entry
)

file = {
  filesystem-item,
  ? size,
  ? version,
  ? file-hash,
}

filesystem-item = (
  global-attributes,
  ? key,
  ? location,
  fs-name,
  ? root,
)

directory = {
  filesystem-item,
  path-elements,
}

process = {
  global-attributes,
  process-name,
  ? pid,
}

resource = {
  global-attributes,
  type,
}

entity = {
  global-attributes,
  meta-elements,
  entity-name,
  ? reg-id,
  role,
  ? thumbprint,
}

evidence = {
  global-attributes,
  resource-collection,
  ? date,
  ? device-id,
}

link = {
  global-attributes,
  ? artifact,
  href,
  ? media,
  ? ownership,
  rel,
  ? type,
  ? use,
}

software-meta = {
  global-attributes,
  ? activation-status,
  ? channel-type,
  ? colloquial-version,
  ? description,
  ? edition,
  ? entitlement-data-required,
  ? entitlement-key,
  ? generator,
  ? persistent-id,
  ? product,
  ? product-family,
  ? revision,
  ? summary,
  ? unspsc-code,
  ? unspsc-version,
}

payload = {
  global-attributes,
  resource-collection,
}

tag-id = (0: text)
swid-name = (1: text)
entity-entry = (2: entity / [ * entity ])
evidence-entry = (3: evidence / [ * evidence ])
link-entry = (4: link / [ * link ])
software-meta-entry = (5: software-meta / [ * software-meta ])
payload-entry = (6: payload / [ * payload ])
any-element-entry = (7: any-element-map / [ * any-element-map ])
corpus = (8: bool)
patch = (9: bool)
media = (10: text)
supplemental = (11: bool)
tag-version = (12: integer)
version = (13: text)
version-scheme = (14: NMTOKEN)
lang = (15: text)
directory-entry = (16: directory / [ * directory ])
file-entry = (17: file / [ * file ])
process-entry = (18: process / [ * process ])
resource-entry = (19: resource / [ * resource ])
size = (20: integer)
key = (21: bool)
location = (22: text)
fs-name = (23: text)
root = (24: text)
path-elements = (25: { ? directory-entry,
                       ? file-entry,
                     }
                )
process-name = (26: text)
pid = (27: integer)
type = (28: text)
meta-elements = (29: any-element-map / [ * any-element-map ])
entity-name = (30: text)
reg-id = (31: any-uri)
role = (32: NMTOKENS)
thumbprint = (33: text)
date = (34: date-time)
device-id = (35: text)
artifact = (36: text)
href = (37: any-uri)
ownership = (38: "shared" / "private" / "abandon")
rel = (39: NMTOKEN)
use = (40: "optional" / "required" / "recommended")
activation-status = (41: text)
channel-type = (42: text)
colloquial-version = (43: text)
description = (44: text)
edition = (45: text)
entitlement-data-required = (46: bool)
entitlement-key = (47: text)
generator = (48: text)
persistent-id = (49: text)
product = (50: text)
product-family = (51: text)
revision = (52: text)
summary = (53: text)
unspsc-code = (54: text)
unspsc-version = (55: text)
file-hash = (56: [ hash-alg-id: int,
                   hash-value: bstr,
                 ]
            )

~~~

# Encoding hashes for Concise SWID tags

Concise SWID add explicit support for the representation of file-hashes using algorithms that are registered at the Named Information Hash Algorithm Registry via the file-hash item (label 56). The number used as a value for hash-alg-id refers the ID in the Named Information Hash Algorithm table.

# COSE signatures for Concise SWID tags

SWID tags, as defined in the ISO-19770-2:2015 XML schema, can include cryptographic signatures to protect the integrity of the SWID tag. In general, tags are signed by the tag creator (typically, although not exclusively, the vendor of the software product that the SWID tag identifies). Cryptographic signatures can make any modification of the tag detectable, which is especially important if the integrity of the tag is important, such as when the tag is providing golden measurements for files.

The ISO-19770-2:2015 XML schema uses XML DSIG to support cryptographic signatures. Concise SWID tags require a different signature scheme than this. COSE (CBOR Encoded Message Syntax) provides the required mechanism {{-cose-msg}}. Concise SWID can be wrapped in a COSE Single Signer Data Object (cose-sign1) that contains a single signature. The following CDDL defines a more restrictive subset of header attributes allowed by COSE tailored to suit the requirements of Concise SWID.

~~~ CDDL

signed-software-identity = #6.997(COSE-Sign1-coswid) ; see TBS7 in current COSE I-D

label = int / tstr  ; see COSE I-D 1.4.
values = any        ; see COSE I-D 1.4.

unprotected-signed-coswid-header = {
    1 => int,                   ; algorithm identifier
    3 => "application/coswid",  ; request for CoAP IANA registry to become an int
    * label => values,
}

protected-signed-coswid-header = {
    4 => bstr,                  ; key identifier
    * label => values,
}

COSE-Sign1-coswid = [
    protected: bstr .cbor protected-signed-coswid-header,
    unprotected: unprotected-signed-coswid-header,
    payload: bstr .cbor concise-software-identity,
    signature: bstr,
]

~~~

<!--  which will be addressed in a future iteration of this draft and most likely result in additional attributes to be included in the general Concise SWID data definition, e.g. signature-type (“compat”, “cose”, etc.). Note that, by their natures, cryptographic signatures will not remain valid if a SWID tag is translated from one representation to another. -->

#  IANA considerations

This document will include requests to IANA:

* Integer indices for SWID content attributes and information elements.
* Content-Type for CoAP to be used in COSE.

#  Security Considerations

SWID tags contain public information about software products and, as
such, do not need to be protected against disclosure on an endpoint.
Similarly, SWID tags are intended to be easily discoverable by
applications and users on an endpoint in order to make it easy to
identify and collect all of an endpoint's SWID tags.  As such, any
security considerations regarding SWID tags focus on the application
of SWID tags to address security challenges, and the possible
disclosure of the results of those applications.

A signed SWID tag whose signature is intact can be relied upon to be
unchanged since it was signed.  If the SWID tag was created by the
software author, this generally means that it has undergone no change
since the software application with which the tag is associated was
installed.  By implication, this means that the signed tag reflects
the software author's understanding of the details of that software
product.  This can be useful assurance when the information in the
tag needs to be trusted, such as when the tag is being used to convey
golden measurements.  By contrast, the data contained in unsigned
tags cannot be trusted to be unmodified.

SWID tags are designed to be easily added and removed from an
endpoint along with the installation or removal of software products.
On endpoints where addition or removal of software products is
tightly controlled, the addition or removal of SWID tags can be
similarly controlled.  On more open systems, where many users can
manage the software inventory, SWID tags may be easier to add or
remove.  On such systems, it may be possible to add or remove SWID
tags in a way that does not reflect the actual presence or absence of
corresponding software products.  Similarly, not all software
products automatically install SWID tags, so products may be present
on an endpoint without providing a corresponding SWID tag.  As such,
any collection of SWID tags cannot automatically be assumed to
represent either a complete or fully accurate representation of the
software inventory of the endpoint.  However, especially on devices
that more strictly control the ability to add or remove applications,
SWID tags are an easy way to provide an preliminary understanding of
that endpoint's software inventory.

Any report of an endpoint's SWID tag collection provides
information about the software inventory of that endpoint.  If such a
report is exposed to an attacker, this can tell them which software
products and versions thereof are present on the endpoint.  By
examining this list, the attacker might learn of the presence of
applications that are vulnerable to certain types of attacks.  As
noted earlier, SWID tags are designed to be easily discoverable by an
endpoint, but this does not present a significant risk since an
attacker would already need to have access to the endpoint to view
that information.  However, when the endpoint transmits its software
inventory to another party, or that inventory is stored on a server
for later analysis, this can potentially expose this information to
attackers who do not yet have access to the endpoint.  As such, it is
important to protect the confidentiality of SWID tag information that
has been collected from an endpoint, not because those tags
individually contain sensitive information, but because the
collection of SWID tags and their association with an endpoint
reveals information about that endpoint's attack surface.

Finally, both the ISO-19770-2:2015 XML schema definition and the
Concise SWID data definition allow for the construction of "infinite"
SWID tags or SWID tags that contain malicious content with the intend
if creating non-deterministic states during validation or processing of SWID tags. While software product vendors are unlikely to do this, SWID tags can be created by any party and the SWID tags collected from an endpoint could contain a mixture of vendor and non-vendor created tags. For this reason, tools that consume SWID tags ought to treat the tag contents as potentially malicious and should employ input sanitizing on the tags they ingest.

#  Acknowledgements

#  Change Log

Changes since adopted as a WG I-D -00:

* Removed redundant any-attributes originating from the ISO-19770-2:2015 XML schema definition
* Fixed broken multi-map members
* Introduced a more restrictive item (any-element-map) to represent custom maps, increased restriction on types for the any-attribute, accordingly
* Fixed X.1520 reference
* Minor type changes of some attributes (e.g. NMTOKENS)
* Added semantic differentiation of various name types (e,g. fs-name)

Changes from version 00 to version 01:

* Ambiguity between evidence and payload eliminated by introducing explicit members (while still allowing for "empty" swid tags)
* Added a relatively restrictive COSE envelope using cose_sign1 to define signed coswids (single signer only, at the moment)
* Added a defintion how to encode hashes that can be stored in the any-member using existing IANA tables to reference hash-algorithms

First version -00

# Contributors

--- back

<!--  LocalWords:  SWID verifier TPM filesystem discoverable
 -->
