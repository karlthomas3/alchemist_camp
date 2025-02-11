defmodule Statwatch do
  def run do
    fetch_stats()
    |> save_csv()
  end

  def fetch_stats do
    now = %{DateTime.utc_now() | microsecond: {0, 0}} |> DateTime.to_string()

    %{body: body} = HTTPoison.get!(stats_url())
    %{items: [%{statistics: stats} | _]} = Poison.decode!(body, keys: :atoms)

    [now, stats.subscriberCount, stats.videoCount, stats.viewCount]
    |> Enum.join(", ")
  end

  def stats_url do
    youtube_api_v3 = "https://www.googleapis.com/youtube/v3/"
    youtube_api_key = "key=" <> read_api_key()
    channel_id = "id=" <> "UCp5Nix6mJCoLkH_GqcRRp1A"
    "#{youtube_api_v3}channels?#{channel_id}&#{youtube_api_key}&part=statistics"
  end

  def column_names do
    Enum.join(~w(DateTime Subscribers Videos Views), ",")
  end

  def save_csv(row_of_stats) do
    filename = "stats.csv"

    unless File.exists?(filename) do
      File.write!(filename, column_names() <> "\n")
    end

    File.write!(filename, row_of_stats <> "\n", [:append])
  end

  defp read_api_key do
    "config/api_key.txt"
    |> File.read!()
    |> String.trim()
  end
end
