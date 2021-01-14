defmodule WaldonWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `WaldonWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, WaldonWeb.PropertyLive.FormComponent,
        id: @property.id || :new,
        action: @live_action,
        property: @property,
        return_to: Routes.property_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, WaldonWeb.ModalComponent, modal_opts)
  end
end
