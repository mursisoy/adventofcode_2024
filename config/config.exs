import Config

config :advent_of_code,
  session: "",
  input_dir: "./inputs/day"

if File.exists?("config/config.local.exs") do
  import_config("config.local.exs")
end
