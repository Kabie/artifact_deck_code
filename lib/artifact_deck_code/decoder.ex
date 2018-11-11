defmodule ArtifactDeckCode.Decoder do
  @moduledoc false

  import Bitwise, only: [&&&: 2]

  @prefix "ADC"

  def decode(deck_code) do
    with {:ok, deck_bytes} <- decode_deck(deck_code),
         {:ok, _version, heroes_count, checksum, name, cards_bytes} <- decode_meta(deck_bytes),
         :ok <- match_checksum(cards_bytes, checksum),
         {:ok, heroes, cards_bytes} <- decode_cards(cards_bytes, heroes_count),
         {:ok, cards} <- decode_cards(cards_bytes) do
      {:ok, %{name: name, heroes: heroes, cards: cards}}
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

  defp decode_meta(<<1::4, heroes_count::4, checksum, cards_bytes::bytes()>>) do
    {:ok, 1, heroes_count, checksum, "", cards_bytes}
  end

  defp decode_meta(<<2::4, heroes_count::4, checksum, name_len, rest::bytes()>>) do
    cards_byte_size = byte_size(rest) - name_len
    cards_bytes = binary_part(rest, 0, cards_byte_size)
    name = binary_part(rest, cards_byte_size, name_len)

    {:ok, 2, heroes_count, checksum, name, cards_bytes}
  end

  defp decode_cards(cards_bytes, count \\ -1) do
    decode_cards(cards_bytes, 0, [], count)
  end

  defp decode_cards(rest, _, acc, 0) do
    {:ok, Enum.reverse(acc), rest}
  end

  defp decode_cards(<<0b11::2, 0::1, offset::5, rest::bytes()>>, base_card_id, acc, n) do
    {count, rest} = decode_varint(<<>>, rest)

    card_id = base_card_id + offset
    decode_cards(rest, card_id, [{card_id, count} | acc], n - 1)
  end

  defp decode_cards(<<0b11::2, 1::1, offset_acc::5, rest::bytes()>>, base_card_id, acc, n) do
    {offset, rest} = decode_varint(<<offset_acc::5>>, rest)
    {count, rest} = decode_varint(<<>>, rest)

    card_id = base_card_id + offset
    decode_cards(rest, card_id, [{card_id, count} | acc], n - 1)
  end

  defp decode_cards(<<count::2, 0::1, offset::5, rest::bytes()>>, base_card_id, acc, n) do
    card_id = base_card_id + offset
    decode_cards(rest, card_id, [{card_id, count + 1} | acc], n - 1)
  end

  defp decode_cards(<<count::2, 1::1, offset_acc::5, rest::bytes()>>, base_card_id, acc, n) do
    {offset, rest} = decode_varint(<<offset_acc::5>>, rest)
    card_id = base_card_id + offset
    decode_cards(rest, card_id, [{card_id, count + 1} | acc], n - 1)
  end

  defp decode_cards("", _, acc, _) do
    {:ok, Enum.reverse(acc)}
  end

  defp decode_cards(_, _, _, _) do
    {:error, :unparsable_bytes}
  end

  defp decode_varint(acc, <<0::1, payload::7, rest::bytes()>>) do
    int_bits = <<payload::7, acc::bits>>
    padding_bits = byte_size(int_bits) * 8 - bit_size(int_bits)

    var_int =
      <<0::size(padding_bits), int_bits::bits()>>
      |> :binary.decode_unsigned()

    {var_int, rest}
  end

  defp decode_varint(acc, <<1::1, payload::7, rest::bytes()>>) do
    decode_varint(<<payload::7, acc::bits()>>, rest)
  end

  defp match_checksum(bytes, checksum) do
    sum_last_byte =
      bytes
      |> :binary.bin_to_list()
      |> Enum.sum() &&& 0xFF

    if checksum == sum_last_byte do
      :ok
    else
      {:error, :bad_checksum}
    end
  end
end
