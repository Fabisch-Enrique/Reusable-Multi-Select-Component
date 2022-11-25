defmodule RmsWeb.UserLive do
  use RmsWeb, :live_view

  alias Rms.Repo
  alias Rms.Users.User

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:users, Repo.all(User))}
  end

  def render(assigns) do
    ~H"""



    <div>

      <%= for user <- @users do%>

        <h1><%= user.name%></h1>
        <div class="dropdown">
        <span><%= user.aos %></span>

        <div class={if(Enum.count(user.occupation, fn occ -> occ.selected == false end) > 0, do: "dropdown-content")}>


          <%= for unselected_occupation <- Enum.filter(user.occupation, fn occ -> occ.selected == false end) do %>

          <div style="display: flex; flex-direction: row;" class="unselected_hover">

          <span
          phx-click={"select_user"}
          phx-value-user_id={user.id}
          phx-value-occupation_id={unselected_occupation.id}
          >

            <%= unselected_occupation.fos %>
          </span>
        </div>
          <% end %>
        </div>

        <div style="display: flex; flex-direction: row;">
        <%= for occupation <- Enum.filter(user.occupation, fn occ -> occ.selected == true end) do%>

          <span
          style="margin: 10px; background-color: purple; padding: 10px; border-radius: 5px; color: white;"
          phx-click={"deselect_user"}
          phx-value-user_id={user.id}
          phx-value-occupation_id={occupation.id}
          >

            <%= occupation.fos %>
          </span>
        <% end %>
        </div>
        </div>
      <% end %>
    </div>

    """
  end

  def handle_event(
        "select_user",
        %{"user_id" => user_id, "occupation_id" => occupation_id},
        socket
      ) do
    user = Rms.Repo.get(User, user_id)

    user_occupations =
      user.occupation
      |> Enum.map(fn occ ->
        occupation_struct = Map.from_struct(occ)

        if occ.id == occupation_id do
          occupation_struct
          |> Map.update!(:selected, fn _ -> true end)
        else
          occupation_struct
        end
      end)

    user
    |> Ecto.Changeset.change(%{occupation: user_occupations})
    |> Rms.Repo.update()
    |> IO.inspect()
    |> case do
      {:ok, _user} ->
        {:noreply, socket |> assign(:users, Repo.all(User))}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event(
        "deselect_user",
        %{"user_id" => user_id, "occupation_id" => occupation_id},
        socket
      ) do
    user = Rms.Repo.get(User, user_id)

    user_occupations =
      user.occupation
      |> Enum.map(fn occ ->
        occupation_struct = Map.from_struct(occ)

        if occ.id == occupation_id do
          occupation_struct
          |> Map.update!(:selected, fn _ -> false end)
        else
          occupation_struct
        end
      end)

    user
    |> Ecto.Changeset.change(%{occupation: user_occupations})
    |> Rms.Repo.update()
    |> IO.inspect()
    |> case do
      {:ok, _user} ->
        {:noreply, socket |> assign(:users, Repo.all(User))}

      _ ->
        {:noreply, socket}
    end
  end
end
