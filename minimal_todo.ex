defmodule MinimalTodo do
  def start do
    input =
      IO.gets("Would you like to load a .csv? (y/n)\n")
      |> String.trim()
      |> String.downcase()

    if input == "y" do
      create_initial_todo() |> get_command()
    else
      load_csv()
    end

    load_csv()
  end

  def add_todo(data) do
    name = get_item_name(data)
    titles = get_fields(data)
    fields = Enum.map(titles, &field_from_user/1)
    new_todo = %{name => Enum.into(fields, %{})}
    IO.puts("New todo #{name} added.\n")
    new_data = Map.merge(data, new_todo)
    get_command(new_data)
  end

  def create_header(headers) do
    case IO.gets("Add field: ") |> String.trim() do
      "" -> headers
      header -> create_header([header | headers])
    end
  end

  def create_headers do
    IO.puts(
      "What data should each todo have?\n" <>
        "Enter field names one by one and an empty line when you're done.\n"
    )

    create_header([])
  end

  def create_initial_todo do
    titles = create_headers()
    name = get_item_name(%{})
    fields = Enum.map(titles, &field_from_user/1)
    IO.puts("New todo #{name} added.\n")
    %{name => Enum.into(fields, %{})}
  end

  def delete_todo(data) do
    todo =
      IO.gets("Which todo would you like to delete?\n")
      |> String.trim()

    if Map.has_key?(data, todo) do
      IO.puts("ok")
      new_map = Map.drop(data, [todo])
      IO.puts(~s{"#{todo}" has been deleted\n})
      get_command(new_map)
    else
      IO.puts(~s{"#{todo}" does not exist\n})
      show_todos(data, false)
      delete_todo(data)
    end
  end

  def field_from_user(name) do
    field = IO.gets("#{name}: ") |> String.trim()
    {name, field}
  end

  def get_command(data) do
    prompt = """
    Type the first letter of the command you want to run
    R)ead todos    A)dd a todo    D)elete a todo    L)oad a .csv    S)ave a .csv
    """

    command =
      IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

    case command do
      "r" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todo(data)
      "l" -> load_csv()
      "s" -> save_csv(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def get_fields(data) do
    data[hd(Map.keys(data))] |> Map.keys()
  end

  def get_item_name(data) do
    name = IO.gets("Enter the name of the new todo: ") |> String.trim()

    if Map.has_key?(data, name) do
      IO.puts("That todo already exists\n")
      get_item_name(data)
    else
      name
    end
  end

  def load_csv() do
    filename =
      IO.gets("Name of .csv to load: ")
      |> String.trim()

    read(filename)
    |> parse()
    |> get_command()
  end

  def parse(content) do
    [header | lines] = String.split(content, ["\n", "\r", "\r\n"])
    titles = tl(String.split(header, ","))
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")

      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, content} ->
        content

      {:error, reason} ->
        IO.puts(~s(Could not open file "#{filename}"\n))
        IO.puts(~s("#{:file.format_error(reason)}"\n))
        start()
    end
  end

  def prep_csv(data) do
    headers = ["Item" | get_fields(data)]
    items = Map.keys(data)

    item_rows =
      Enum.map(items, fn item ->
        [item | Map.values(data[item])]
      end)

    rows = [headers | item_rows]
    row_strings = Enum.map(rows, &Enum.join(&1, ","))
    Enum.join(row_strings, "\n")
  end

  def save_csv(data) do
    filename = IO.gets("Name of .csv to save: ") |> String.trim()
    file_data = prep_csv(data)

    case File.write(filename, file_data) do
      :ok ->
        IO.puts("CSV saved")
        get_command(data)

      {:error, reason} ->
        IO.puts("Could not save file #{filename}")
        IO.puts("#{:file.format_error(reason)}\n")
        get_command(data)
    end
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)

    IO.puts("You have the following Todos: \n")
    Enum.each(items, &IO.puts(&1))
    IO.puts("\n")

    if next_command? do
      get_command(data)
    end
  end
end
