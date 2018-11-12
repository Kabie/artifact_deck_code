# ArtifactDeckCode

Encoder and decoder for decks of the Artifact game.
See [reference coder by Valve](https://github.com/ValveSoftware/ArtifactDeckCode).

[Documentation is available online](https://hexdocs.pm/artifact_deck_code).


## Usage

Decode a deck code string:

```elixir
iex> ArtifactDeckCode.decode("ADCJWkTZX05uwGDCRV4XQGy3QGLmqUBg4GQJgGLGgO7AaABR3JlZW4vQmxhY2sgRXhhbXBsZQ__")
{:ok,
 %{
   cards: [
     {3000, 2},
     {3001, 1},
     {10091, 3},
     ...
   ],
   heroes: [{4005, 2}, {10014, 1}, {10017, 3}, {10026, 1}, {10047, 1}],
   name: "Green/Black Example"
 }}
```

Encode a deck:

```elixir
iex> ArtifactDeckCode.encode(%{name: "Optional deck name",
...>    heroes: [{4000, 1}, {4003, 1}, {10054, 1}, {10014, 2}, {10070, 3}],
...>    cards: [{3000, 2}, {3001, 2}, {3002, 2}],
...> })
{:ok, "ADCJecRIH0De7sBKAGQeF1BQVJlZC9HcmVlbiBCcmF3bGVy"}
```


## Deck format

A deck is just a map with keys `:heroes`, `:cards` and an optional key `:name`.

`heroes` is a list of `{hero_card_id, hero_entrance_turn}`.

`cards` is a list of `{card_id, card_count}`.


## Installation

The package can be installed by adding `artifact_deck_code` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:artifact_deck_code, "~> 0.1.0"}
  ]
end
```
