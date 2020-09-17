require_relative 'artifacts'
require_relative 'docker'
require_relative 'images'
require_relative 'lambda'
require_relative 'paths'
require_relative 'tasks'

self.extend MiriamTech::GoCD::DSL
