defmodule WaldonWeb.LeaseLive.Show do
  use WaldonWeb, :live_view

  alias Waldon.Leases

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:lease, Leases.get_lease!(id))}
  end

  defp page_title(:show), do: "Show Lease"
  defp page_title(:edit), do: "Edit Lease"
end
