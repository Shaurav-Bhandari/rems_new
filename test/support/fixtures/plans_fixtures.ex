defmodule BinduBackend.PlansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Plans` context.
  """

  @doc """
  Generate a plan.
  """
  def plan_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        billing_cycle: "some billing_cycle",
        description: "some description",
        is_active: true,
        max_restaurants: 42,
        max_users: 42,
        name: "some name",
        price: "120.5"
      })

    {:ok, plan} = BinduBackend.Plans.create_plan(scope, attrs)
    plan
  end

  @doc """
  Generate a plan__feature.
  """
  def plan__feature_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        feature_name: "some feature_name",
        feature_value: "some feature_value",
        is_enabled: true
      })

    {:ok, plan__feature} = BinduBackend.Plans.create_plan__feature(scope, attrs)
    plan__feature
  end

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        auto_renew: true,
        end_date: ~D[2026-05-11],
        start_date: ~D[2026-05-11],
        status: "some status"
      })

    {:ok, subscription} = BinduBackend.Plans.create_subscription(scope, attrs)
    subscription
  end
end
