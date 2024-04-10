#\ -p 3000

require 'bundler/setup'
Bundler.require(:default)

require File.dirname(__FILE__) + "/keyboard-fingerprint/app.rb"

map "/" do
  # FingerprintApp::App.set :symbol_pairs, {}
  run FingerprintApp
end
