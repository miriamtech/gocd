require_relative 'artifacts'
require_relative 'docker'
require_relative 'images'
require_relative 'lambda'
require_relative 'paths'
require_relative 'tasks'

# Add our DSL methods to the top level namespace without polluting the Object inheritance tree.
# This technique comes from `rake`, see e.g.
# https://github.com/ruby/rake/blob/11973e8d31f29aee2e40d874206c9240956f86ed/lib/rake/dsl_definition.rb#L195
#
# rubocop:disable Style/MixinUsage
extend MiriamTech::GoCD::DSL
# rubocop:enable Style/MixinUsage
