defmodule BinduBackend.Plans do
  @moduledoc """
  The Plans context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Plans.Plan
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any plan changes.

  The broadcasted messages match the pattern:

    * {:created, %Plan{}}
    * {:updated, %Plan{}}
    * {:deleted, %Plan{}}

  """
  def subscribe_plans(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:plans")
  end

  defp broadcast_plan(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:plans", message)
  end

  @doc """
  Returns the list of plans.

  ## Examples

      iex> list_plans(scope)
      [%Plan{}, ...]

  """
  def list_plans(%Scope{} = scope) do
    Repo.all_by(Plan, user_id: scope.user.id)
  end

  @doc """
  Gets a single plan.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan!(scope, 123)
      %Plan{}

      iex> get_plan!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_plan!(%Scope{} = scope, id) do
    Repo.get_by!(Plan, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a plan.

  ## Examples

      iex> create_plan(scope, %{field: value})
      {:ok, %Plan{}}

      iex> create_plan(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan(%Scope{} = scope, attrs) do
    with {:ok, plan = %Plan{}} <-
           %Plan{}
           |> Plan.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_plan(scope, {:created, plan})
      {:ok, plan}
    end
  end

  @doc """
  Updates a plan.

  ## Examples

      iex> update_plan(scope, plan, %{field: new_value})
      {:ok, %Plan{}}

      iex> update_plan(scope, plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plan(%Scope{} = scope, %Plan{} = plan, attrs) do
    true = plan.user_id == scope.user.id

    with {:ok, plan = %Plan{}} <-
           plan
           |> Plan.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_plan(scope, {:updated, plan})
      {:ok, plan}
    end
  end

  @doc """
  Deletes a plan.

  ## Examples

      iex> delete_plan(scope, plan)
      {:ok, %Plan{}}

      iex> delete_plan(scope, plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plan(%Scope{} = scope, %Plan{} = plan) do
    true = plan.user_id == scope.user.id

    with {:ok, plan = %Plan{}} <-
           Repo.delete(plan) do
      broadcast_plan(scope, {:deleted, plan})
      {:ok, plan}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plan changes.

  ## Examples

      iex> change_plan(scope, plan)
      %Ecto.Changeset{data: %Plan{}}

  """
  def change_plan(%Scope{} = scope, %Plan{} = plan, attrs \\ %{}) do
    true = plan.user_id == scope.user.id

    Plan.changeset(plan, attrs, scope)
  end

  alias BinduBackend.Plans.Plan_Feature
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any plan__feature changes.

  The broadcasted messages match the pattern:

    * {:created, %Plan_Feature{}}
    * {:updated, %Plan_Feature{}}
    * {:deleted, %Plan_Feature{}}

  """
  def subscribe_plan_features(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:plan_features")
  end

  defp broadcast_plan__feature(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:plan_features", message)
  end

  @doc """
  Returns the list of plan_features.

  ## Examples

      iex> list_plan_features(scope)
      [%Plan_Feature{}, ...]

  """
  def list_plan_features(%Scope{} = _scope) do
    Repo.all(Plan_Feature)
  end

  @doc """
  Gets a single plan__feature.

  Raises `Ecto.NoResultsError` if the Plan  feature does not exist.

  ## Examples

      iex> get_plan__feature!(scope, 123)
      %Plan_Feature{}

      iex> get_plan__feature!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_plan__feature!(%Scope{} = _scope, id) do
    Repo.get!(Plan_Feature, id)
  end

  @doc """
  Creates a plan__feature.

  ## Examples

      iex> create_plan__feature(scope, %{field: value})
      {:ok, %Plan_Feature{}}

      iex> create_plan__feature(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan__feature(%Scope{} = scope, attrs) do
    with {:ok, plan__feature = %Plan_Feature{}} <-
           %Plan_Feature{}
           |> Plan_Feature.changeset(attrs)
           |> Repo.insert() do
      broadcast_plan__feature(scope, {:created, plan__feature})
      {:ok, plan__feature}
    end
  end

  @doc """
  Updates a plan__feature.

  ## Examples

      iex> update_plan__feature(scope, plan__feature, %{field: new_value})
      {:ok, %Plan_Feature{}}

      iex> update_plan__feature(scope, plan__feature, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plan__feature(%Scope{} = scope, %Plan_Feature{} = plan__feature, attrs) do
    with {:ok, plan__feature = %Plan_Feature{}} <-
           plan__feature
           |> Plan_Feature.changeset(attrs)
           |> Repo.update() do
      broadcast_plan__feature(scope, {:updated, plan__feature})
      {:ok, plan__feature}
    end
  end

  @doc """
  Deletes a plan__feature.

  ## Examples

      iex> delete_plan__feature(scope, plan__feature)
      {:ok, %Plan_Feature{}}

      iex> delete_plan__feature(scope, plan__feature)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plan__feature(%Scope{} = scope, %Plan_Feature{} = plan__feature) do
    with {:ok, plan__feature = %Plan_Feature{}} <-
           Repo.delete(plan__feature) do
      broadcast_plan__feature(scope, {:deleted, plan__feature})
      {:ok, plan__feature}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plan__feature changes.

  ## Examples

      iex> change_plan__feature(scope, plan__feature)
      %Ecto.Changeset{data: %Plan_Feature{}}

  """
  def change_plan__feature(%Scope{} = _scope, %Plan_Feature{} = plan__feature, attrs \\ %{}) do
    Plan_Feature.changeset(plan__feature, attrs)
  end

  alias BinduBackend.Plans.Subscription
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any subscription changes.

  The broadcasted messages match the pattern:

    * {:created, %Subscription{}}
    * {:updated, %Subscription{}}
    * {:deleted, %Subscription{}}

  """
  def subscribe_subscriptions(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:subscriptions")
  end

  defp broadcast_subscription(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:subscriptions", message)
  end

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions(scope)
      [%Subscription{}, ...]

  """
  def list_subscriptions(%Scope{} = scope) do
    Repo.all_by(Subscription, user_id: scope.user.id)
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(scope, 123)
      %Subscription{}

      iex> get_subscription!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(%Scope{} = scope, id) do
    Repo.get_by!(Subscription, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(scope, %{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(%Scope{} = scope, attrs) do
    with {:ok, subscription = %Subscription{}} <-
           %Subscription{}
           |> Subscription.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_subscription(scope, {:created, subscription})
      {:ok, subscription}
    end
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(scope, subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(scope, subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Scope{} = scope, %Subscription{} = subscription, attrs) do
    true = subscription.user_id == scope.user.id

    with {:ok, subscription = %Subscription{}} <-
           subscription
           |> Subscription.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_subscription(scope, {:updated, subscription})
      {:ok, subscription}
    end
  end

  @doc """
  Deletes a subscription.

  ## Examples

      iex> delete_subscription(scope, subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(scope, subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Scope{} = scope, %Subscription{} = subscription) do
    true = subscription.user_id == scope.user.id

    with {:ok, subscription = %Subscription{}} <-
           Repo.delete(subscription) do
      broadcast_subscription(scope, {:deleted, subscription})
      {:ok, subscription}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(scope, subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Scope{} = scope, %Subscription{} = subscription, attrs \\ %{}) do
    true = subscription.user_id == scope.user.id

    Subscription.changeset(subscription, attrs, scope)
  end
end
