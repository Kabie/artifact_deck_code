defmodule ArtifactDeckCodeTest do
  use ExUnit.Case
  doctest ArtifactDeckCode

  @example_deck_code_v1 "ADCFWllfTm7AYMJFXhdAbLdAYuapQGDgZAmAYsaA7sBoAE_"
  @example_deck_code_v2 "ADCJWkTZX05uwGDCRV4XQGy3QGLmqUBg4GQJgGLGgO7AaABR3JlZW4vQmxhY2sgRXhhbXBsZQ__"
  @example_deck %{
    heroes: [{4005, 2}, {10014, 1}, {10017, 3}, {10026, 1}, {10047, 1}],
    cards: [
      {3000, 2},
      {3001, 1},
      {10091, 3},
      {10102, 3},
      {10128, 3},
      {10165, 3},
      {10168, 3},
      {10169, 3},
      {10185, 3},
      {10223, 1},
      {10234, 3},
      {10260, 1},
      {10263, 1},
      {10322, 3},
      {10354, 3}
    ],
    name: "Green\/Black Example"
  }

  test "encode v1" do
    assert ArtifactDeckCode.encode(@example_deck, 1) == {:ok, @example_deck_code_v1}
  end

  test "encode v2" do
    assert ArtifactDeckCode.encode(@example_deck, 2) == {:ok, @example_deck_code_v2}
  end

  test "decode v1" do
    assert ArtifactDeckCode.decode(@example_deck_code_v1) == {:ok, %{@example_deck | name: ""}}
  end

  test "decode v2" do
    assert ArtifactDeckCode.decode(@example_deck_code_v2) == {:ok, @example_deck}
  end

  @huge_count_deck %{name: "", heroes: [], cards: [{10111, 10111}]}
  @huge_count_deck_code "ADCIAkA-7sC-04_"

  test "encode huge count" do
    assert ArtifactDeckCode.encode(@huge_count_deck) == {:ok, @huge_count_deck_code}
  end

  test "decode huge count" do
    assert ArtifactDeckCode.decode(@huge_count_deck_code) == {:ok, @huge_count_deck}
  end
end
