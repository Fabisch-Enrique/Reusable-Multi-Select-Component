defmodule RmsWeb.MultiSelectComponent do
  use RmsWeb, :live_component

  alias Phoenix.LiveView.JS

  def update(params, socket) do
    %{id: id, values: selected_listing, form: form} = params

    {:ok,
     socket
     |> assign(:id, id)
     |> assign(:form, form)
     |> assign(:selected_values, filter_selected_value(selected_listing))}
  end

  def handle_event("update_selected", %{"occupation-id" => selected_occupation_id}, socket) do
    send(self(), {:update_occupation, selected_occupation_id})

    {:noreply, socket}
  end

  defp filter_selected_value(occupation) do
    Enum.filter(occupation, fn occ -> occ.selected == true end)
  end

end
