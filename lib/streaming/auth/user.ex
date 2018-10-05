defmodule Streaming.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
 alias Streaming.Manager.Device

  schema "users" do
    field :password, :string

    field :email, :string, unique: true

    timestamps()

    has_many :devices, Streaming.Manager.Device

  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_pass_hash()

  end

  def validate_admin(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, admin ->
      case admin do
        true -> []
        false -> [{field, options[:message] || "This user is not admin"}]
      end
    end)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
  change(changeset, password: Bcrypt.hashpwsalt(password))
    end
defp put_pass_hash(changeset), do: changeset
end
