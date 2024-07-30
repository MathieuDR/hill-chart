[
  import_deps: [
    :ecto,
    :ecto_sql,
    :stream_data,
    :phoenix,
    :typed_struct
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Styler],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
