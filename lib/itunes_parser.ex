defmodule ITunesParser do
  alias ITunesParser.XmlNode
  alias ITunesParser.Parsers.RSS2
  alias ITunesParser.Parsers.Atom

  defmodule Image do
    defstruct title: nil,
              url: nil,
              link: nil,
              width: nil,
              height: nil,
              description: nil
  end

  defmodule Enclosure do
    defstruct url: nil,
              length: nil,
              type: nil
  end

  defmodule Podcast do
    defstruct title: nil,
              sub_title: nil,
              link: nil,
              description: nil,
              summary: nil,
              author: nil,
              language: nil,
              copyright: nil,
              last_build_date: nil,
              category: nil,
              image: nil
  end

  defmodule Episode do
    defstruct title: nil,
              sub_title: nil,
              image: nil,
              link: nil,
              description: nil,
              author: nil,
              categories: [],
              keywords: [],
              summary: nil,
              enclosure: nil,
              guid: nil,
              duration: nil,
              publication_date: nil,
              explicit: nil
  end

  defmodule Atom do
    defstruct link: nil,
              rel: nil,
              type: nil
  end

  defmodule Feed do
    defstruct meta: nil, 
              entries: nil
  end

  def parse(xml) do
    {:ok, XmlNode.from_string(xml)}
    |> detect_parser
    |> parse_document
  end

  defp parse_document({:ok, parser, document}) do
    {:ok, parser.parse(document)}
  end

  defp parse_document(other), do: other

  defp detect_parser({:ok, document}) do
    cond do
      RSS2.valid?(document) -> {:ok, RSS2, document}
      true -> {:error, "Feed format not valid"}
    end
  end

  defp detect_parser(other), do: other
end
