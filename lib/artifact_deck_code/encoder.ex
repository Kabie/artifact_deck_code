defmodule ArtifactDeckCode.Encoder do
  @moduledoc false

  import Bitwise, only: [<<<: 2, >>>: 2, &&&: 2]

  @prefix "ADC"

  def encode(%{heroes: heroes, cards: cards}, 1) do
    heroes_count = length(heroes)
    cards_bytes = encode_cards(heroes) <> encode_cards(cards)
    checksum = calc_checksum(cards_bytes)

    result =
      <<1::4, heroes_count::4, checksum, cards_bytes::bytes()>>
      |> encode_code()

    {:ok, @prefix <> result}
  end

  def encode(%{name: name}, 2) when byte_size(name) > 0xFF do
    {:error, :name_too_long}
  end

  def encode(%{heroes: heroes, cards: cards} = deck, 2) do
    name = Map.get(deck, :name, "")
    name_len = byte_size(name)
    heroes_count = length(heroes)
    cards_bytes = encode_cards(heroes) <> encode_cards(cards)
    checksum = calc_checksum(cards_bytes)

    result =
      <<2::4, heroes_count::4, checksum, name_len, cards_bytes::bytes(), name::bytes()>>
      |> encode_code()

    {:ok, @prefix <> result}
  end

  def encode(_deck, _version) do
    {:error, :unsupported_version}
  end

  defp encode_code(code) do
    code
    |> Base.encode64()
    |> String.replace("/", "-")
    |> String.replace("=", "_")
  end

  defp encode_cards(cards) do
    cards
    |> Enum.sort()
    |> encode_cards(0, <<>>)
  end

  defp encode_cards([], _, acc) do
    acc
  end

  defp encode_cards([{id, num} | rest], offset, acc) when num > 3 do
    encode_cards(
      rest,
      id,
      <<acc::bits(), 0b11::2, encode_varint(id - offset, 5)::bits(),
        encode_varint(num, 7)::bits()>>
    )
  end

  defp encode_cards([{id, num} | rest], offset, acc) do
    encode_cards(rest, id, <<acc::bits(), num - 1::2, encode_varint(id - offset, 5)::bits()>>)
  end

  defp encode_varint(n, bit) when n < 1 <<< bit do
    <<0::1, n::size(bit)>>
  end

  defp encode_varint(n, bit) do
    <<1::1, n::size(bit), encode_varint(n >>> bit, 7)::bits()>>
  end

  defp calc_checksum(bytes) do
    bytes
    |> :binary.bin_to_list()
    |> Enum.sum() &&& 0xFF
  end
end
