%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["**/*.ex"],
        excluded: ["deps/"]
      },
      plugins: [],
      requires: [],
      strict: false,
      parse_timeout: 5000,
      color: true,
    }
  ]
}
