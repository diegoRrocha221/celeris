defmodule Celeris.Template do
  @moduledoc """
  A simple template interpreter for .html.cel files
  """

  def render(template_path, assigns \\ %{}) do
    template_path
    |> File.read!()
    |> EEx.eval_string(assigns)
  end
end
