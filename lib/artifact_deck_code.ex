defmodule ArtifactDeckCode do
  @moduledoc """
  Documentation for ArtifactDeckCode.
  """


  def encode(deck) do
    __MODULE__.Encoder.encode_deck(deck)
  end

end
