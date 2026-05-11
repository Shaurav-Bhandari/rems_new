defmodule BinduBackend.Menus do
  @moduledoc """
  The Menus context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Menus.Menu
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any menu changes.

  The broadcasted messages match the pattern:

    * {:created, %Menu{}}
    * {:updated, %Menu{}}
    * {:deleted, %Menu{}}

  """
  def subscribe_menus_category(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:menus_category")
  end

  defp broadcast_menu(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:menus_category", message)
  end

  @doc """
  Returns the list of menus_category.

  ## Examples

      iex> list_menus_category(scope)
      [%Menu{}, ...]

  """
  def list_menus_category(%Scope{} = scope) do
    Repo.all_by(Menu, user_id: scope.user.id)
  end

  @doc """
  Gets a single menu.

  Raises `Ecto.NoResultsError` if the Menu does not exist.

  ## Examples

      iex> get_menu!(scope, 123)
      %Menu{}

      iex> get_menu!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_menu!(%Scope{} = scope, id) do
    Repo.get_by!(Menu, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a menu.

  ## Examples

      iex> create_menu(scope, %{field: value})
      {:ok, %Menu{}}

      iex> create_menu(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_menu(%Scope{} = scope, attrs) do
    with {:ok, menu = %Menu{}} <-
           %Menu{}
           |> Menu.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_menu(scope, {:created, menu})
      {:ok, menu}
    end
  end

  @doc """
  Updates a menu.

  ## Examples

      iex> update_menu(scope, menu, %{field: new_value})
      {:ok, %Menu{}}

      iex> update_menu(scope, menu, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_menu(%Scope{} = scope, %Menu{} = menu, attrs) do
    true = menu.user_id == scope.user.id

    with {:ok, menu = %Menu{}} <-
           menu
           |> Menu.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_menu(scope, {:updated, menu})
      {:ok, menu}
    end
  end

  @doc """
  Deletes a menu.

  ## Examples

      iex> delete_menu(scope, menu)
      {:ok, %Menu{}}

      iex> delete_menu(scope, menu)
      {:error, %Ecto.Changeset{}}

  """
  def delete_menu(%Scope{} = scope, %Menu{} = menu) do
    true = menu.user_id == scope.user.id

    with {:ok, menu = %Menu{}} <-
           Repo.delete(menu) do
      broadcast_menu(scope, {:deleted, menu})
      {:ok, menu}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking menu changes.

  ## Examples

      iex> change_menu(scope, menu)
      %Ecto.Changeset{data: %Menu{}}

  """
  def change_menu(%Scope{} = scope, %Menu{} = menu, attrs \\ %{}) do
    true = menu.user_id == scope.user.id

    Menu.changeset(menu, attrs, scope)
  end
end
