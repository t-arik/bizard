defmodule Bizard.Template do
  @moduledoc """
  This module loads and provides all HTML templates
  """
  require EEx

  def index(content) do
    EEx.eval_file("views/index.heex", content: content)
  end

  def register() do
    EEx.eval_file("views/register.heex")
  end

  def game(game, player) do
    EEx.eval_file("views/game.heex", game: game, player: player)
  end

  # EEx.function_from_file(
  #   :def,
  #   :index,
  #   "views/index.heex",
  #   [:content]
  # )

  # EEx.function_from_file(
  #   :def,
  #   :register,
  #   "views/register.heex"
  # )

  # EEx.function_from_file(
  #   :def,
  #   :game,
  #   "views/game.heex",
  #   [:game, :player]
  # )
end
