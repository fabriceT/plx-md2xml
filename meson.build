project('plx-md2xml', 'vala', 'c',
  version: '0.1.0',
  meson_version: '>= 0.36.0',
)

glib = dependency('glib-2.0')
gobject = dependency('gobject-2.0')
xml = dependency('libxml-2.0')


add_project_arguments(
  ['--vapidir', join_paths(meson.current_source_dir(), 'vapi')],
  language: 'vala'
)

subdir('src')
