defmodule ArtifactDeckCode.Decoder do
  @moduledoc """

  ADCJWkTZX05uwGDCRV4XQGy3QGLmqUBg4GQJgGLGgO7AaABR3JlZW4vQmxhY2sgRXhhbXBsZQ__

  """

  @prefix "ADC"

  # %{
  #   name: name,
  #   heroes: [{id, turn}, ...],
  #   cards: [{id, count}, ...],
  # }
  @spec parse_deck(deck_code :: :binary) :: Map
  def parse_deck(deck_code) do
    with {:ok, bytes_code} <- decode_deck(deck_code),
         {:ok, deck} <- decode_bytes(bytes_code) do
      deck
    end
  end

  def decode_deck(@prefix <> deck_code) do
    deck_code
    |> String.replace("-", "/")
    |> String.replace("_", "=")
    |> Base.decode64()
  end

  def decode_deck(_deck_code) do
    {:error, :bad_prefix}
  end

  def decode_bytes(<<1::4, heroes_count::4, checksum, rest::bytes()>> = bytes_code) do
    {:error, :not_impl}
  end

  def decode_bytes(<<2::4, heroes_count::4, checksum, name_len, rest::bytes()>> = bytes_code) do
    # decode_bytes(version, rest)

    {cards_bytes, name} = String.split_at(bytes_code, -name_len)

    cards = decode_cards(cards_bytes, 0, [])

    {:ok, :v2, heroes_count, checksum, name_len, name, cards}
  end

  def decode_bytes(_bytes_code) do
    {:error, :bad_version}
  end

  def decode_bytes(1, rest) do
  end

  # ???
  def decode_cards(<<0b11::2, _continue::1, offset::5>>) do
    throw :not_impl
  end

  def decode_cards(<<count::2, _continue::1, offset::5, rest::bytes()>>, base_card_id, acc) do
    card_id = base_card_id + offset
    decode_cards(rest, card_id, [{card_id, count + 1} | acc])
  end

  def decode_cards(_rest, _, acc) do
    Enum.reverse(acc)
  end
end
