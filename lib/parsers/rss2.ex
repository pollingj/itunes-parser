defmodule ITunesParser.Parsers.RSS2 do
  import ITunesParser.Parsers.Helpers

  alias ITunesParser.XmlNode
  alias ITunesParser.Feed
  alias ITunesParser.Episode
  alias ITunesParser.Podcast
  alias ITunesParser.Image
  alias ITunesParser.Enclosure

  def valid?(document) do
    has_version = document
                  |> XmlNode.first("/rss")
                  |> XmlNode.attr("version") == "2.0"

    has_one_channel = document
                      |> XmlNode.first("/rss/channel") != nil

    Enum.all? [ has_version, has_one_channel ]
  end

  def parse(document) do
    %Feed{meta: parse_podcast(document), entries: parse_entries(document)}
  end

  def parse_podcast(document) do
    channel = XmlNode.first(document, "/rss/channel")

    # image like fields needs special parsing
    ignore_fields = ["itunes:image"]
    podcast = parse_into_struct(channel, %Podcast{}, ignore_fields)

    # Parse other fields
    image = XmlNode.first(channel, "itunes:image") 
            |> parse_attributes_into_struct(%Image{})


    publication_date = XmlNode.first_try(channel, ["pubDate", "publicationDate"]) 
                       |> parse_datetime


    %{podcast | 
      image: image,
    }
  end

  def parse_entries(document) do
    XmlNode.children_map(document, "/rss/channel/item", &parse_entry/1)
  end

  def parse_entry(node) do
    ignore_fields = [:categories, :enclosure, :publication_date]
    entry = parse_into_struct(node, %Episode{}, ignore_fields)

    categories = XmlNode.children_map(node, "category", &XmlNode.text/1)

    enclosure = XmlNode.first(node, "enclosure")
                |> parse_attributes_into_struct(%Enclosure{})

    publication_date = XmlNode.first_try(node, ["pubDate", "publicationDate"])
                       |> parse_datetime

    %{entry |
      categories: categories,
      enclosure: enclosure,
      publication_date: publication_date
    }
  end
end
