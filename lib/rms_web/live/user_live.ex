defmodule RmsWeb.UserLive do
  use RmsWeb, :live_view

  alias Rms.Users
  alias Rms.Users.User



  @impl true
  def mount(_params, _session, socket) do

    aoss =
    [
      %Occupation{id: 1, title: "Software Engineer", fos: "IT"},
      %Occupation{id: 2, title: "Line Manager", fos: "CS"}
    ]

    |> build_occupations()

    {:ok, multiselect_occupation(socket, aoss)}

  end

  defp multiselect_occupation(socket, aoss) do
    changeset = Rms.change_user(user)

    socket
    |> assign(:changeset, changeset)
    |> assign(:aoss, aoss)
    |> assign(:greetings, "Hello User, Welcome Aboard!!")
    |> assign(:users,filter_users(aos))
  end

  @impl true
  def handle_info({:updated_occupation, occupation}, socket) do
    {:noreply, multiselect_occupation(socket, occupation)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_event(socket, socket.assigns.live_action, params)}
  end

  defp build_options(options) do
    Enum.map(occupation,
      fn {_idx, data} -> %SelectOccupation{id: data["id"], fos: data["fos"], title: data["title"]}
      data -> %SelectOccupation{id: data.id, fos: data.fos, title: data.title}
    end)
  end

  defp filter_users(occupation) do
    selected_occupation =
      Enum.flat_map(occupation, fn occ ->
        if occ.title in [true, "true"] do
          [occ.title]
        else
          []
        end
    end)

    if selected_occupation == [] do
      Users.list_users()
    else
      Users.get_users_by_aos(selected_occupation)
    end
  end

  defp apply_event(socket, :index, _params) do
    socket
    |> assign(:page_title, "List of Users")
    |> assign(:user, nil)
  end

  defp apply_event(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Users.get_user!(id))
  end

  defp apply_event(socket, :new, _params) do
    socket
    |> assign(:page_title, "New user")
    |> assign(:user, %User{})
  end


  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Users.get_user!(id)
    {:ok, _} = Users.delete_user(user)

    {:noreply, assign(socket, :users, list_users())}
  end



  defp list_users do
    Users.list_users()
  end

end
