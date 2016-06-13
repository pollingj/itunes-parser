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

  test "parse_meta", %{sample1: sample1, big_sample: big_sample} do
    meta = RSS2.parse_meta(sample1)
    assert meta == %ITunesParser.MetaData{
      title: "W3Schools Home Page",
      link: "http://www.w3schools.com",
      description: "Free web building tutorials",
      skip_hours: [1,2],
      skip_days: [1,2],
      image: %ITunesParser.Image{
        title: "Test Image",
        description: "test image...",
        url: "http://localhost/image"
      },
      last_build_date: %Timex.DateTime{
        calendar: :gregorian, day: 16,
        hour: 9, minute: 54, month: 8, millisecond: 0, second: 5,
        timezone: %Timex.TimezoneInfo{
          abbreviation: "UTC", from: :min,
          full_name: "UTC",
          offset_std: 0,
          offset_utc: 0,
          until: :max},
        year: 2015},
      publication_date: %Timex.DateTime{
        calendar: :gregorian,
        day: 15,
        hour: 9, minute: 54, month: 8, millisecond: 0, second: 5,
        timezone: %Timex.TimezoneInfo{
          abbreviation: "UTC",
          from: :min,
          full_name: "UTC",
          offset_std: 0,
          offset_utc: 0,
          until: :max
        },
        year: 2015
      }
    }

    meta = RSS2.parse_meta(big_sample)
    assert meta == %ITunesParser.MetaData{
      description: "software is fun",
      link: "http://blog.drewolson.org/",
      title: "collect {thoughts}",
      ttl: "60",
      generator: "Ghost 0.6",
      last_build_date: %Timex.DateTime{
        calendar: :gregorian, 
        day: 28,
        hour: 18, minute: 56, month: 8, millisecond: 0, second: 0,
        timezone: %Timex.TimezoneInfo{
          abbreviation: "UTC", from: :min,
          full_name: "UTC", offset_std: 0, offset_utc: 0, until: :max
        },
        year: 2015
      }
    }
  end

  test "parse_entry", %{big_sample: big_sample} do
    entry = XmlNode.first(big_sample, "/rss/channel/item")
            |> RSS2.parse_entry

    assert entry == %ITunesParser.Entry{
      author: nil,
      categories: [ "elixir" ],
      comments: nil,
      description: "<p>I previously <a href=\"http://blog.drewolson.org/the-value-of-explicitness/\">wrote</a> about explicitness in Elixir. One of my favorite ways the language embraces explicitness is in its distinction between eager and lazy operations on collections. Any time you use the <code>Enum</code> module, you're performing an eager operation. Your collection will be transformed/mapped/enumerated immediately. When you use</p>",
      enclosure: nil,
      guid: "9b68a5a7-4ab0-420e-8105-0462357fa1f1",
      link: "http://blog.drewolson.org/elixir-streams/",
      enclosure: %ITunesParser.Enclosure{
        url: "http://www.tutorialspoint.com/mp3s/tutorial.mp3",
        length: "12216320",
        type: "audio/mpeg"
      },
      publication_date: %Timex.DateTime{
        calendar: :gregorian,
        day: 8,
        hour: 13,
        minute: 43,
        month: 6,
        millisecond: 0,
        second: 5,
        timezone: %Timex.TimezoneInfo{
          abbreviation: "UTC",
          from: :min,
          full_name: "UTC",
          offset_std: 0,
          offset_utc: 0,
          until: :max
        },
        year: 2015
      },
      source: nil,
      title: "Elixir Streams"
    }
  end

  test "parse_entries", %{sample1: sample1} do
    [item1, item2] = RSS2.parse_entries(sample1)
    
    assert item1.title == "RSS Tutorial"
    assert item1.link == "http://www.w3schools.com/webservices"
    assert item1.description == "New RSS tutorial on W3Schools"

    assert item2.title == "XML Tutorial"
    assert item2.link == "http://www.w3schools.com/xml"
    assert item2.description == "New XML tutorial on W3Schools"
  end

  test "parse", %{sample1: sample1} do
    feed = RSS2.parse(sample1)

    assert feed == %ITunesParser.Feed{
      entries: [
        %ITunesParser.Entry{
          description: "New RSS tutorial on W3Schools",
          link: "http://www.w3schools.com/webservices", 
          title: "RSS Tutorial"},
        %ITunesParser.Entry{
          description: "New XML tutorial on W3Schools",
          link: "http://www.w3schools.com/xml", 
          title: "XML Tutorial"}],
      meta: %ITunesParser.MetaData{
        description: "Free web building tutorials",
        link: "http://www.w3schools.com", 
        title: "W3Schools Home Page",
        skip_days: [1,2],
        skip_hours: [1,2],
        image: %ITunesParser.Image{
          title: "Test Image",
          description: "test image...",
          url: "http://localhost/image"
        },
        last_build_date: %Timex.DateTime{
          calendar: :gregorian, day: 16,
          hour: 9, minute: 54, month: 8, millisecond: 0, second: 5,
          timezone: %Timex.TimezoneInfo{
            abbreviation: "UTC", from: :min,
            full_name: "UTC",
            offset_std: 0,
            offset_utc: 0,
            until: :max},
          year: 2015},
        publication_date: %Timex.DateTime{
          calendar: :gregorian,
          day: 15,
          hour: 9, minute: 54, month: 8, millisecond: 0, second: 5,
          timezone: %Timex.TimezoneInfo{
            abbreviation: "UTC",
            from: :min,
            full_name: "UTC",
            offset_std: 0,
            offset_utc: 0,
            until: :max
          },
          year: 2015
        }
      }
    }
  end
end
