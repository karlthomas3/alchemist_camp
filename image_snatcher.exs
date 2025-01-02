matcher = ~r/\.(jpg|jpeg|gif|png|bmp)$/
matched_files = File.ls!() |> Enum.filter(&Regex.match?(matcher, &1))

num_matched = Enum.count(matched_files)

msg_end =
  case num_matched do
    1 -> "file"
    _ -> "files"
  end

IO.puts("Matched #{num_matched} #{msg_end}")

case File.mkdir("./images") do
  {:ok, _} -> IO.puts("Directory created")
  {:error, _} -> IO.puts("Directory already exists")
end

Enum.each(matched_files, fn filename ->
  case File.rename(filename, "./images/#{filename}") do
    :ok -> IO.puts("Moved #{filename}")
    _ -> IO.puts("Could not move #{filename}")
  end
end)
