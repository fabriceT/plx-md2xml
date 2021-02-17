# plx-md2xml

Convert Mardown files to PluXml Article files. 

Written in Vala, using libmarkdown library (A [Discount](http://www.pell.portland.or.us/~orc/Code/discount/) alias on Archlinux).

## Markdown metadata.

For the moment, these tags are used (case is useless):

* %Title       - Title.
* %Description - HTML Meta Keywords
* %Keywords    - HTML Meta Keywords
* %Date        - Creation Date
* %Tags        - Tags used internally by PluXml (tags clouds, related links...)
* %Filename    - Path of output file. PluXml filename contains article number, categories, status, title... Kinda complicated to generate offline.

Tags should be written down in the beginning of the documents. After `MarkdownReader.HEADER_LIMIT` lines, they stop to be considerered as part of metadata.

## TODO

- [ ] Chapô.
- [ ] Article's picture (thumbnails, alt text...)
- [ ] Use it and discover annoying things to add/modify.
- [ ] Use goption instead of args. It's actually basic but it works! \o/
