defmodule Bizard.Card do
  @enforce_keys [:suit]
  defstruct [:suit, :value]

  defmacro red, do: :red
  defmacro blue, do: :blue
  defmacro green, do: :green
  defmacro yellow, do: :yellow
  defmacro wizard, do: quote(do: %Bizard.Card{suit: :wizard})
  defmacro jester, do: quote(do: %Bizard.Card{suit: :jester})
end
