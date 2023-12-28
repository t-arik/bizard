defmodule Bizard.Templates do
  require EEx

  EEx.function_from_file(
    :def,
    :index,
    "lib/bizard/template/index.heex",
    [:content]
  )

  EEx.function_from_file(
    :def,
    :register,
    "lib/bizard/template/register.heex"
  )

  EEx.function_from_file(
    :def,
    :game,
    "lib/bizard/template/game.heex"
  )
end
