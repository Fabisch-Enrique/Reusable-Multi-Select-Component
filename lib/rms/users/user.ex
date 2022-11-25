defmodule Rms.Users.User do
  use Ecto.Schema

  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :age, :integer
    field :aos,  :string

    embeds_many :occupation, Rms.Users.Occupation, on_replace: :delete

    timestamps()
  end


  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age, :aos])
    |> cast_embed(:occupation, required: true, with: &Rms.Users.Occupation.changeset/2)
    |> validate_required([:name, :age, :aos])
  end

  def occupation_changeset(user, occupation \\ []) do
    user
    |> put_embed(:occupation, occupation)
  end
end
