defmodule Rms.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :age, :integer
    field :aos, :string

    embeds_many :occupation, Occupation do
      field :title, :string
      field :fos, :string
    end

    timestamps()
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:aos, :age])
    |> cast_embed(:occupation, with: &occupation_changeset/2)
    |> validate_required([:aos, :age])
  end

  defp occupation_changeset(schema, attrs) do
    schema
    |> cast(attrs, [:title, :fos])
  end
end
