defmodule WaldonWeb.LeaseLive.Index do
  use WaldonWeb, :live_view

  alias Waldon.Leases
  alias Waldon.Leases.Lease

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Waldon.PubSub, "tenant:search")
    {:ok, assign(socket, leases: list_leases(), selected_tenants: [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Lease")
    |> assign(:lease, Leases.get_lease!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Lease")
    |> assign(:lease, %Lease{} |> Waldon.Repo.preload(:tenants))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Leases")
    |> assign(:lease, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    lease = Leases.get_lease!(id)
    {:ok, _} = Leases.delete_lease(lease)

    {:noreply, assign(socket, :leases, list_leases())}
  end

  defp list_leases do
    Leases.list_leases()
  end
end
