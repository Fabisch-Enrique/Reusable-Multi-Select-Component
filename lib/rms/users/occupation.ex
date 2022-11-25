defmodule Rms.Users.Occupation do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :fos, :string
    field :selected, :boolean, default: false

    timestamps()
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, [:fos])
  end

end
