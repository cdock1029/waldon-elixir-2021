defmodule WaldonWeb.LeaseLive.FormComponent do
  use WaldonWeb, :live_component

  alias Waldon.Leases
  alias Waldon.Tenants

  @impl true
  def update(%{lease: lease} = assigns, socket) do
    changeset = Leases.change_lease(lease)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset, query: "", results: [])}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    IO.puts("suggest: #{query}")
    socket = assign(socket, results: search(query), query: query)
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"lease" => lease_params, "q" => query}, socket) do
    changeset =
      socket.assigns.lease
      |> Leases.change_lease(lease_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset, results: search(query), query: query)}
  end

  def handle_event("save", %{"lease" => lease_params}, socket) do
    save_lease(socket, socket.assigns.action, lease_params)
  end

  defp save_lease(socket, :edit, lease_params) do
    case Leases.update_lease(socket.assigns.lease, lease_params) do
      {:ok, _lease} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lease updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_lease(socket, :new, lease_params) do
    case Leases.create_lease(lease_params) do
      {:ok, _lease} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lease created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp search(query) do
    Tenants.search_tenants_full_name(query)
  end
end
