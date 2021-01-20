defmodule WaldonWeb.PropertyLive.Show do
  use WaldonWeb, :live_view

  alias Waldon.Properties
  alias Waldon.Properties.Unit

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)
     |> assign(:property, Properties.get_property!(id))}
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Show Property")
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Property")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Unit for Property")
    |> assign(:unit, %Unit{})
  end

  defp apply_action(socket, :edit_unit, %{"uid" => uid}) do
    socket
    |> assign(:page_title, "Edit Unit")
    |> assign(:unit, Properties.get_unit!(uid))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    unit = Properties.get_unit!(id)
    {:ok, _} = Properties.delete_unit(unit)
    {:noreply, assign(socket, :property, Properties.get_property!(socket.assigns.property.id))}
  end
end
