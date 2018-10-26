config = YAML.safe_load(File.open(Rails.root.join('config', 'super-mega.yml'))).deep_symbolize_keys

searchers = {}
config[:searchers].each do |label, settings|
  if settings[:type] == 'slack'
    settings[:api_token] = Rails.application.credentials.searchers[label][:api_token]
  end
  searchers[label] = settings.freeze
end

SEARCHERS = searchers.freeze
