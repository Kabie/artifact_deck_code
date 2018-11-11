defmodule ArtifactDeckCode do
  @moduledoc """
  Encoder and decoder for Artifact decks.
  """

  @current_version 2

  @type deck_code() :: binary()

  @type deck() :: %{
          name: String.t(),
          heroes: [{id :: pos_integer(), turn :: pos_integer()}],
          cards: [{id :: pos_integer(), count :: pos_integer()}]
        }

  @doc """
  Encode an Artifact deck into a binary string.
  """
  @spec encode(deck :: deck(), version :: pos_integer()) :: {:ok, deck_code()} | {:error, atom()}
  defdelegate encode(deck, version \\ @current_version), to: __MODULE__.Encoder

  @doc """
  Decode a deck code string into a map representing an Artifact deck.
  """
  @spec decode(deck_code :: deck_code()) :: {:ok, deck()} | {:error, atom()}
  defdelegate decode(deck_code), to: __MODULE__.Decoder
end
