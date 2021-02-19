# plx-md2xml

Convert Mardown files to PluXml Article files. 

Written in Vala, using libmarkdown library (A [Discount](http://www.pell.portland.or.us/~orc/Code/discount/) alias on Archlinux).

## Markdown metadata.

Header section is delimited by two lines with "---" (like YAML stream).

These tags are managed (character case is useless):

* Title       - Title.
* Description - HTML Meta Keywords
* Keywords    - HTML Meta Keywords
* Date        - Creation Date
* Tags        - Tags used internally by PluXml (tags clouds, related links...)
* Filename    - Path of output file. PluXml filename contains article number, categories, status, title... Kinda complicated to generate offline.

PluXml binds tags and articles in a file (tags.xml). It's useless to define tags in article, they must be bound with articles in PluXml administration interface.

## TODO

- [X] Chapô.
- [X] Article's picture (thumbnails, alt text...)
- [ ] Use it and discover annoying things to add/modify.
- [ ] Use goption instead of args. It's actually basic but it works! \o/
