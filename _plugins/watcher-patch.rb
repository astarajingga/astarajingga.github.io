# frozen_string_lit eral: true

require 'jekyll-watch'

module jekyll
    module Watcher
        extend self

        alias_method :original_listen_ignore_paths, :listen_ignore_paths

        def listen_ignore_paths(options)
            original_listen_ignore_paths(options) + [%r!.*\.TMP!i]
        end
    end
end