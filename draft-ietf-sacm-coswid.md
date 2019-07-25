---
title: Concise Software Identification Tags
abbrev: CoSWID
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
  BCP26: RFC8126
  BCP178: RFC6648
  RFC2119:
  RFC3629:
  RFC3986:
  RFC5198:
  RFC5646:
  RFC5892:
  RFC7049:
  RFC7252:
  RFC8126:
  RFC8152: cose-msg
  RFC8412:
  RFC8288:
  RFC8610:
  X.1520:
    title: "Recommendation ITU-T X.1520 (2014), Common vulnerabilities and exposures"
    date: 2011-04-20
  SAM:
    title: >
      Information technology - Software asset management - Part 5: Overview and vocabulary
    date: 2013-11-15
    seriesinfo:
      ISO/IEC: 19770-5:2015
  SWID:
    title: >
      Information technology - Software asset management - Part 2: Software identification tag
    date: 2015-10-01
    seriesinfo:
      ISO/IEC: 19770-2:2015
  SEMVER:
    target: https://semver.org/spec/v2.0.0.html
    title: Semantic Versioning 2.0.0
    author:
      -
        ins: T. Preston-Werner
        name: Tom Preston-Werner
  W3C.REC-xpath20-20101214: xpath
  W3C.REC-css3-mediaqueries-20120619: css3-mediaqueries
  W3C.REC-xmlschema-2-20041028: xml-schema-datatypes

informative:
  RFC4122:
  RFC8322: rolie
  RFC8520: mud
  I-D.birkholz-rats-tuda: tuda
  CamelCase:
    target: http://wiki.c2.com/?CamelCase
    title: UpperCamelCase
    date: 2014-08-29
  KebabCase:
    target: http://wiki.c2.com/?KebabCase
    title: KebabCase
    date: 2014-12-18
  SWID-GUIDANCE:
    target: https://doi.org/10.6028/NIST.IR.8060
    title: Guidelines for the Creation of Interoperable Software Identification (SWID) Tags
    author:
      -
        ins: D. Waltermire
        name: David Waltermire
        org: National Institute for Standards and Technology
      -
        ins: B. A. Cheikes
        name: Brant A. Cheikes
        org: The MITRE Corporation
      -
        ins: L. Feldman
        name: Larry Feldman
        org: G2, Inc
      -
        ins: G. Witte
        name: Greg Witte
        org: G2, Inc
    date: 2016-04
    seriesinfo:
      NISTIR: 8060

--- abstract

ISO/IEC 19770-2:2015 Software Identification (SWID) tags provide an extensible XML-based structure to identify and describe individual software components, patches, and installation bundles. SWID tag representations can be too large for devices with network and storage constraints. This document defines a concise representation of SWID tags: Concise SWID (CoSWID) tags. CoSWID supports the same features as SWID tags, as well as additional semantics that allow CoSWIDs to describe additional types of information, all in a more memory efficient format.

--- middle

# Introduction

SWID tags, as defined in ISO-19770-2:2015 {{SWID}}, provide a standardized
XML-based record format that identifies and describes a specific release of
software, a patch, or an installation bundle, which are referred to as software components in this document. Different software components, and even different releases of a
particular software component, each have a different SWID tag record associated
with them. SWID tags are meant to be flexible and able to express a broad set of metadata
about a software component.

SWID tags are used to support a number of processes including but not limited to:

- Software Inventory Management, a part of a Software Asset Management {{SAM}}
  process, which requires an accurate list of discernible deployed software
  components.

- Vulnerability Assessment, which requires a semantic link between standardized
  vulnerability descriptions and software components installed on IT-assets {{X.1520}}.

- Remote Attestation, which requires a link between reference integrity
  measurements (RIM) and security logs of measured software components
  {{-tuda}}.

While there are very few required fields in SWID tags, there are many optional
fields that support different uses. A
SWID tag consisting of only required fields might be a few hundred bytes in
size; however, a tag containing many of the optional fields can be many orders of
magnitude larger. Thus, real-world instances of SWID tags can be fairly large, and the communication of
SWID tags in usage scenarios, such as those described earlier, can cause a large
amount of data to be transported. This can be larger than acceptable for
constrained devices and networks. Concise SWID (CoSWID) tags significantly reduce the amount of
data transported as compared to a typical SWID tag. This reduction is enabled
through the use of the Concise
Binary Object Representation (CBOR) {{RFC7049}}, which maps the human-readable labels of SWID data items to
more concise integer labels (indices). The use of CBOR to express SWID information in CoSWID tags allows both CoSWID and SWID tags to be part of an
enterprise security solution for a wider range of endpoints and environments.

{: #intro-lifecycle}
## The SWID and CoSWID Tag Lifecycle

In addition to defining the format of a SWID tag record, ISO/IEC 19770-2:2015
defines requirements concerning the SWID tag lifecycle. Specifically, when a
software component is installed on an endpoint, that software component's SWID tag is also
installed. Likewise, when the software component is uninstalled or replaced, the SWID tag
is deleted or replaced, as appropriate. As a result, ISO/IEC 19770-2:2015 describes
a system wherein there is a correspondence between the set of installed software
components on an endpoint, and the presence of the corresponding SWID tags
for these components on that endpoint. CoSWIDs share the same lifecycle requirements
as a SWID tag.

The SWID specification and supporting guidance provided in NIST Internal Report (NISTIR) 8060: Guidelines for the Creation of Interoperable SWID Tags {{SWID-GUIDANCE}} defines four types of SWID tags: primary, patch, corpus, and supplemental. The following text is paraphrased from these sources.

1. Primary Tag - A SWID or CoSWID tag that identifies and describes an installed software component on an endpoint. A primary tag is intended to be installed on an endpoint along with the corresponding software component.
2. Patch Tag - A SWID or CoSWID tag that identifies and describes an installed patch that has made incremental changes to a software component installed on an endpoint. A patch tag is intended to be installed on an endpoint along with the corresponding software component patch.
3. Corpus Tag - A SWID or CoSWID tag that identifies and describes an installable software component in its pre-installation state. A corpus tag can be used to represent metadata about an installation package or installer for a software component, a software update, or a patch.
4. Supplemental Tag - A SWID or CoSWID tag that allows additional information to be associated with a referenced SWID tag. This allows tools and users to record their own metadata about a software component without modifying SWID primary or patch tags created by a software provider.

The type of a tag is determined by specific data elements, which are discussed in {{semantics-tag-type}}.

> Corpus, primary, and patch tags have similar functions in that they describe the existence and/or presence of different types of software components (e.g., software installers, software installations, software patches), and, potentially, different states of these software components. Supplemental tags have the same structure as other tags, but are used to provide information not contained in the referenced corpus, primary, and patch tags. All four tag types come into play at various points in the software lifecycle and support software management processes that depend on the ability to accurately determine where each software component is in its lifecycle.

~~~
                                  +------------+
                                  v            |
Software      Software        Software     Software      Software
Deployment -> Installation -> Patching  -> Upgrading  -> Removal

Corpus        Primary         Primary      xPrimary      xPrimary
Supplemental  Supplemental    Supplemental xSupplemental xSuplemental
                              Patch        xPatch
                                           Primary
                                           Supplemental
~~~
{: #fig-lifecycle title="Use of Tag Types in the Software Lifecycle"}

> {{fig-lifecycle}} illustrates the steps in the software lifecycle and the relationships among those lifecycle events supported by the four types of SWID and CoSWID tags. The figure identifies the types of tags that can be deployed and previously deployed tags that are typically removed (indicated by an "x" prefix) at each lifecycle stage, as follows:

> - Software Deployment. Before the software component is installed (i.e., pre-installation), and while the product is being deployed, a corpus tag provides information about the installation files and distribution media (e.g., CD/DVD, distribution package).
> - Software Installation. A primary tag will be installed with the software component (or subsequently created) to uniquely identify and describe the software component. Supplemental tags are created to augment primary tags with additional site-specific or extended information. While not illustrated in the figure, patch tags can also be installed during software installation to provide information about software fixes deployed along with the base software installation.
> - Software Patching. When a new patch is applied to the software component a new patch tag is provided, supplying details about the patch and its dependencies. While not illustrated in the figure, a corpus tag can also provide information about the patch installer and patching dependencies that need to be installed before the patch.
> - Software Upgrading. As a software component is upgraded to a new version, new primary and supplemental tags replace existing tags, enabling timely and accurate tracking of updates to software inventory. While not illustrated in the figure, a corpus tag can also provide information about the upgrade installer and dependencies that need to be installed before the upgrade.
> - Software Removal. Upon removal of the software component, relevant SWID tags are removed. This removal event can trigger timely updates to software inventory reflecting the removal of the product and any associated patch or supplemental tags.

As illustrated in the figure, supplemental tags can be associated with any corpus, primary, or patch tag to provide additional metadata about an installer, installed software, or installed patch respectively.

Understanding the use of CoSWIDs in the software lifecycle provides a basis for understanding the information provided in a CoSWID and the associated semantics of this information. Each of the different SWID and CoSWID tag types provide different sets of
information. For example, a "corpus tag" is used to
describe a software component's installation image on an installation media, while a
"patch tag" is meant to describe a patch that modifies some other software component.

## Concise SWID Format

This document defines the CoSWID tag format, which is based on CBOR. CBOR-based CoSWID tags offer a more concise representation of SWID information as compared to the XML-based SWID tag representation in ISO-19770-2:2015. The structure of a CoSWID is described via the Concise
Data Definition Language (CDDL) {{RFC8610}}. The resulting CoSWID data
definition is aligned to the information able to be expressed with the XML schema definition of ISO-19770-2:2015
{{SWID}}. This alignment allows both SWID and CoSWID tags to represent a common set of software component information and allows CoSWID tags to support the same uses as a SWID tag. To achieve this end, the CDDL representation includes every SWID tag field and attribute.

The vocabulary, i.e., the CDDL names of the types and members used in
the CoSWID data definition, are mapped to more concise labels represented as
small integer values. The names used in the CDDL data definition and the mapping to
the CBOR representation using integer labels is based on the vocabulary of the
XML attribute and element names defined in ISO/IEC 19770-2:2015.

## Requirements Notation

{::boilerplate bcp14}

# Concise SWID Data Definition

The following describes the general rules and processes for encoding data using CDDL representation. Prior familiarity with CBOR and CDDL concepts will be helpful in understanding this CoSWID data definition.

This section describes the rules by which SWID tag XML is represented in the CoSWID CDDL structure. The CamelCase {{CamelCase}} notation used in the XML schema definition is changed to a hyphen-separated
notation {{KebabCase}} (e.g. ResourceCollection is named resource-collection) in the CoSWID data definition.
This deviation from the original notation used in the XML representation reduces ambiguity when referencing
certain attributes in corresponding textual descriptions. An attribute referred to by its name in CamelCase
notation explicitly relates to XML SWID tags; an attribute referred to by its name in
KebabCase notation explicitly relates to CBOR CoSWID tags. This approach simplifies the
composition of further work that reference both XML SWID and CBOR CoSWID documents.

In most cases, mapping attribute names between SWID and CoSWID can be done automatically by converting between CamelCase and KebabCase attribute names. However, some CoSWID CDDL attribute names show greater variation relative to their corresponding SWID XML Schema attributes. This is done when the change improves clarity in the specification. For example the "name" and "version" SWID fields corresponds to the "software-name" and "software-version" CoSWID fields, respectively. As such, it is not always possible to mechanically translate between corresponding attribute names in the two formats. In such cases, a manual mapping will need to be used.

The 57 human-readable text labels of the CDDL-based CoSWID vocabulary are mapped to integer indices via a block of rules at the bottom of the definition. This allows a more concise integer-based form to be stored or transported, as compared to the less efficient text-based form of the original vocabulary.

In CBOR, an array is encoded using bytes that identify the array, and the array's length or stop point (see {{RFC7049}}). To make items that support 1 or more values, the following CDDL notion is used.

~~~ CDDL
_name_ = (_label_: _data_ / [ 2* _data_ ])
~~~

The CDDL rule above allows either a single data item or an array of 2 or more data values to be provided. When a singleton data value is provided, the CBOR markers for the array, array length, and stop point are not needed, saving bytes. When two or more data values are provided, these values are encoded as an array. This modeling pattern is used frequently in the CoSWID CDDL data definition to allow for more efficient encoding of singleton values.

The following subsections describe the different parts of the CoSWID model.

## Character Encoding

The CDDL "text" type is represented in CBOR as a major type 3, which represents "a string of Unicode characters that \[are\] encoded as UTF-8 {{RFC3629}}" (see {{RFC7049}} section 2.1). Thus both SWID and CoSWID use UTF-8 for the encoding of characters in text strings.

To ensure that UTF-8 character strings are able to be encodes/decoded and exchanged interoperably, text strings in CoSWID MUST be encoded consistent with the Net-Unicode definition defined in {{RFC5198}}.

All names registered with IANA according to requirements in section {{iana-value-registries}} also need to be valid according to the XML Schema NMToken data type (see {{-xml-schema-datatypes}} section 3.3.4) to ensure compatibility with the SWID specification where these names are used.

{: #model-extension}
## Concise SWID Extensions

The CoSWID data definition contains two features that are not included in the SWID data definition on which it is based. These features are:

- The explicit definition of types for some attributes in the ISO-19770-2:2015 XML representation that are typically represented by
  the "any attribute" in the SWID model. These are
  covered in {{model-global-attributes}}.

- The inclusion of extension points in the CoSWID data definition using CDDL sockets (see {{RFC8610}} section 3.9). The use of CDDL sockets allow for well-formed extensions to be defined in supplementary CDDL descriptions that support additional uses of CoSWID tags that go beyond the original scope of ISO-19770-2:2015 tags. This extension mechanism can also be used to update the CoSWID format as revisions to ISO-19770-2 are published.

The following CDDL sockets (extension points) are defined in this document, which allow the addition of new information structures to their respective CDDL groups.

| Map Name | CDDL Socket | Defined in
|---
| concise-swid-tag | $$coswid-extension | {{model-concise-swid-tag}}
| entity-entry | $$entity-extension | {{model-entity}}
| link-entry | $$link-extension | {{model-link}}
| software-meta-entry | $$meta-extension | {{model-software-meta}}
| file-entry | $$file-extension | {{model-resource-collection}}
| directory-entry | $$directory-extension | {{model-resource-collection}}
| process-entry | $$process-extension | {{model-resource-collection}}
| resource-entry | $$resource-extension | {{model-resource-collection}}
| payload-entry | $$payload-extension  | {{model-payload}}
| evidence-entry | $$evidence-extension | {{model-evidence}}
{: #tbl-model-extension-group-sockets title="CoSWID CDDL Group Extension Points"}

The CoSWID Items Registry defined in {{iana-coswid-items}} provides a registration mechanism allowing new items, and their associated index values, to be added to the CoSWID model through the use of the CDDL sockets described in the table above. This registration mechanism provides for well-known index values for data items in CoSWID extensions, allowing these index values to be recognized by implementations supporting a given extension.

The following additional CDDL sockets are defined in this document to allow for adding new values to corresponding type-choices (i.e. to represent enumerations) via custom CDDL data definitions.

| Enumeration Name | CDDL Socket | Defined in
|---
| version-scheme | $version-scheme | {{indexed-version-scheme}}
| role | $role | {{indexed-entity-role}}
| ownership | $ownership | {{indexed-link-ownership}}
| rel | $rel | {{indexed-link-rel}}
| use | $use | {{indexed-link-use}}
{: #tbl-model-extension-enum-sockets title="CoSWID CDDL Enumeration Extension Points"}

A number of SWID/CoSWID value registries are also defined in {{iana-value-registries}} that allow new values to be registered with IANA for the enumerations above. This registration mechanism supports the definition of new well-known index values and names for new enumeration values used by both SWID and CoSWID. This registration mechanism allows new standardized enumerated values to be shared between both specifications (and implementations) over time, and references to the IANA registries will be added to the next revision of {{SWID}}.

{: #model-concise-swid-tag}
## The concise-swid-tag Group

The CDDL data definition for the root concise-swid-tag map is as follows and this rule and its constraints MUST be followed when creating or validating a CoSWID tag:

~~~ CDDL
concise-swid-tag = {
  global-attributes,
  tag-id => text / bstr .size 16,
  tag-version => integer,
  ? corpus => bool,
  ? patch => bool,
  ? supplemental => bool,
  software-name => text,
  ? software-version => text,
  ? version-scheme => $version-scheme,
  ? media => text,
  ? software-meta =>  software-meta-entry / [ 2* software-meta-entry ],
  entity => entity-entry / [ 2* entity-entry ],
  ? link => link-entry / [ 2* link-entry ],
  ? (( payload => payload-entry ) // ( evidence => evidence-entry )),
  * $$coswid-extension
}

tag-id = 0
software-name = 1
entity = 2
evidence = 3
link = 4
software-meta = 5
payload = 6
corpus = 8
patch = 9
media = 10
supplemental = 11
tag-version = 12
software-version = 13
version-scheme = 14

$version-scheme /= multipartnumeric
$version-scheme /= multipartnumeric-suffix
$version-scheme /= alphanumeric
$version-scheme /= decimal
$version-scheme /= semver
$version-scheme /= uint / text
multipartnumeric = 1
multipartnumeric-suffix = 2
alphanumeric = 3
decimal = 4
semver = 16384
~~~

The following describes each member of the concise-swid-tag root map.

- global-attributes: A list of items including an optional language definition to support the
processing of text-string values and an unbounded set of any-attribute items. Described in {{model-global-attributes}}.

- tag-id (index 0): A 16 byte binary string or textual identifier uniquely referencing a software component. The tag
identifier MUST be globally unique. If represented as a 16 byte binary string, the identifier MUST be a valid universally unique identifier as defined by {{RFC4122}}. There are no strict guidelines on
how this identifier is structured, but examples include a 16 byte GUID (e.g.
class 4 UUID) {{RFC4122}}, or a text string appended to a DNS domain name to ensure uniqueness across organizations.

- tag-version (index 12): An integer value that indicate the specific release revision of the tag. Typically, the initial value of this field is set to 0 and the value is monotonically increased for subsequent tags produced for the same software component release. This value allows a CoSWID tag producer to correct an incorrect tag previously released without indicating a change to the underlying software component the tag represents. For example, the tag version could be changed to add new metadata, to correct a broken link, to add a missing payload entry, etc. When producing a revised tag, the new tag-version value MUST be greater than the old tag-version value.

- corpus (index 8): A boolean value that indicates if the tag identifies and describes an installable software component in its pre-installation state. Installable software includes a installation package or installer for a software component, a software update, or a patch. If the CoSWID tag represents installable software, the corpus item MUST be set to "true". If not provided, the default value MUST be considered "false".

- patch (index 9): A boolean value that indicates if the tag identifies and describes an installed patch that has made incremental changes to a software component installed on an endpoint. Typically, an installed patch has made a set of file modifications to pre-installed software and does not alter the version number or the descriptive metadata of an installed software
component. If a CoSWID tag is for a patch, the patch item MUST be set to "true". If not provided, the default value MUST be considered "false".

  Note: If the software component's version number is modified, then the correct course of action would be to replace the previous primary tag for the component with a new primary tag that reflected this new version. In such a case, the new tag would have a patch item value of "false" or would omit this item completely.

- supplemental (index 11): A boolean value that indicates if the tag is providing additional information to be associated with another referenced SWID or CoSWID tag. This allows tools and users to record their own metadata about a software component without modifying SWID primary or patch tags created by a software provider. If a CoSWID tag is a supplemental tag, the supplemental item MUST be set to "true". If not provided, the default value MUST be considered "false".

- software-name (index 1): This textual item provides the software component's name. This name is likely the same name that would appear in a package management tool.

- software-version (index 13): A textual value representing the specific release or development version of the software component.

- version-scheme (index 14): An integer or textual value representing the versioning scheme used for the software-version item. If an integer value is used it MUST be an index value in the range -256 to 65535. Integer values in the range -256 to -1 are reserved for testing and use in closed environments (see section {{iana-private-use}}). Integer values in the range 0 to 65535 correspond to registered entries in the IANA "SWID/CoSWID Version Scheme Value" registry (see section {{iana-version-scheme}}. If a string value is used it MUST be a private use name as defined in section {{iana-private-use}}. String values based on a Version Scheme Name from the IANA "SWID/CoSWID Version Scheme Value" registry MUST NOT be used, as these values are less concise than their index value equivalent.

- media (index 10): This text value is a hint to the tag consumer to understand what target platform this tag
applies to. This item represents a
query as defined by the W3C Media Queries Recommendation (see {{-css3-mediaqueries}}).

- software-meta (index 5): An open-ended map of key/value data pairs.
A number of predefined keys can be used within this item providing for
common usage and semantics across the industry.  Use of this map allows any additional
attribute to be included in the tag. It is expected that industry groups will use a common set of attribute names to allow for interoperability within their communities. Described in {{model-software-meta}}.

- entity (index 2): Provides information about one or more organizations responsible for producing the CoSWID tag, and producing or releasing the software component referenced by this
CoSWID tag. Described in {{model-entity}}.

- link (index 4): Provides a means to establish relationship arcs between the tag and another items. A given link can be used to establish the relationship between tags or to reference another resource that is related to the
CoSWID tag, e.g.
vulnerability database association, ROLIE feed {{-rolie}}, MUD resource {{-mud}}, software download location, etc).
This is modeled after the HTML "link" element.  Described in {{model-link}}.

- payload (index 6): This item represents a collection of software artifacts (described by child items) that compose the target software. For example, these artifacts could be the files included with an installer for a corpus tag or installed on an endpoint when the software component
is installed for a primary or patch tag. The artifacts listed in a payload may be a superset of the software artifacts that are actually installed. Based on user selections at install time,
an installation might not include every artifact that could be created or executed on the
endpoint when the software component is installed or run. Described in {{model-payload}}.

- evidence-entry (index 3): This item can be used to record the results of a software discovery process used to identify untagged software on an endpoint or to represent indicators for why software is believed to be installed on the endpoint. In either case, a CoSWID tag can be created by the tool performing an analysis of the software components installed on the endpoint. Described in {{model-evidence}}.

- $$coswid-extension: This CDDL socket is used to add new information structures to the concise-swid-tag root map. See {{model-extension}}.

##  concise-swid-tag Co-constraints

The following co-constraints apply to the information provided in the concise-swid-tag group.

- The patch and supplemental items MUST NOT both be set to "true".

- If the patch item is set to "true", the tag SHOULD contain at least one link item (see section {{model-link}}) with both the rel(ation) item value of "patches" and an href item specifying an association with the software that was patched.

- If the supplemental item is set to "true", the tag SHOULD contain at least one link item with both the rel(ation) item value of "supplements" and an href item specifying an association with the software that is supplemented.

- If all of the corpus, patch, and supplemental items are "false", or if the corpus item is set to "true", then a software-version item MUST be included with a value set to the version of the software component. This ensures that primary and corpus tags have an identifiable software version.

{: #model-global-attributes}
## The global-attributes Group

The global-attributes group provides a list of items, including an optional
language definition to support the processing of text-string values, and an
unbounded set of any-attribute items allowing for additional items to be
provided as a general point of extension in the model.

The CDDL for the global-attributes follows:

~~~ CDDL
global-attributes = (
  ? lang,
  * any-attribute,
)

any-attribute = (
  label => text / int / [ 2* text ] / [ 2* int ]
)

label = text / int
~~~

The following describes each child item of this group.

- lang (index 15): A textual language tag  that
conforms with IANA "Language Subtag Registry" {{RFC5646}}. The context of the specified language applies to all sibling and descendant textual values, unless a descendant object has defined a different language tag. Thus, a new context is established when a descendant object redefines a new language tag. All textual values within a given context MUST be considered expressed in the specified language.

- any-attribute: This sub-group provides a means to include arbitrary information
via label ("key") value pairs. Labels can be either a single integer or text string. Values can be a single integer, a text string, or an array of integers or text strings.

{: #model-entity}
## The entity-entry Group

The CDDL for the entity-entry group follows:

~~~ CDDL
entity-entry = {
  global-attributes,
  entity-name => text,
  ? reg-id => any-uri,
  role => $role / [ 2* $role ],
  ? thumbprint => hash-entry,
  * $$entity-extension,
}
entity-name = 31
reg-id = 32
role = 33
thumbprint = 34

$role /= tag-creator
$role /= software-creator
$role /= aggregator
$role /= distributor
$role /= licensor
$role /= uint / text
tag-creator=1
software-creator=2
aggregator=3
distributor=4
licensor=5
~~~

The following describes each child item of this group.

- global-attributes: The global-attributes group described in {{model-global-attributes}}.

- entity-name (index 32): The textual name of the organizational entity claiming the roles specified by the role item for the CoSWID tag.

- reg-id (index 32): The registration id value is intended to uniquely identify a naming authority in a
given scope (e.g. global, organization, vendor, customer, administrative domain,
etc.) for the referenced entity. The value of an
registration ID MUST be a RFC 3986 URI. The scope SHOULD be the scope of an
organization. In a given scope, the registration id MUST be used consistently for CoSWID tag production.

- role (index 33): An integer or textual value representing the relationship(s) between the entity, and this tag or the referenced software component. If an integer value is used it MUST be an index value in the range -256 to 255. Integer values in the range -256 to -1 are reserved for testing and use in closed environments (see section {{iana-private-use}}). Integer values in the range 0 to 255 correspond to registered entries in the IANA "SWID/CoSWID Entity Role Value" registry (see section {{iana-entity-role}}. If a string value is used it MUST be a private use name as defined in section {{iana-private-use}}. String values based on a Role Name from the IANA "SWID/CoSWID Entity Role Value" registry MUST NOT be used, as these values are less concise than their index value equivalent.

  The following additional requirements exist for the use of the "role" item:

  - An entity item MUST be provided with the role of "tag-creator" for every CoSWID tag. This indicates the organization that created the CoSWID tag.
  - An entity item SHOULD be provided with the role of "software-creator" for every CoSWID tag, if this information is known to the tag creator. This indicates the organization that created the referenced software component.

- thumbprint (index 34): The value of the thumbprint item provides an integer-based hash algorithm identifier (hash-alg-id) and a byte string value (hash-value) that contains the corresponding hash value (i.e. the
thumbprint) of the signing entity's public key certificate. This provides an indicator of which entity signed the CoSWID tag, which will typically be the tag creator. If the hash-alg-id is not known, then the integer value "0" MUST be used. This ensures parity between the SWID tag specification {{SWID}}, which does not allow an algorithm to be identified for this field. See {{model-hash-entry}} for more details on the use of the hash-entry data structure.

- $$entity-extension: This CDDL socket can be used to extend the entity-entry group model. See {{model-extension}}.

{: #model-link}
## The link-entry Map

The CDDL for the link-entry map follows:

~~~ CDDL
link-entry = {
  global-attributes,
  ? artifact => text,
  href => any-uri,
  ? media => text,
  ? ownership => $ownership,
  rel => $rel,
  ? media-type => text,
  ? use => $use,
  * $$link-extension,
}
media = 10
artifact = 37
href = 38
ownership = 39
rel = 40
media-type = 41
use = 42

$ownership /= shared
$ownership /= private
$ownership /= abandon
$ownership /= uint / text
shared=1
private=2
abandon=3

$rel /= ancestor
$rel /= component
$rel /= feature
$rel /= installationmedia
$rel /= packageinstaller
$rel /= parent
$rel /= patches
$rel /= requires
$rel /= see-also
$rel /= supersedes
$rel /= supplemental
$rel /= uint / text
ancestor=1
component=2
feature=3
installationmedia=4
packageinstaller=5
parent=6
patches=7
requires=8
see-also=9
supersedes=10
supplemental=11

$use /= optional
$use /= required
$use /= recommended
$use /= uint / text
optional=1
required=2
recommended=3
~~~

The following describes each member of this map.

- global-attributes: The global-attributes group described in {{model-global-attributes}}.

- artifact (index: 37): To be used with rel="installation-media", this item's value provides the path to the installer executable or script that can be run to launch the referenced installation. Links with the same artifact name MUST be considered mirrors of each other, allowing the installation media to be acquired from any of the described sources.

- href (index 38): A URI for the referenced resource. The "href" item's value can be, but is not limited to, the following (which is a slightly modified excerpt from {{SWID}}):
  - If no URI scheme is provided, then the URI is to be interpreted as being relative to the URI of the CoSWID tag. For example, "./folder/supplemental.coswid".
  - a physical resource location with any acceptable URI scheme (e.g., file:// http:// https:// ftp://)
  - a URI with "swid:" as the scheme refers to another SWID or CoSWID by the referenced tag's tag-id. This
  URI needs to be resolved in the context of the endpoint by software
  that can lookup other SWID or CoSWID tags. For example, "swid:2df9de35-0aff-4a86-ace6-f7dddd1ade4c" references the tag with the tag-id value "2df9de35-0aff-4a86-ace6-f7dddd1ade4c".
  - a URI with "swidpath:" as the scheme, which refers to another CoSIWD via an
  XPATH query. This URI would need to be resolved in the context of the system
  entity via software components that can lookup other CoSWID tags and
  select the appropriate tag based on an XPATH query {{-xpath}}.

    Examples include:

    - swidpath://SoftwareIdentity\[Entity/@regid='http://contoso.com'\] would retrieve all SWID or CoSWID tags that include an entity where the regid is "Contoso"
    - swidpath://SoftwareIdentity\[Meta/@persistentId='b0c55172-38e9-4e36-be86-92206ad8eddb'\] would match all SWID or CoSWID tags with the persistent-id value "b0c55172-38e9-4e36-be86-92206ad8eddb"

- media (index 10): A hint to the consumer of the link to what target platform the link is applicable to. This item represents a
query as defined by the W3C Media Queries Recommendation (see {{-css3-mediaqueries}}). See also media defined in {{model-concise-swid-tag}}.

- ownership (index 39): An integer or textual value used when the "href" item references another software component to indicate the degree of ownership between the software component referenced by the COSWID tag and the software component referenced by the link. If an integer value is used it MUST be an index value in the range -256 to 255. Integer values in the range -256 to -1 are reserved for testing and use in closed environments (see section {{iana-private-use}}). Integer values in the range 0 to 255 correspond to registered entries in the IANA "SWID/CoSWID Link Ownership Value" registry (see section {{iana-link-ownership}}. If a string value is used it MUST be a private use name as defined in section {{iana-private-use}}. String values based on a Ownership Type Name from the IANA "SWID/CoSWID Link Ownership Value" registry MUST NOT be used, as these values are less concise than their index value equivalent.

- rel (index 40): An integer or textual value that identifies the relationship between this CoSWID and the target resource identified by the "href" item. If an integer value is used it MUST be an index value in the range -256 to 65535. Integer values in the range -256 to -1 are reserved for testing and use in closed environments (see section {{iana-private-use}}). Integer values in the range 0 to 65535 correspond to registered entries in the IANA "SWID/CoSWID Link Relationship Value" registry (see section {{iana-link-rel}}. If a string value is used it MUST be either a private use name as defined in section {{iana-private-use}} or a "Relation Name" from the IANA "Link Relation Types" registry: https://www.iana.org/assignments/link-relations/link-relations.xhtml as defined by {{RFC8288}}. When a string value defined in the IANA "SWID/CoSWID Link Relationship Value" registry matches a Relation Name defined in the IANA "Link Relation Types" registry, the index value in the IANA "SWID/CoSWID Link Relationship Value" registry MUST be used instead, as this relationship has a specialized meaning in the context of a SWID/CoSWID tag. String values based on a Relationship Type Name from the IANA "SWID/CoSWID Link Relationship Value" registry MUST NOT be used, as these values are less concise than their index value equivalent.

- media-type (index 41): A link can point to arbitrary resources on the endpoint, local network, or Internet using the href item. Use of this item supplies the resource consumer with a hint of what type of resource to expect. Media types are identified by referencing a "Name" from the IANA "Media Types" registry: http://www.iana.org/assignments/media-types/media-types.xhtml.

- use (index 42): An integer or textual value used to determine if the referenced software component has to be installed before installing the software component identified by the COSWID tag. If an integer value is used it MUST be an index value in the range -256 to 255. Integer values in the range -256 to -1 are reserved for testing and use in closed environments (see section {{iana-private-use}}). Integer values in the range 0 to 255 correspond to registered entries in the IANA "Link Use Value Value" registry (see section {{iana-link-use}}. If a string value is used it MUST be a private use name as defined in section {{iana-private-use}}. String values based on an Link Use Type Name from the IANA "SWID/CoSWID Link Use Value" registry MUST NOT be used, as these values are less concise than their index value equivalent.

- $$link-extension: This CDDL socket can be used to extend the link-entry map model. See {{model-extension}}.

{: #model-software-meta}
## The software-meta-entry Map

The CDDL for the software-meta-entry map follows:

~~~ CDDL
software-meta-entry = {
  global-attributes,
  ? activation-status => text,
  ? channel-type => text,
  ? colloquial-version => text,
  ? description => text,
  ? edition => text,
  ? entitlement-data-required => bool,
  ? entitlement-key => text,
  ? generator => text,
  ? persistent-id => text,
  ? product => text,
  ? product-family => text,
  ? revision => text,
  ? summary => text,
  ? unspsc-code => text,
  ? unspsc-version => text,
  * $$meta-extension,
}
activation-status = 43
channel-type = 44
colloquial-version = 45
description = 46
edition = 47
entitlement-data-required = 48
entitlement-key = 49
generator = 50
persistent-id = 51
product = 52
product-family = 53
revision = 54
summary = 55
unspsc-code = 56
unspsc-version = 57
~~~

The following describes each child item of this group.

- global-attributes: The global-attributes group described in {{model-global-attributes}}.

- activation-status (index 43): A textual value that identifies how the software component has been activated, which might relate to specific terms and conditions for its use (e.g. Trial, Serialized, Licensed, Unlicensed, etc) and relate to an entitlement.  This attribute is typically used in supplemental tags as it contains information that might be selected during a specific install.

- channel-type (index 44): A textual value that identfies which sales, licensing, or marketing channel the software component has been targeted for (e.g. Volume, Retail, OEM, Academic, etc). This attribute is typically used in supplemental tags as it contains information that might be selected during a specific install.

- colloquial-version (index 45): A textual value for the software component's informal or colloquial version. Examples may include a year value, a major version number, or similar value that are used to identify a group of specific software component releases that are part of the same release/support cycle. This version can be the same through multiple releases of a software component, while the software-version specified in the concise-swid-tag group is much more specific and will change for each software component release. This version is intended to be used for string comparison only and is not intended to be used to determine if a specific value is earlier or later in a sequence.

- description (index 46): A textual value that provides a detailed description of the software component. This value MAY be multiple paragraphs separated by CR LF characters as described by {{RFC5198}}.

- edition (index 47): A textual value indicating that the software component represents a functional variation of the code base used to support multiple software components. For example, this item can be used to differentiate enterprise, standard, or professional variants of a software component.

- entitlement-data-required (index 48): A boolean value that can be used to determine if accompanying proof of entitlement is needed when a software license reconciliation process is performed.

- entitlement-key (index 49): A vendor-specific textual key that can be used to identify and establish a relationship to an entitlement. Examples of an entitlement-key might include a serial number, product key, or license key. For values that relate to a given software component install (i.e., license key), a supplemental tag will typically contain this information. In other cases, where a general-purpose key can be provided that applies to all possible installs of the software component on different endpoints, a primary tag will typically contain this information.

- generator (index 50): The name (or tag-id) of the software component that created the CoSWID tag. If the generating software component has a SWID or CoSWID tag, then the tag-id for the generating software component SHOULD be provided.

- persistent-id (index 51): A globally unique identifier used to identify a set of software components that are related. Software components sharing the same persistent-id can be different versions. This item can be used to relate software components, released at different points in time or through different release channels, that may not be able to be related through use of the link item.

- product (index 52): A basic name for the software component that can be common across multiple tagged software components (e.g., Apache HTTPD).

- product-family (index 53): A textual value indicating the software components overall product family.  This should be used when multiple related software components form a larger capability that is installed on multiple different endpoints. For example, some software families may consist of server, client, and shared service components that are part of a larger capability. Email systems, enterprise applications, backup services, web conferencing, and similar capabilities are examples of families. Use of this item is not intended to represent groups of software that are bundled or installed together. The persistent-id or link items SHOULD be used to relate bundled software components.

- revision (index 54): A string value indicating an informal or colloquial release version of the software. This value can provide a different version value as compared to the software-version specified in the concise-swid-tag group. This is useful when one or more releases need to have an informal version label that differs from the specific exact version value specified by software-version. Examples can include SP1, RC1, Beta, etc.

- summary (index 55): A short description of the software component. This MUST be a single sentence suitable for display in a user interface.

- unspsc-code (index 56): An 8 digit UNSPSC classification code for the software component. For more information see https://www.unspsc.org/.

- unspsc-version (index 57): The version of UNSPSC used to define the unspsc-code value.

- $$meta-extension: This CDDL socket can be used to extend the software-meta-entry group model. See {{model-extension}}.

## The Resource Collection Definition

{: #model-hash-entry}
### The hash-entry Array

CoSWID adds explicit support for the representation of hash entries using algorithms that are
registered in the IANA "Named Information Hash Algorithm Registry" using the hash-entry member (label 58).

~~~~ CDDL
hash-entry = [ hash-alg-id: int, hash-value: bytes ]
~~~~

The number used as a value for hash-alg-id MUST refer an ID in the "Named Information Hash Algorithm Registry" (see https://www.iana.org/assignments/named-information/named-information.xhtml); other hash algorithms MUST NOT be used. The hash-value MUST represent the raw hash value of the hashed resource generated using the hash algorithm indicated by the hash-alg-id.

{: #model-resource-collection}
### The resource-collection Group

A list of items both used in evidence (created by a software discovery process) and
payload (installed in an endpoint) content of a CoSWID tag document to
structure and differentiate the content of specific CoSWID tag types. Potential
content includes directories, files, processes, or resources.

The CDDL for the resource-collection group follows:

~~~ CDDL
resource-collection = (
  ? directory => directory-entry,
  ? file => file-entry,
  ? process => process-entry,
  ? resource => resource-entry,
)

filesystem-item = (
  global-attributes,
  ? key => bool,
  ? location => text,
  fs-name => text,
  ? root => text,
)

path-elements-entry = [ [ * file-entry ],
                        [ * directory-entry ],
                      ]

file-entry = {
  filesystem-item,
  ? size => integer,
  ? file-version => text,
  ? hash => hash-entry,
  * $$file-extension
}

directory-entry = {
  filesystem-item,
  path-elements => path-elements-entry,
  * $$directory-extension
}

process-entry = {
  global-attributes,
  process-name => text,
  ? pid => integer,
  * $$process-extension
}

resource-entry = {
  global-attributes,
  type => text,
  * $$resource-extension
}

directory = 16
file = 17
process = 18
resource = 19
size = 20
file-version = 21
key = 22
location = 23
fs-name = 24
root = 25
path-elements = 26
process-name = 27
pid = 28
type = 29
~~~

The following describes each member of the groups and maps illustrated above.

- filesystem-item: A list of common items used for representing the filesystem root, relative location, name, and significance of a file or directory item.

- global-attributes: The global-attributes group described in {{model-global-attributes}}.

- directory (index 16): A directory item allows child directory and file items to be defined within a directory hierarchy for the software component.

- file (index 17): A file item allows details about a file to be provided for the software component.

- process (index 18): A process item allows details to be provided about the runtime behavior of the software component, such as information that will appear in a process listing on an endpoint.

- resource (index 19): A resource item can be used to provide details about an artifact or capability expected to be found on an endpoint or evidence collected related to the software component. This can be used to represent concepts not addressed directly by the directory, file, or process items. Examples include: registry keys, bound ports, etc. The equivalent construct in {{SWID}} is currently under specified. As a result, this item might be further defined through extension in the future.

- size (index 20): The file's size in bytes.

- file-version (index 21): The file's version as reported by querying information on the file from the operating system.

- key (index 22): A boolean value indicating if a file or directory is significant or required for the software component to execute or function properly. These are files or directories that can be used to affirmatively determine if the software component is installed on an endpoint.

- location (index 23): The filesystem path where a file is expected to be located when installed or copied. The location MUST be either relative to the location of the parent directory item (preferred) or relative to the location of the CoSWID tag if no parent is defined. The location MUST NOT include a file's name, which is provided by the fs-name item.

- fs-name (index 24): The name of the directory or file without any path information.

- root (index 25): A filesystem-specific name for the root of the filesystem. The location item is considered relative to this location if specified. If not provided, the value provided by the location item is expected to be relative to its parent or the location of the CoSWID tag if no parent is provided.

- path-elements (index 26): This group allows a hierarchy of directory and file items to be defined in payload or evidence items.

- process-name (index 27): The software component's process name as it will appear in an endpoint's process list.

- pid (index 28): The process ID identified for a running instance of the software component in the endpoint's process list. This is used as part of the evidence item.

- type (index 29): A string indicating the type of resource.

- $$resource-collection-extension: This CDDL socket can be used to extend the resource-collection group model. This can be used to add new specialized types of resources. See {{model-extension}}.

- $$file-extension: This CDDL socket can be used to extend the file-entry group model. See {{model-extension}}.

- $$directory-extension: This CDDL socket can be used to extend the directory-entry group model. See {{model-extension}}.

- $$process-extension: This CDDL socket can be used to extend the process-entry group model. See {{model-extension}}.

- $$resource-extension: This CDDL socket can be used to extend the  group model. See {{model-extension}}.

- $$-extension: This CDDL socket can be used to extend the resource-entry group model. See {{model-extension}}.

{: #model-payload}
### The payload-entry Group

The CDDL for the payload-entry group follows:

~~~ CDDL
payload-entry = {
  global-attributes,
  resource-collection,
  * $$payload-extension
}
~~~

The following describes each child item of this group.

- global-attributes: The global-attributes group described in {{model-global-attributes}}.

- resource-collection: The resource-collection group described in {{model-resource-collection}}.

- $$payload-extension: This CDDL socket can be used to extend the payload-entry group model. See {{model-extension}}.

{: #model-evidence}
### The evidence-entry Group

The CDDL for the evidence-entry group follows:

~~~ CDDL
evidence-entry = {
  global-attributes,
  resource-collection,
  ? date => time,
  ? device-id => text,
  * $$evidence-extension
}
date = 35
device-id = 36
~~~

The following describes each child item of this group.

- global-attributes: The global-attributes group described in {{model-global-attributes}}.

- resource-collection: The resource-collection group described in {{model-resource-collection}}.

- date (index 35): The date and time the information was collected pertaining to the evidence item.

- device-id (index 36): The endpoint's string identifier from which the evidence was collected.

- $$evidence-extension:  This CDDL socket can be used to extend the evidence-entry group model. See {{model-extension}}.

## Full CDDL Definition

In order to create a valid CoSWID document the structure of the corresponding CBOR message MUST
adhere to the following CDDL data definition.

~~~ CDDL
{::include concise-swid-tag.cddl}
~~~

{: #semantics-tag-type}
# Determining the Type of CoSWID

The operational model for SWID and CoSWID tags was introduced in {{intro-lifecycle}}, which described four different CoSWID tag types. The following additional rules apply to the use of CoSWID tags to ensure that created tags properly identify the tag type.

The first matching rule MUST determine the type of the CoSWID tag.

1. Primary Tag: A CoSWID tag MUST be considered a primary tag if the corpus, patch, and supplemental items are "false".
1. Supplemental Tag: A CoSWID tag MUST be considered a supplemental tag if the supplemental item is set to "true".
1. Corpus Tag: A CoSWID tag MUST be considered a corpus tag if the corpus item is "true".
1. Patch Tag: A CoSWID tag MUST be considered a patch tag if the patch item is "true".

Note: Multiple of the corpus, patch, and supplemental items can have values set as "true". The rules above provide a means to determine the tag's type in such a case. For example, a SWID or CoSWID tag for a patch installer might have both corpus and patch items set to "true". In such a case, the tag is a "Corpus Tag". The tag installed by this installer would have only the patch item set to "true", making the installed tag type a "Patch Tag".

# CoSWID Indexed Label Values

{: #indexed-version-scheme}
## Version Scheme

The following table contains a set of values for use in the concise-swid-tag group's version-scheme item. These values match the version schemes defined in the ISO/IEC 19770-2:2015 {{SWID}} specification. Index value indicates the value to use as the version-scheme item's value. The Version Scheme Name provides human-readable text for the value. The Definition describes the syntax of allowed values for each entry.

| Index | Version Scheme Name     | Definition
|---
| 1     | multipartnumeric        | Numbers separated by dots, where the numbers are interpreted as integers (e.g., 1.2.3, 1.4.5, 1.2.3.4.5.6.7)
| 2     | multipartnumeric+suffix | Numbers separated by dots, where the numbers are interpreted as integers with an additional textual suffix (e.g., 1.2.3a)
| 3     | alphanumeric            | Strictly a string, sorting is done alphanumerically
| 4     | decimal                 | A floating point number (e.g., 1.25 is less than 1.3)
| 16384 | semver                  | Follows the {{SEMVER}} specification
{: #tbl-indexed-version-scheme-values title="Version Scheme Values"}

The values above are registered in the IANA "SWID/CoSWID Version Scheme Value" registry defined in section {{iana-version-scheme}}. Additional entries will likely be registered over time in this registry.

These version schemes have partially overlapping value spaces. The following gudelines help to ensure that the most specific version-scheme is used:

- "decimal" and "multipartnumeric" partially overlap in their value space when a value matches a decimal number . When a corresponding software-version item's value falls within this overlapping value space, the "decimal" version scheme SHOULD be used.
- "multipartnumeric" and "semver" partially overlap in their value space when a "multipartnumeric" value matches the semantic versioning syntax. When a corresponding software-version item's value falls within this overlapping value space, the "semver" version scheme SHOULD be used.
- "alphanumeric" and other version schemes might overlap in their value space. When a corresponding software-version item's value falls within this overlapping value space, the other version scheme SHOULD be used instead of "alphanumeric".

{: #indexed-entity-role}
## Entity Role Values

The following table indicates the index value to use for the entity-entry group's role item (see {{model-entity}}). These values match the entity roles defined in the ISO/IEC 19770-2:2015 {{SWID}} specification. The "Index" value indicates the value to use as the role item's value. The "Role Name" provides human-readable text for the value. The "Definition" describes the semantic meaning of each entry.

| Index | Role Name       | Definition
|---
| 1     | tagCreator      | The person or organization that created the containing SWID or CoSWID tag
| 2     | softwareCreator | The person or organization entity that created the software component.
| 3     | aggregator      | From {{SWID}}, "An organization or system that encapsulates software from their own and/or other organizations into a different distribution process (as in the case of virtualization), or as a completed system to accomplish a specific task (as in the case of a value added reseller)."
| 4     | distributor     | From {{SWID}}, "An entity that furthers the marketing, selling and/or distribution of software from the original place of manufacture to the ultimate user without modifying the software, its packaging or its labelling."
| 5     | licensor        | From {{SAM}} as "software licensor", a "person or organization who owns or holds the rights to issue a software license for a specific software \[component\]"
{: #tbl-indexed-entity-role-values title="Entity Role Values"}

The values above are registered in the IANA "SWID/CoSWID Entity Role Value" registry defined in section {{iana-entity-role}}. Additional values will likely be registered over time. Additionally, the index values 128 through 255 and the name prefix "x_" have been reserved for private use.

{: #indexed-link-ownership}
## Link Ownership Values

The following table indicates the index value to use for the link-entry group's ownership item (see {{model-link}}). These values match the link ownership values defined in the ISO/IEC 19770-2:2015 {{SWID}} specification. The "Index" value indicates the value to use as the link-entry group ownership item's value. The "Ownership Type" provides human-readable text for the value. The "Definition" describes the semantic meaning of each entry.

| Index | Ownership Type | Definition |
|---
| 1 | abandon | If the software component referenced by the CoSWID tag is uninstalled, then the referenced software SHOULD not be uninstalled
| 2 | private | If the software component referenced by the CoSWID tag is uninstalled, then the referenced software SHOULD be uninstalled as well.
| 3 | shared | If the software component referenced by the CoSWID tag is uninstalled, then the referenced software SHOULD be uninstalled if no other components sharing the software.
{: #tbl-indexed-link-ownership-values title="Link Ownership Values"}

The values above are registered in the IANA "SWID/CoSWID Link Ownership Value" registry defined in section {{iana-link-ownership}}. Additional values will likely be registered over time. Additionally, the index values 128 through 255 and the name prefix "x_" have been reserved for private use.

{: #indexed-link-rel}
## Link Rel Values

The following table indicates the index value to use for the link-entry group's rel item (see {{model-link}}). These values match the link rel values defined in the ISO/IEC 19770-2:2015 {{SWID}} specification. The "Index" value indicates the value to use as the link-entry group ownership item's value. The "Relationship Type" provides human-readable text for the value. The "Definition" describes the semantic meaning of each entry.

| Index | Relationship Type | Definition
|---
| 1     | ancestor          | The link references a SWID/CoSWID tag for a previous release of this software. This can be useful to define an upgrade path.
| 2     | component         | The link references a SWID/CoSWID tag for a separate component of this software.
| 3     | feature           | The link references a configurable feature of this software that can be enabled or disabled without changing the installed files.
| 4     | installationmedia | The link references the installation package that can be used to install this software.
| 5     | packageinstaller  | The link references the installation software needed to install this software.
| 6     | parent            | The link references a SWID/CoSWID tag that is the parent of this SWID/CoSWID tag. This relationship can be used when multiple software components are part of a software bundle, where the "parent" is the SWID/CoSWID tag for the bundle, and each child is a "component". In such a case, each child component can provide a "parent" link relationship to the bundle's SWID/CoSWID tag, and the bundle can provide a "component" link relationship to each child software component.
| 7     | patches           | The link references a SWID/CoSWID tag that this software patches. Typically only used for patch SWID/CoSWID tags (see {{intro-lifecycle}}).
| 8     | requires          | The link references a prerequisite for installing this software. A patch SWID/CoSWID tag (see {{intro-lifecycle}}) can use this to represent base software or another patch that needs to be installed first.
| 9     | see-also          | The link references other software that may be of interest that relates to this software.
| 10    | supersedes        | The link references another software that this software replaces. A patch SWID/CoSWID tag (see {{intro-lifecycle}}) can use this to represent another patch that this patch incorporates or replaces.
| 11    | supplemental      | The link references a SWID/CoSWID tag that this tag supplements. Used on supplemental SWID/CoSWID tags (see {{intro-lifecycle}}).
{: #tbl-indexed-link-rel-values title="Link Relationship Values"}

The values above are registered in the IANA "SWID/CoSWID Link Relationship Value" registry defined in section {{iana-link-rel}}. Additional values will likely be registered over time. Additionally, the index values 32768 through 65535 and the name prefix "x_" have been reserved for private use.

{: #indexed-link-use}
## Link Use Values

The following table indicates the index value to use for the link-entry group's use item (see {{model-link}}). These values match the link use values defined in the ISO/IEC 19770-2:2015 {{SWID}} specification. The "Index" value indicates the value to use as the link-entry group use item's value. The "Use Type" provides human-readable text for the value. The "Definition" describes the semantic meaning of each entry.

| Index | Use Type    | Definition
|---
| 1     | optional    | From {{SWID}}, "Not absolutely required; the \[Link\]'d software is installed only when specified."
| 2     | required    | From {{SWID}}, "The \[Link\]'d software is absolutely required for an operation software installation."
| 3     | recommended | From {{SWID}}, "Not absolutely required; the \[Link\]'d software is installed unless specified otherwise."
{: #tbl-indexed-link-use-values title="Link Use Values"}

The values above are registered in the IANA "SWID/CoSWID Link Use Value" registry defined in section {{iana-link-use}}. Additional values will likely be registered over time. Additionally, the index values 128 through 255 and the name prefix "x_" have been reserved for private use.

{: #iana}
#  IANA Considerations

This document has a number of IANA considerations, as described in
the following subsections.

{: #iana-coswid-items}
## CoSWID Items Registry

This document uses integer values as index values in CBOR maps.

This document defines a new registry titled
"CoSWID Items". Future registrations for this
registry are to be made based on {{RFC8126}} as follows:

| Range             | Registration Procedures
|---
| 0-32767           | Standards Action
| 32768-4294967295  | Specification Required
{: #tbl-iana-coswid-items-reg-proceedures title="CoSWID Items Registration Proceedures"}

All negative values are reserved for Private Use.

Initial registrations for the "CoSWID Items" registry
are provided below. Assignments consist of an integer index value, the item name, and a reference to the defining specification.

| Index | Item Name | Specification
|---
| 0 | tag-id | RFC-AAAA
| 1 | software-name | RFC-AAAA
| 2 | entity | RFC-AAAA
| 3 | evidence | RFC-AAAA
| 4 | link | RFC-AAAA
| 5 | software-meta | RFC-AAAA
| 6 | payload | RFC-AAAA
| 7 | hash | RFC-AAAA
| 8 | corpus | RFC-AAAA
| 9 | patch | RFC-AAAA
| 10 | media | RFC-AAAA
| 11 | supplemental | RFC-AAAA
| 12 | tag-version | RFC-AAAA
| 13 | software-version | RFC-AAAA
| 14 | version-scheme | RFC-AAAA
| 15 | lang | RFC-AAAA
| 16 | directory | RFC-AAAA
| 17 | file | RFC-AAAA
| 18 | process | RFC-AAAA
| 19 | resource | RFC-AAAA
| 20 | size | RFC-AAAA
| 21 | file-version | RFC-AAAA
| 22 | key | RFC-AAAA
| 23 | location | RFC-AAAA
| 24 | fs-name | RFC-AAAA
| 25 | root | RFC-AAAA
| 26 | path-elements | RFC-AAAA
| 27 | process-name | RFC-AAAA
| 28 | pid | RFC-AAAA
| 29 | type | RFC-AAAA
| 31 | entity-name | RFC-AAAA
| 32 | reg-id | RFC-AAAA
| 33 | role | RFC-AAAA
| 34 | thumbprint | RFC-AAAA
| 35 | date | RFC-AAAA
| 36 | device-id | RFC-AAAA
| 37 | artifact | RFC-AAAA
| 38 | href | RFC-AAAA
| 39 | ownership | RFC-AAAA
| 40 | rel | RFC-AAAA
| 41 | media-type | RFC-AAAA
| 42 | use | RFC-AAAA
| 43 | activation-status | RFC-AAAA
| 44 | channel-type | RFC-AAAA
| 45 | colloquial-version | RFC-AAAA
| 46 | description | RFC-AAAA
| 47 | edition | RFC-AAAA
| 48 | entitlement-data-required | RFC-AAAA
| 49 | entitlement-key | RFC-AAAA
| 50 | generator | RFC-AAAA
| 51 | persistent-id | RFC-AAAA
| 52 | product | RFC-AAAA
| 53 | product-family | RFC-AAAA
| 54 | revision | RFC-AAAA
| 55 | summary | RFC-AAAA
| 56 | unspsc-code | RFC-AAAA
| 57 | unspsc-version | RFC-AAAA
| 58-4294967295 | Unassigned               |
{: #tbl-iana-coswid-items-values title="CoSWID Items Inital Registrations"}

{: #iana-value-registries}
## SWID/CoSWID Value Registries

The following IANA registries provide a mechanism for new values to be added over time to common enumerations used by SWID and CoSWID.

{: #iana-registration-proceedures}
### Registration Proceedures

The following registries allow for the registration of index values and names. New registrations will be permitted through either the Standards Action policy or the Specification Required policy {{BCP26}}. The latter SHOULD be used only for registrations requested by SDOs outside the IETF. New index values will be provided on a First Come First Served as defined by {{BCP26}}.

The following registries also reserve the integer-based index values in the range of -1 to -256 for private use as defined by {{BCP26}} in section 4.1. This allows values -1 to -24 to be expressed as a single uint_8t in CBOR, and values -25 to -256 to be expressed using an additional uint_8t in CBOR.

{: #iana-private-use}
### Private Use of Index and Name Values

The integer-based index values in the private use range (-1 to -256) are intended for testing purposes and closed environments; values in other ranges SHOULD NOT be assigned for testing.

For names that correspond to private use index values, an Internationalized Domain Name prefix MUST be used to prevent name conflicts using the form:

```
domain.prefix-name
```

Where "domain.prefix" MUST be a valid Internationalized Domain Name as defined by {{RFC5892}}, and "name" MUST be a unique name within the namespace defined by the "domain.prefix". Use of a prefix in this way allows for a name to be used initially in the private use range, and to be registered at a future point in time. This is consistent with the guidance in {{BCP178}}.

{: #iana-review-guidelines}
### Expert Review Guidelines

Designated experts MUST ensure that new registration requests meet the following additional guidelines:

- The requesting specification MUST provide a clear semantic definition for the new entry. This definition MUST clearly differentiate the requested entry from other previously registered entries.
- The requesting specification MUST describe the intended use of the entry, including any co-constraints that exist between the use of the entry's index value or name, and other values defined within the SWID/CoSWID model.
- Index values and names outside the private use space MUST NOT be used without registration. This is considered squatting and SHOULD be avoided. Designated experts MUST ensure that reviewed specifications register all appropriate index values and names.
- Standards track documents MAY include entries registered in the range reserved for entries under the Specification Required policy. This can occur when a standards track document provides further guidance on the use of index values and names that are in common use, but were not registered with IANA. This situation SHOULD be avoided.
- All registered names MUST be valid according to the XML Schema NMTOKEN data type (see {{-xml-schema-datatypes}} section 3.3.4). This ensures that registered names are compatible with the SWID format {{SWID}} where they are used.
- Registration of vanity names SHOULD be discouraged. The requesting specification MUST provide a description of how a requested name will allow for use by multiple stakeholders.

{: #iana-version-scheme}
### SWID/CoSWID Version Scheme Value Registry

This document defines a new a new registry titled
"SWID/CoSWID Version Scheme Values". This registry provides index values for use as version-scheme item values in this document and version scheme names for use in {{SWID}}.

\[TO BE REMOVED: This registration should take place at the following
   location: https://www.iana.org/assignments/swid\]

This registry uses the registration proceedures defined in {{iana-registration-proceedures}} with the following associated ranges:

| Range        | Registration Procedures
|---
| 0-16383      | Standards Action
| 16384-65535  | Specification Required
{: #tbl-iana-version-scheme-reg-proceedures title="CoSWID Version Scheme Registration Proceedures"}

Assignments MUST consist of an integer Index value, the Version Scheme Name, and a reference to the defining specification.

Initial registrations for the "SWID/CoSWID Version Scheme Value" registry
are provided below, which are derived from the textual version scheme names
defined in {{SWID}}.

| Index       | Version Scheme Name      | Specification
|---
| 0           | Reserved                 |
| 1           | multipartnumeric         | See {{indexed-version-scheme}}
| 2           | multipartnumeric+suffix  | See {{indexed-version-scheme}}
| 3           | alphanumeric             | See {{indexed-version-scheme}}
| 4           | decimal                  | See {{indexed-version-scheme}}
| 5-16383     | Unassigned               |
| 16384       | semver                   | {{SEMVER}}
| 16385-65535 | Unassigned               |
{: #tbl-iana-version-scheme-values title="CoSWID Version Scheme Inital Registrations"}

Registrations MUST conform to the expert review guidelines defined in {{iana-review-guidelines}}.

Designated experts MUST also ensure that newly requested entries define a value space for the corresponding version item that is unique from other previously registered entries. Note: The inital registrations violate this requirement, but are included for backwards compatibility with {{SWID}}. Guidelines on how to deconflict these value spaces are defined in section {{indexed-version-scheme}}.

{: #iana-entity-role}
### SWID/CoSWID Entity Role Value Registry

This document defines a new a new registry titled
"SWID/CoSWID Entity Role Values". This registry provides index values for use as entity-entry role item values in this document and entity role names for use in {{SWID}}.

\[TO BE REMOVED: This registration should take place at the following
   location: https://www.iana.org/assignments/swid\]

This registry uses the registration proceedures defined in {{iana-registration-proceedures}} with the following associated ranges:

| Range   | Registration Procedures
|---
| 0-127    | Standards Action
| 128-255  | Specification Required
{: #tbl-iana-entity-role-reg-proceedures title="CoSWID Entity Role Registration Proceedures"}

Assignments consist of an integer Index value, a Role Name, and a reference to the defining specification.

Initial registrations for the "SWID/CoSWID Entity Role Value" registry
are provided below, which are derived from the textual entity role names
defined in {{SWID}}.

| Index   | Role Name                | Specification
|---
| 0       | Reserved                 |
| 1       | tagCreator               | See {{indexed-entity-role}}
| 2       | softwareCreator          | See {{indexed-entity-role}}
| 3       | aggregator               | See {{indexed-entity-role}}
| 4       | distributor              | See {{indexed-entity-role}}
| 5       | licensor                 | See {{indexed-entity-role}}
| 6-255   | Unassigned               |
{: #tbl-iana-entity-role-values title="CoSWID Entity Role Inital Registrations"}

Registrations MUST conform to the expert review guidlines defined in {{iana-review-guidelines}}.

{: #iana-link-ownership}
### SWID/CoSWID Link Ownership Value Registry

This document defines a new a new registry titled
"SWID/CoSWID Link Ownership Values". This registry provides index values for use as link-entry ownership item values in this document and link ownership names for use in {{SWID}}.

\[TO BE REMOVED: This registration should take place at the following
   location: https://www.iana.org/assignments/swid\]

This registry uses the registration proceedures defined in {{iana-registration-proceedures}} with the following associated ranges:

| Range   | Registration Procedures
|---
| 0-127    | Standards Action
| 128-255  | Specification Required
{: #tbl-iana-link-ownership-reg-proceedures title="CoSWID Link Ownership Registration Proceedures"}

Assignments consist of an integer Index value, an Ownership Type Name, and a reference to the defining specification.

Initial registrations for the "SWID/CoSWID Link Ownership Value" registry
are provided below, which are derived from the textual entity role names
defined in {{SWID}}.

| Index       | Ownership Type Name      | Definition |
|---
| 0           | Reserved                 |
| 1           | abandon                  | See {{indexed-link-ownership}}
| 2           | private                  | See {{indexed-link-ownership}}
| 3           | shared                   | See {{indexed-link-ownership}}
| 4-255       | Unassigned               |
{: #tbl-iana-link-ownership-values title="CoSWID Link Ownership Inital Registrations"}

Registrations MUST conform to the expert review guidlines defined in {{iana-review-guidelines}}.

{: #iana-link-rel}
### SWID/CoSWID Link Relationship Value Registry

This document defines a new a new registry titled
"SWID/CoSWID Link Relationship Values". This registry provides index values for use as link-entry rel item values in this document and link ownership names for use in {{SWID}}.

\[TO BE REMOVED: This registration should take place at the following
   location: https://www.iana.org/assignments/swid\]

This registry uses the registration proceedures defined in {{iana-registration-proceedures}} with the following associated ranges:

| Range        | Registration Procedures
|---
| 0-32767      | Standards Action
| 32768-65535  | Specification Required
{: #tbl-iana-link-rel-reg-proceedures title="CoSWID Link Relationship Registration Proceedures"}

Assignments consist of an integer Index value, the Relationship Type Name, and a reference to the defining specification.

Initial registrations for the "SWID/CoSWID Link Relationship Value" registry
are provided below, which are derived from the link relationship values
defined in {{SWID}}.

| Index       | Relationship Type Name   | Specification
|---
| 0           | Reserved                 |
| 1           | ancestor                 | See {{indexed-link-rel}}
| 2           | component                | See {{indexed-link-rel}}
| 3           | feature                  | See {{indexed-link-rel}}
| 4           | installationmedia        | See {{indexed-link-rel}}
| 5           | packageinstaller         | See {{indexed-link-rel}}
| 6           | parent                   | See {{indexed-link-rel}}
| 7           | patches                  | See {{indexed-link-rel}}
| 8           | requires                 | See {{indexed-link-rel}}
| 9           | see-also                 | See {{indexed-link-rel}}
| 10          | supersedes               | See {{indexed-link-rel}}
| 11          | supplemental             | See {{indexed-link-rel}}
| 12-65535    | Unassigned               |
{: #tbl-iana-link-rel-values title="CoSWID Link Relationship Inital Registrations"}

Registrations MUST conform to the expert review guidlines defined in {{iana-review-guidelines}}.

Designated experts MUST also ensure that a newly requested entry documents the URI schemes allowed to be used in an href associated with the link relationship and the expected resolution behavior of these URI schemes. This will help to ensure that SWID/CoSWID applications are able to interoperate when resolving resources referenced by a link of a given type.

{: #iana-link-use}
### SWID/CoSWID Link Use Value Registry

This document defines a new a new registry titled
"SWID/CoSWID Link Use Values". This registry provides index values for use as link-entry use item values in this document and link use names for use in {{SWID}}.

\[TO BE REMOVED: This registration should take place at the following
   location: https://www.iana.org/assignments/swid\]

This registry uses the registration proceedures defined in {{iana-registration-proceedures}} with the following associated ranges:

| Range   | Registration Procedures
|---
| 0-127    | Standards Action
| 128-255  | Specification Required
{: #tbl-iana-link-use-reg-proceedures title="CoSWID Link Use Registration Proceedures"}

Assignments consist of an integer Index value, the Link Use Type Name, and a reference to the defining specification.

Initial registrations for the "SWID/CoSWID Link Use Value" registry
are provided below, which are derived from the link relationship values
defined in {{SWID}}.

| Index   | Link Use Type Name       | Specification
|---
| 0       | Reserved                 |
| 1       | optional                 | See {{indexed-link-use}}
| 2       | required                 | See {{indexed-link-use}}
| 3       | recommended              | See {{indexed-link-use}}
| 4-255   | Unassigned               |
{: #tbl-iana-link-use-values title="CoSWID Link Use Inital Registrations"}

Registrations MUST conform to the expert review guidlines defined in {{iana-review-guidelines}}.

## swid+cbor Media Type Registration

IANA is requested to add the following to the IANA "Media Types" registry.

Type name: application

Subtype name: swid+cbor

Required parameters: none

Optional parameters: none

Encoding considerations: Must be encoded as using {{RFC7049}}. See
RFC-AAAA for details.

Security considerations: See {{sec-sec}} of RFC-AAAA.

Interoperability considerations: Applications MAY ignore any key
value pairs that they do not understand. This allows
backwards compatible extensions to this specification.

Published specification: RFC-AAAA

Applications that use this media type: The type is used by software
asset management systems, vulnerability assessment systems, and in
applications that use remote integrity verification.

Fragment identifier considerations: Fragment identification for
application/swid+cbor is supported by using fragment identifiers as
specified by RFC-7049 section 7.5.

Additional information:

Magic number(s): first five bytes in hex: da 53 57 49 44

File extension(s): coswid

Macintosh file type code(s): none

Macintosh Universal Type Identifier code: org.ietf.coswid
conforms to public.data

Person & email address to contact for further information:
Henk Birkholz \<henk.birkholz@sit.fraunhofer.de>

Intended usage: COMMON

Restrictions on usage: None

Author: Henk Birkholz \<henk.birkholz@sit.fraunhofer.de>

Change controller: IESG

## CoAP Content-Format Registration

IANA is requested to assign a CoAP Content-Format ID for the CoSWID
media type in the "CoAP Content-Formats" sub-registry, from the "IETF
Review or IESG Approval" space (256..999), within the "CoRE
Parameters" registry {{RFC7252}}:

| Media type            | Encoding | ID    | Reference |
| application/swid+cbor | -        | TBD1 | RFC-AAAA  |
{: #tbl-coap-content-formats cols="l l" title="CoAP Content-Format IDs"}

## CBOR Tag Registration

IANA is requested to allocate a tag in the "CBOR Tags" registry,
preferably with the specific value requested:

|        Tag | Data Item | Semantics                                       |
| 1398229316 | map       | Concise Software Identifier (CoSWID) \[RFC-AAAA\] |
{: #tbl-cbor-tag title="CoSWID CBOR Tag"}

## URI Scheme Registrations

The ISO 19770-2:2015 SWID specification describes use of the "swid" and "swidpath" URI schemes, which are currently in use in implementations. This document continues this use for CoSWID. The following subsections provide registrations for these schemes in to ensure that a permanent registration exists for these schemes that is suitable for use in the SWID and CoSWID specifications.

### "swid" URI Scheme Registration
SWID or CoSWID by the referenced tag's tag-id. This
  URI needs to be resolved in the context of the endpoint by software
  that can lookup other SWID or CoSWID tags. For example, "swid:2df9de35-0aff-4a86-ace6-f7dddd1ade4c" references the tag with the tag-id value "2df9de35-0aff-4a86-ace6-f7dddd1ade4c".

There is a need for a scheme name that can be used in URIs that point to a specific SWID/CoSWID tag by that tag's tag-id, such as the use of the link entry as described in section {{model-link}}) of this document. Since this scheme is used in a standards track document and an ISO standard, this scheme needs to be used without fear of conflicts with current or future actual schemes.  The scheme "swid" is hereby registered as a 'permanent' scheme for that purpose.

The "swid" scheme is specified as follows:

Scheme syntax:  The scheme speific part consists of a SWID or CoSWID tag's tag-id that is URI encoded according to {{RFC3986}} section 2.1. The following expression is a valid example:

~~~~
<swid:2df9de35-0aff-4a86-ace6-f7dddd1ade4c>
~~~~

Scheme semantics:  URIs in the "swid" scheme are to be used to reference a SWID or CoSWID tag by its tag-id. A tag-id referenced in this way can be used to indentify the tag resource in the context of where it is referenced from. For example, when a tag is installed on a given device, that tag can reference related tags on the same device using this URI scheme.

Encoding considerations:  See Section 2.5 of {{RFC3986}} for guidelines.

Interoperability considerations:  None.

Security considerations:  None.

### "swidpath" URI Scheme Registration

There is a need for a scheme name that can be used in URIs to indentify a collection of specific SWID/CoSWID tags with data elements that match an XPath expression, such as the use of the link entry as described in section {{model-link}}) of this document. Since this scheme is used in a standards track document and an ISO standard, this scheme needs to be used without fear of conflicts with current or future actual schemes.  The scheme "swidpath" is hereby registered as a 'permanent' scheme for that purpose.

The "swidpath" scheme is specified as follows:

Scheme syntax:  The scheme speific part consists of an XPath expression as defined by {{-xpath}}. The included XPath expression will be URI encoded according to {{RFC3986}} section 2.1.

Scheme semantics:  URIs in the "swidpath" scheme are to be used specify the data that must be found in a given SWID/CoSWID tag for that tag to be considered a matching tag to be included in the identified tag collection. Tags to be evaluated include all tags in the context of where the tag is referenced from. For example, when a tag is installed on a given device, that tag can reference related tags on the same device using this URI scheme. A tag is matching if the XPath evaluation result value has an effective boolean value of "true" according to {{-xpath}} section 2.4.3.
rence related tags on the same device using this URI scheme.

Encoding considerations:  See Section 2.5 of {{RFC3986}} for guidelines.

Interoperability considerations:  None.

Security considerations:  None.

## CoSWID Model for use in SWIMA Registration

The Software Inventory Message and Attributes (SWIMA) for PA-TNC specification {{RFC8412}} defines a standardized method for collecting an endpoint device's software inventory. A CoSWID can provide evidence of software installation which can then be used and exchanged with SWIMA. This registration adds a new entry to the IANA "Software Data Model Types" registry defined by {{RFC8412}} to support CoSWID use in SWIMA as follows:

Pen: 0

Integer: TBD2

Name: Concise Software Identifier (CoSWID)

Defining Specification: RFC-AAAA

Deriving Software Identifiers:

  A Software Identifier generated from a CoSWID tag is expressed as a concatenation of the form:

    TAG_CREATOR_REGID "_" "_" UNIQUE_ID

  Where TAG_CREATOR_REGID is the reg-id ietm value of the tag's entity item having the role value of 1 (corresponding to "tag creator"), and the UNIQUE_ID is the same tag's tag-id item. If the tag-id item's value is expressed as a 16 byte binary string, the UNIQUE_ID MUST be represented using the UUID string representation defined in {{RFC4122}} including the "urn:uuid:" prefix.

  The TAG_CREATOR_REGID and the UNIQUE_ID are connected with a double underscore (_), without any other connecting character or whitespace.

{: #sec-sec}
#  Security Considerations

SWID and CoSWID tags contain public information about software components and, as
such, do not need to be protected against disclosure on an endpoint.
Similarly, SWID/CoSWID tags are intended to be easily discoverable by
applications and users on an endpoint in order to make it easy to
identify and collect all of an endpoint's SWID tags.  As such, any
security considerations regarding SWID/CoSWID tags focus on the application
of SWID/CoSWID tags to address security challenges, and the possible
disclosure of the results of those applications.

A tag is considered "authoritative" if the SWID/CoSWID tag was created by the
software provider. An authoritative SWID/CoSWID tag contains information about a software component provided by the maintainer of the software component, who is expected to be an expert in their own software. Thus, authoritative SWID/CoSWID tags can be trusted to represent authoritative information about the software component.

A signed SWID/CoSWID tag (see {{appendix-cose}}) whose signature has been validated can be relied upon to be unchanged since it was signed. By contrast, the data contained in unsigned tags cannot be trusted to be unmodified.

When an authoritative tag is signed, the software provider can be authenticated as the originator of the signature. Having a signed authoritative SWID/CoSWID tag can be useful when the information in the tag needs to be trusted, such as when the tag is being used to convey reference integrity measurements for software components.

SWID/CoSWID tags are designed to be easily added and removed from an
endpoint along with the installation or removal of software components.
On endpoints where addition or removal of software components is
tightly controlled, the addition or removal of SWID tags can be
similarly controlled.  On more open systems, where many users can
manage the software inventory, SWID/CoSWID tags can be easier to add or
remove.  On such systems, it can be possible to add or remove SWID/CoSWID
tags in a way that does not reflect the actual presence or absence of
corresponding software components.  Similarly, not all software
products automatically install SWID/CoSWID tags, so products can be present
on an endpoint without providing a corresponding SWID tag.  As such,
any collection of SWID/CoSWID tags cannot automatically be assumed to
represent either a complete or fully accurate representation of the
software inventory of the endpoint.  However, especially on endpoint devices
that more strictly control the ability to add or remove applications,
SWID/CoSWID tags are an easy way to provide an preliminary understanding of
that endpoint's software inventory.

Any report of an endpoint's SWID/CoSWID tag collection provides
information about the software inventory of that endpoint.  If such a
report is exposed to an attacker, this can tell them which software
products and versions thereof are present on the endpoint.  By
examining this list, the attacker might learn of the presence of
applications that are vulnerable to certain types of attacks.  As
noted earlier, SWID/CoSWID tags are designed to be easily discoverable by an
endpoint, but this does not present a significant risk since an
attacker would already need to have access to the endpoint to view
that information.  However, when the endpoint transmits its software
inventory to another party, or that inventory is stored on a server
for later analysis, this can potentially expose this information to
attackers who do not yet have access to the endpoint.  For this reason, it is
important to protect the confidentiality of SWID/CoSWID tag information that
has been collected from an endpoint, not because those tags
individually contain sensitive information, but because the
collection of SWID/CoSWID tags and their association with an endpoint
reveals information about that endpoint's attack surface.

Finally, both the ISO-19770-2:2015 XML schema SWID definition and the
CoSWID data definition allow for the construction of "infinite"
tags with link item loops or tags that contain malicious content with the intent
of creating non-deterministic states during validation or processing of those tags. While software
providers are unlikely to do this, SWID/CoSWID tags can be created by any party and the SWID/CoSWID tags
collected from an endpoint could contain a mixture of vendor and non-vendor created tags. For this
reason, tools that consume SWID/CoSWID tags ought to treat the tag contents as potentially malicious and
employ input sanitizing and loop detection on the tags they ingest.

#  Acknowledgments

This document draws heavily on the concepts defined in the ISO/IEC 19770-2:2015 specification. The authors of this document are grateful for the prior work of the 19770-2 contributors.

We are also grateful to the careful reviews provided by ...

#  Change Log

\[THIS SECTION TO BE REMOVED BY THE RFC EDITOR.\]

Changes from version 03 to version 11:

- Reduced representation complexity of the media-entry type and removed the section describing the older data structure.
- Added more signature schemes from COSE
- Included a minimal required set of normative language
- Reordering of attribute name to integer label by priority according to semantics.
- Added an IANA registry for CoSWID items supporting future extension.
- Cleaned up IANA registrations, fixing some inconsistencies in the table labels.
- Added additional CDDL sockets for resource collection entries providing for additional extension points to address future SWID/CoSWID extensions.
- Updated section on extension points to address new CDDL sockets and to reference the new IANA registry for items.
- Removed unused references and added new references to address placeholder comments.
- Added table with semantics for the link ownership item.
- Clarified language, made term use more consistent, fixed references, and replacing lowercase RFC2119 keywords.

Changes from version 02 to version 03:

- Updated core CDDL including the CDDL design pattern according to RFC 8428.

Changes from version 01 to version 02:

- Enforced a more strict separation between the core CoSWID definition and additional usage by
moving content to corresponding appendices.
- Removed artifacts inherited from the reference schema provided by ISO (e.g. NMTOKEN(S))
- Simplified the core data definition by removing group and type choices where possible
- Minor reordering of map members
- Added a first extension point to address requested flexibility for extensions beyond the
any-element

Changes from version 00 to version 01:

- Ambiguity between evidence and payload eliminated by introducing explicit members (while still
- allowing for "empty" SWID tags)
- Added a relatively restrictive COSE envelope using cose_sign1 to define signed CoSWID (single signer only, at the moment)
- Added a definition how to encode hashes that can be stored in the any-member using existing IANA tables to reference hash-algorithms

Changes since adopted as a WG I-D -00:

- Removed redundant any-attributes originating from the ISO-19770-2:2015 XML schema definition
- Fixed broken multi-map members
- Introduced a more restrictive item (any-element-map) to represent custom maps, increased restriction on types for the any-attribute, accordingly
- Fixed X.1520 reference
- Minor type changes of some attributes (e.g. NMTOKENS)
- Added semantic differentiation of various name types (e,g. fs-name)

Changes from version 06 to version 07:

- Added type choices/enumerations based on textual definitions in 19770-2:2015
- Added value registry request
- Added media type registration request
- Added content format registration request
- Added CBOR tag registration request
- Removed RIM appedix to be addressed in complementary draft
- Removed CWT appendix
- Flagged firmware resource colletion appendix for revision
- Made use of terminology more consistent
- Better defined use of extension points in the CDDL
- Added definitions for indexed values
- Added IANA registry for Link use indexed values

Changes from version 05 to version 06:

- Improved quantities
- Included proposals for implicet enumerations that were NMTOKENS
- Added extension points
- Improved exemplary firmware-resource extension

Changes from version 04 to version 05:

- Clarified language around SWID and CoSWID to make more consistent use of these terms.
- Added language describing CBOR optimizations for single vs. arrays in the model front matter.
- Fixed a number of grammatical, spelling, and wording issues.
- Documented extension points that use CDDL sockets.
- Converted IANA registration tables to markdown tables, reserving the 0 value for use when a value is not known.
- Updated a number of references to their current versions.

Changes from version 03 to version 04:

- Re-index label values in the CDDL.
- Added a section describing the CoSWID model in detail.
- Created IANA registries for entity-role and version-scheme

Changes from version 02 to version 03:

- Updated CDDL to allow for a choice between a payload or evidence
- Re-index label values in the CDDL.
- Added item definitions
- Updated references for COSE, CBOR Web Token, and CDDL.

Changes from version 01 to version 02:

- Added extensions for Firmware and CoSWID use as Reference Integrity Measurements (CoSWID RIM)
- Changes meta handling in CDDL from use of an explicit use of items to a more flexible unconstrained collection of items.
- Added sections discussing use of COSE Signatures and CBOR Web Tokens

Changes from version 00 to version 01:

- Added CWT usage for absolute SWID paths on a device
- Fixed cardinality of type-choices including arrays
- Included first iteration of firmware resource-collection

--- back

{: #appendix-cose}
# Signed Concise SWID Tags using COSE

SWID tags, as defined in the ISO-19770-2:2015 XML schema, can include cryptographic signatures to
protect the integrity of the SWID tag. In general, tags are signed by the tag creator (typically,
although not exclusively, the vendor of the software component that the SWID tag identifies).
Cryptographic signatures can make any modification of the tag detectable, which is especially
important if the integrity of the tag is important, such as when the tag is providing reference
integrity measurements for files.

The ISO-19770-2:2015 XML schema uses XML DSIG to support cryptographic signatures. CoSWID tags
require a different signature scheme than this. COSE (CBOR Object Signing and Encryption) provides the required mechanism {{RFC8152}}. Concise SWID can be wrapped in a COSE Single Signer Data Object
(COSE_Sign1) that contains a single signature. The following CDDL defines a more restrictive subset
of header attributes allowed by COSE tailored to suit the requirements of Concise SWID tags.

~~~~ CDDL
<CODE BEGINS>
{::include signed-coswid.cddl}
<CODE ENDS>
~~~~

Optionally, the COSE_Sign structure that allows for more than one signature to be applied to a CoSWID tag MAY be used. The corresponding usage scenarios are domain-specific and require well-defined application guidance. Representation of the corresponding guidance is out-of-scope of this document.

Additionally, the COSE Header counter signature MAY be used as an attribute in the unprotected header map of the COSE envelope of a CoSWID. The application of counter signing enables second parties to provide a signature on a signature allowing for a proof that a signature existed at a given time (i.e., a timestamp).

<!--  LocalWords:  SWID verifier TPM filesystem discoverable
 -->

