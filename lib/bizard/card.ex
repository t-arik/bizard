defmodule Bizard.Card do
  @enforce_keys [:color]
  defstruct [:color, :value]

  defmacro red, do: :red
  defmacro blue, do: :blue
  defmacro green, do: :green
  defmacro yellow, do: :yellow
  defmacro wizard, do: quote(do: %Bizard.Card{color: :wizard})
  defmacro jester, do: quote(do: %Bizard.Card{color: :jester})
end
