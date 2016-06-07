defmodule ITunesParserTest do
  use ExUnit.Case, async: false

  alias ITunesParser.XmlNode

  import Mock

  setup do
    {:ok, wrong} = File.read("test/fixtures/wrong.xml")
    {:ok, rss2} = File.read("test/fixtures/rss2/bigsample.xml")

    {:ok, [rss2: rss2, wrong: wrong]}
  end

  test "parse", %{rss2: rss2, wrong: wrong} do
    rss2_doc = XmlNode.from_string(rss2)
    with_mock ITunesParser.Parsers.RSS2, [valid?: fn(_) -> true end, parse: fn(_) -> :ok end] do
      {:ok, feed} = ITunesParser.parse(rss2)
      assert called ITunesParser.Parsers.RSS2.valid?(rss2_doc)
      assert called ITunesParser.Parsers.RSS2.parse(rss2_doc)
    end

    {:error, "Feed format not valid"} = ITunesParser.parse(wrong)
  end
end
