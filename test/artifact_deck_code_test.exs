defmodule ArtifactDeckCodeTest do
  use ExUnit.Case
  doctest ArtifactDeckCode


  test "Encoder" do
    %{name: "test deck",
      heroes: [{4002, 1}, {4001, 1}, {4001, 1}],
      cards: [],
    }
    |> ArtifactDeckCode.encode()
    |> IO.inspect()
  end


  test "Decoder" do
    "ADCJWkTZX05uwGDCRV4XQGy3QGLmqUBg4GQJgGLGgO7AaABR3JlZW4vQmxhY2sgRXhhbXBsZQ__"
    |> ArtifactDeckCode.Decoder.parse_deck()
    # |> IO.inspect()
  end
end
