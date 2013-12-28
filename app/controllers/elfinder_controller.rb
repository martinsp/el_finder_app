require 'el_finder/action'
# require 'el_finder/volume'

class ElfinderController < ApplicationController
  include ElFinder::Action

  layout false

  skip_before_filter :verify_authenticity_token, :only => [:connector]

  def index
  end

  el_finder(:connector) do
    {
      volumes: [
        ElFinder::Volume.new(id: 'v1', name: 'Volume 1', root: File.join(Rails.public_path, 'system', 'elfinder1'), url: '/system/elfinder1'),
        ElFinder::Volume.new(id: 'v2', name: 'Volume 2', root: File.join(Rails.public_path, 'system', 'elfinder2'), url: '/system/elfinder2')
      ],
      perms: {
         /^(Welcome|README)$/ => {:read => true, :write => false, :rm => false},
         '.' => {:read => true, :write => false, :rm => false}, # '.' is the proper way to specify the home/root directory.
         /^test$/ => {:read => true, :write => true, :rm => false},
         'logo.png' => {:read => true},
         /\.png$/ => {:read => false} # This will cause 'logo.png' to be unreadable.
                                      # Permissions err on the safe side. Once false, always false.
      },
      extractors: {
        'application/zip' => ['unzip', '-qq', '-o'], # Each argument will be shellescaped (also true for archivers)
        'application/x-gzip' => ['tar', '-xzf'],
      },
      archivers: {
        'application/zip' => ['.zip', 'zip', '-qr9'], # Note first argument is archive extension
        'application/x-gzip' => ['.tgz', 'tar', '-czf'],
      }
    }
  end
end
