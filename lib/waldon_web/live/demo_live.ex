defmodule WaldonWeb.DemoLive do
  use WaldonWeb, :live_view

  def mount(socket) do
    # {:ok, assign(socket, show_solutions: false)}
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h2>Demo page</h2>
    """
  end
end
