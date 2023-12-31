defmodule Bizard.Template do
  require EEx

  EEx.function_from_file(
    :def,
    :index,
    "views/index.heex",
    [:content]
  )

  EEx.function_from_file(
    :def,
    :register,
    "views/register.heex"
  )

  EEx.function_from_file(
    :def,
    :game,
    "views/game.heex",
    [:game, :player]
  )
end
