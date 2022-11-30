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
        <%= link user.name, to: Routes.detail_path(@socket,:index, user.id) %>
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
    |> case do
      {:ok, _user} ->
        {:noreply, socket |> assign(:users, Repo.all(User))}

      _ ->
        {:noreply, socket}
    end
  end
end
