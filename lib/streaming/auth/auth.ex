defmodule Streaming.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Streaming.Repo
  alias Comeonin.Bcrypt

  alias Streaming.Auth.User


  def authenticate_admin(email, plain_text_password) do
    query = from u in User, where: u.email == ^email
    Repo.one(query)
    |> check_password(plain_text_password)
      |>check_admin()
  end

  def authenticate_user(email, plain_text_password) do
    query = from u in User, where: u.email == ^email
    Repo.one(query)
    |> check_password(plain_text_password)
  end

defp check_admin({:ok, user}) do
   case user.is_admin do
     true -> {:ok,user}
     false -> {:error, "The specified user and password doesn't belong to an admin user"}
   end
end
defp check_admin({:error, message}) do
  {:error,message}
end


  defp check_password(nil, _), do: {:error, "Incorrect username or password"}
  defp check_password(user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end
  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end


  def get_by_token(token) do
  Repo.get_by(User, token: token)
end



def verify_email(%User{} = user) do
  user
  |> User.verify_changeset()
  |> Repo.update()
end


end
