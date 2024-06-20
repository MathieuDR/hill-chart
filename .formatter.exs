[
  import_deps: [
    :ecto,
    :ecto_sql,
    :phoenix,
    :typed_struct
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
