require 'avatar'
require 'avatar/source/gravatar_source'
require 'avatar/source/static_url_source'
require 'avatar/source/wrapper/rails_asset_source_wrapper'
require 'avatar/source/wrapper/string_substitution_source_wrapper'

default = Avatar::Source::Wrapper::RailsAssetSourceWrapper.new(
  Avatar::Source::Wrapper::StringSubstitutionSourceWrapper.new(
    Avatar::Source::StaticUrlSource.new('/images/avatar_default_#{size}.png'),
    {:size => :small}
  )
)

default = nil  # currently no 

Avatar::source = Avatar::Source::GravatarSource.new(default, :email)
