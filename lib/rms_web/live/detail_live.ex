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

  def render(assigns) do
    ~H"""
    <div>
      <h1><%= @user.name%></h1>
      <div class="relative">
      <.live_component
        id="multi-select"
        module={RmsWeb.MultiSelectComponent}
        user={@user}
        >
      </.live_component>
      </div>
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
