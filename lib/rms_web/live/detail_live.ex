defmodule RmsWeb.DetailLive do
  use RmsWeb, :live_view

  alias Rms.Users.User
  alias Rms.Repo

  def mount(%{"id" => id}, _session, socket) do
    {:ok,
      socket
      |> assign(:user_id, id)
      |> assign(:user, Repo.get(User, id))}
  end

  def handle_event(
        "update_selected",
        %{"occupation-id" => occupation_id},
        %{assigns: %{user: user}} = socket
      ) do
    user_occupations =
      user.occupation
      |> Enum.map(fn occ ->
        occupation_struct = Map.from_struct(occ)

        if occ.id == occupation_id do
          occupation_struct
          |> Map.update!(:selected, fn _ -> !occupation_struct.selected end)
        else
          occupation_struct
        end
      end)

    user
    |> Ecto.Changeset.change(%{occupation: user_occupations})
    |> Rms.Repo.update()
    |> case do
      {:ok, user} ->
        {:noreply, socket |> assign(:user, user)}

      _ ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div>

      <h1><%= @user.name%></h1>
    <div class="dropdown">
      <div>
        <%= for unselected_occupation <- @user.occupation do %>

          <div style="display:flex;">
            <%= checkbox(:form, unselected_occupation.fos,id: unselected_occupation.id, phx_click: "update_selected", phx_value_occupation_id: unselected_occupation.id, value: unselected_occupation.selected) %>
            <label for={unselected_occupation.id}><%= unselected_occupation.fos %></label>

          </div>
        <% end %>
      </div>

        <div class = "dropdown" style="display: flex; flex-direction: row;">

        <%= for occupation <- Enum.filter(@user.occupation, fn occ -> occ.selected == true end) do%>



          <span
          style="margin: 10px; background-color: purple; padding: 10px; border-radius: 5px; color: white;"
          phx-click={"update_selected"}
          phx-value-occupation-id={occupation.id}
          >

            <%= occupation.fos %>

          </span>

        <% end %>

        </div>
    </div>
    </div>

    """
  end
end
