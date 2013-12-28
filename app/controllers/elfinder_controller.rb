require 'el_finder/action'

class ElfinderController < ApplicationController
  include ElFinder::Action

  layout false

  def index
  end

  el_finder(:connector) do
      {
        :root => File.join(Rails.public_path, 'system', 'elfinder'),
        :url => '/system/elfinder',
         :perms => {
           /^(Welcome|README)$/ => {:read => true, :write => false, :rm => false},
           '.' => {:read => true, :write => false, :rm => false}, # '.' is the proper way to specify the home/root directory.
           /^test$/ => {:read => true, :write => true, :rm => false},
           'logo.png' => {:read => true},
           /\.png$/ => {:read => false} # This will cause 'logo.png' to be unreadable.
                                        # Permissions err on the safe side. Once false, always false.
        },
        :extractors => {
          'application/zip' => ['unzip', '-qq', '-o'], # Each argument will be shellescaped (also true for archivers)
          'application/x-gzip' => ['tar', '-xzf'],
        },
        :archivers => {
          'application/zip' => ['.zip', 'zip', '-qr9'], # Note first argument is archive extension
          'application/x-gzip' => ['.tgz', 'tar', '-czf'],
        },
      }
    end
end
