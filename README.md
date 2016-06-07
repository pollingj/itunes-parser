iTunes Parser
=============
[![Build Status](https://travis-ci.org/pollingj/itunes-parser.svg?branch=master)](https://travis-ci.org/pollingj/itunes-parser)

Elixir iTunes XML parser built on erlang's **xmerl** xml parser. It uses [timex](https://github.com/bitwalker/timex) for parsing dates.
The original code is based on [Feedme](https://github.com/umurgdk/elixir-feedme).

## Setup

Add **itunes-parser** into your mix dependencies and applications:

```elixir
def application do
  [applications: [:itunes-parser]]
end

defp deps do
  [{:itunes-parser, "~> 0.1.0"}]
end
```
Then run ```mix deps.get``` to install ITunesParser.

## Parsing

iTunes parser expose only one function named ```parse/1```. Parse function which expects feed format as **rss**.

```elixir
{:ok, xml_string} = File.read("some.xml")
{:ok, feed} = ITunesParser.parse(xml_string)

# Feed
%ITunesParser.Feed{
  meta: %ITunesParser.MetaData{
    author: nil,
    category: nil,
    cloud: nil,
    copyright: nil,
    description: "software is fun",
    docs: nil,
    generator: "Ghost 0.6",
    image: nil,
    language: nil,
    last_build_date: %Timex.DateTime{...},
    link: "http://blog.drewolson.org/", managing_editor: nil,
    publication_date: nil, 
    rating: nil,
    skip_days: [],
    skip_hours: [],
    title: "collect {thoughts}",
    ttl: "60",
    web_master: nil
  }
  entries: [
    %ITunesParser.Entry{
      author: nil,
      categories: ["elixir"],
      comments: nil,
      description: "<p>I previously <a href=\"http://blog.drewolson.org/the-value-of-explicitness/\">wrote</a> about explicitness in Elixir. One of my favorite ways the language embraces explicitness is in its distinction between eager and lazy operations on collections. Any time you use the <code>Enum</code> module, you're performing an eager operation. Your collection will be transformed/mapped/enumerated immediately. When you use</p>",
      enclosure: %ITunesParser.Enclosure{
        length: "12216320",
        type: "audio/mpeg",
        url: "http://www.tutorialspoint.com/mp3s/tutorial.mp3"
      },
      guid: "9b68a5a7-4ab0-420e-8105-0462357fa1f1",
      link: "http://blog.drewolson.org/elixir-streams/",
      publication_date: %Timex.DateTime{...},
      source: nil, title: "Elixir Streams"
    }
  ]
}
```
