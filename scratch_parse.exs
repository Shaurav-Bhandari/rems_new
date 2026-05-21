try do
  Code.string_to_quoted!(File.read!("lib/bindu_backend/flags.ex"))
  IO.puts("Parsing succeeded!")
rescue
  e ->
    IO.puts("Parsing failed with:")
    IO.inspect(e)
end
