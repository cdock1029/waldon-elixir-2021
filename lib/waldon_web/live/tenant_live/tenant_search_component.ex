defmodule WaldonWeb.TenantLive.TenantSearchComponent do
  use WaldonWeb, :live_component

  import Ecto.Changeset

  alias Waldon.Tenants

  @types %{query: :string}

  def mount(socket) do
    changeset = change({%{}, @types})
    socket = assign(socket, changeset: changeset, results: [])
    {:ok, socket}
  end

  def handle_event("search", %{"search" => search}, socket) do
    search
    |> search_changeset()
    |> case do
      %{valid?: true, changes: %{query: query}} ->
        {:noreply, assign(socket, :results, search(query))}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("select", %{"selected" => selected}, socket) do
    {:noreply, assign(socket, selected: selected)}
  end

  def handle_event("select", _params, socket) do
    {:noreply, assign(socket, selected: [])}
  end

  def handle_event("submit", %{"selected" => selected}, socket) do
    message = {:tenants_selected, selected}
    IO.puts("sending message:")
    IO.inspect(message)
    Phoenix.PubSub.broadcast!(Waldon.PubSub, "tenants:search_selected", message)

    {:noreply, socket}
  end

  def handle_event("submit", params, socket) do
    IO.inspect(params)

    {:noreply, socket}
  end

  defp search_changeset(attrs \\ %{}) do
    cast(
      {%{}, @types},
      attrs,
      [:query]
    )
    |> update_change(:query, &String.trim/1)
    |> validate_required([:query])
  end

  defp search(query) do
    Tenants.search_tenants_full_name(query)
  end
end
