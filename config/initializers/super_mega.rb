config = YAML.safe_load(File.open(Rails.root.join('config', 'super-mega.yml'))).deep_symbolize_keys

searchers = {}
config[:searchers].each do |label, settings|
  next if settings.key?(:disable)
  if Rails.application.credentials.searchers.key?(label)
    settings.merge!(Rails.application.credentials.searchers[label])
  end
  searchers[label] = settings.freeze
end

SEARCHERS = searchers.freeze
