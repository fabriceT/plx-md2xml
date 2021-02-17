markdown_lib = meson.get_compiler('c').find_library('libmarkdown')
markdown_vapi = meson.get_compiler('vala').find_library('libmarkdown', dirs: join_paths(meson.source_root(), 'vapi'))
markdown_dep = declare_dependency(dependencies: [markdown_lib, markdown_vapi])

sources = files(
  'main.vala',
  'MarkdownReader.vala',
  'PlxDocument.vala',
)

executable('plx-md2xml',
  sources,
  vala_vapi: 'libmarkdown.vapi',
  dependencies: [glib, gobject, markdown_dep],
  install: true
)
