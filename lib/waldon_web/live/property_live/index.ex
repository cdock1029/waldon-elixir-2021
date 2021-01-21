defmodule WaldonWeb.PropertyLive.Index do
  use WaldonWeb, :live_view

  alias Waldon.Properties
  alias Waldon.Properties.Property

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :properties, list_properties())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Property")
    |> assign(:property, Properties.get_property!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Property")
    |> assign(:property, %Property{units: []})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Properties")
    |> assign(:property, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    property = Properties.get_property!(id)
    {:ok, _} = Properties.delete_property(property)

    {:noreply, assign(socket, :properties, list_properties())}
  end

  defp list_properties do
    Properties.list_properties()
  end
end
