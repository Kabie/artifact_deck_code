defmodule ArtifactDeckCode do
  @current_version 2

  @moduledoc """
  Encoder and decoder for Artifact decks.

  Current version is #{@current_version}.
  """

  @type deck_code() :: binary()

  @type deck() :: %{
          optional(:name) => String.t(),
          heroes: [{id :: pos_integer(), turn :: pos_integer()}],
          cards: [{id :: pos_integer(), count :: pos_integer()}]
        }

  @doc """
  Encode an Artifact deck into a binary string.

  Version 2 supports encoding deck name.
  """
  @spec encode(deck :: deck(), version :: pos_integer()) :: {:ok, deck_code()} | {:error, atom()}
  defdelegate encode(deck, version \\ @current_version), to: __MODULE__.Encoder

  @doc """
  Decode a deck code string into a map representing an Artifact deck.
  """
  @spec decode(deck_code :: deck_code()) :: {:ok, deck()} | {:error, atom()}
  defdelegate decode(deck_code), to: __MODULE__.Decoder
end
