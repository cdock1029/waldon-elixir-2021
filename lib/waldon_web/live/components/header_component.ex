defmodule WaldonWeb.HeaderComponent do
  use WaldonWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :lv_header, true)
    {:ok, socket}
  end
end
