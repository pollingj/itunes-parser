defmodule ITunesParser.Test.Parsers.RSS2 do
  use ExUnit.Case
  
  alias ITunesParser.XmlNode
  alias ITunesParser.Parsers.RSS2

  setup do
    sample1 = XmlNode.from_file("test/fixtures/rss2/sample1.xml")
    big_sample = XmlNode.from_file("test/fixtures/rss2/bigsample.xml")

    {:ok, [sample1: sample1, big_sample: big_sample]}
  end

  test "valid?", %{sample1: sample1} do
    wrong_doc = XmlNode.from_file("test/fixtures/wrong.xml")

    assert RSS2.valid?(sample1) == true
    assert RSS2.valid?(wrong_doc) == false
  end

  test "parse_podcast", %{sample1: sample1, big_sample: big_sample} do
    meta = RSS2.parse_podcast(sample1)
    assert meta == %ITunesParser.Podcast{
      description: "Podcasters talking about issues that affect podcast producers. A podcast about podcasting.",
      link: "http://podcastersroundtable.com",
      title: "Podcasters' Roundtable - Podcaster Discussing Podcasting",
      image: %ITunesParser.Image{
        href: "http://podcastersroundtable.com/wp-content/uploads/2012/07/Podcasters_Roundtable_ITUNES_image1400x1400.jpg"
      },
      copyright: "Ray Ortega 2015",
      language: "en-US"
    }

    meta = RSS2.parse_meta(big_sample)
    assert meta == %ITunesParser.Podcast{
      description: "Podcasters talking about issues that affect podcast producers. A podcast about podcasting.",
      link: "http://podcastersroundtable.com",
      title: "Podcasters' Roundtable - Podcaster Discussing Podcasting",
      copyright: "Ray Ortega 2015",
      language: "en-US"
    }
  end

  #test "parse_entry", %{big_sample: big_sample} do
  #  entry = XmlNode.first(big_sample, "/rss/channel/item")
  #          |> RSS2.parse_entry

  #  assert entry == %ITunesParser.Episode{
  #    author: nil,
  #    categories: [ "elixir" ],
  #    description: "<p>I previously <a href=\"http://blog.drewolson.org/the-value-of-explicitness/\">wrote</a> about explicitness in Elixir. One of my favorite ways the language embraces explicitness is in its distinction between eager and lazy operations on collections. Any time you use the <code>Enum</code> module, you're performing an eager operation. Your collection will be transformed/mapped/enumerated immediately. When you use</p>",
  #    enclosure: nil,
  #    guid: "9b68a5a7-4ab0-420e-8105-0462357fa1f1",
  #    link: "http://blog.drewolson.org/elixir-streams/",
  #    enclosure: %ITunesParser.Enclosure{
  #      url: "http://www.tutorialspoint.com/mp3s/tutorial.mp3",
  #      length: "12216320",
  #      type: "audio/mpeg"
  #    },
  #    publication_date: %Timex.DateTime{
  #      calendar: :gregorian,
  #      day: 8,
  #      hour: 13,
  #      minute: 43,
  #      month: 6,
  #      millisecond: 0,
  #      second: 5,
  #      timezone: %Timex.TimezoneInfo{
  #        abbreviation: "UTC",
  #        from: :min,
  #        full_name: "UTC",
  #        offset_std: 0,
  #        offset_utc: 0,
  #        until: :max
  #      },
  #      year: 2015
  #    },
  #    title: "Elixir Streams"
  #  }
  #end

  #test "parse_entries", %{sample1: sample1} do
  #  [item1, item2] = RSS2.parse_entries(sample1)
  #  
  #  assert item1.title == "RSS Tutorial"
  #  assert item1.link == "http://www.w3schools.com/webservices"
  #  assert item1.description == "New RSS tutorial on W3Schools"

  #  assert item2.title == "XML Tutorial"
  #  assert item2.link == "http://www.w3schools.com/xml"
  #  assert item2.description == "New XML tutorial on W3Schools"
  #end

  #test "parse", %{sample1: sample1} do
  #  feed = RSS2.parse(sample1)

  #  assert feed == %ITunesParser.Feed{
  #    entries: [
  #      %ITunesParser.Episode{
  #        description: "New RSS tutorial on W3Schools",
  #        link: "http://www.w3schools.com/webservices", 
  #        title: "RSS Tutorial"},
  #      %ITunesParser.Episode{
  #        description: "New XML tutorial on W3Schools",
  #        link: "http://www.w3schools.com/xml", 
  #        title: "XML Tutorial"}],
  #    meta: %ITunesParser.Podcast{
  #      description: "Free web building tutorials",
  #      link: "http://www.w3schools.com", 
  #      title: "W3Schools Home Page",
  #      image: %ITunesParser.Image{
  #        title: "Test Image",
  #        description: "test image...",
  #        url: "http://localhost/image"
  #      },
  #      last_build_date: %Timex.DateTime{
  #        calendar: :gregorian, day: 16,
  #        hour: 9, minute: 54, month: 8, millisecond: 0, second: 5,
  #        timezone: %Timex.TimezoneInfo{
  #          abbreviation: "UTC", from: :min,
  #          full_name: "UTC",
  #          offset_std: 0,
  #          offset_utc: 0,
  #          until: :max},
  #        year: 2015},
  #    }
  #  }
  #end
end
