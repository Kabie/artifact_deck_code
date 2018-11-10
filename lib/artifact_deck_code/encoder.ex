defmodule ArtifactDeckCode.Encoder do


  def encode_deck(%{name: name, heroes: heroes, cards: cards}) do
    heroes_bytes = for {id, count} <- Enum.sort(heroes), into: "" do
      <<id, count>>
    end

    heroes_count = length(heroes)

    {:ok, <<"ADC", 2::4, heroes_count::4, 0, 0, heroes_bytes::bytes()>>}
  end

  def encode_deck(_) do
    {:error, :bad_deck}
  end

end
