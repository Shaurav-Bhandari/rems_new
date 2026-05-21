defmodule BinduBackend.PlansTest do
  use BinduBackend.DataCase

  alias BinduBackend.Plans

  describe "plans" do
    alias BinduBackend.Plans.Plan

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.PlansFixtures

    @invalid_attrs %{
      name: nil,
      description: nil,
      price: nil,
      billing_cycle: nil,
      max_restaurants: nil,
      max_users: nil,
      is_active: nil
    }

    test "list_plans/1 returns all scoped plans" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan = plan_fixture(scope)
      other_plan = plan_fixture(other_scope)
      assert Plans.list_plans(scope) == [plan]
      assert Plans.list_plans(other_scope) == [other_plan]
    end

    test "get_plan!/2 returns the plan with given id" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      other_scope = user_scope_fixture()
      assert Plans.get_plan!(scope, plan.id) == plan
      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(other_scope, plan.id) end
    end

    test "create_plan/2 with valid data creates a plan" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        price: "120.5",
        billing_cycle: "some billing_cycle",
        max_restaurants: 42,
        max_users: 42,
        is_active: true
      }

      scope = user_scope_fixture()

      assert {:ok, %Plan{} = plan} = Plans.create_plan(scope, valid_attrs)
      assert plan.name == "some name"
      assert plan.description == "some description"
      assert plan.price == Decimal.new("120.5")
      assert plan.billing_cycle == "some billing_cycle"
      assert plan.max_restaurants == 42
      assert plan.max_users == 42
      assert plan.is_active == true
      assert plan.user_id == scope.user.id
    end

    test "create_plan/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.create_plan(scope, @invalid_attrs)
    end

    test "update_plan/3 with valid data updates the plan" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        price: "456.7",
        billing_cycle: "some updated billing_cycle",
        max_restaurants: 43,
        max_users: 43,
        is_active: false
      }

      assert {:ok, %Plan{} = plan} = Plans.update_plan(scope, plan, update_attrs)
      assert plan.name == "some updated name"
      assert plan.description == "some updated description"
      assert plan.price == Decimal.new("456.7")
      assert plan.billing_cycle == "some updated billing_cycle"
      assert plan.max_restaurants == 43
      assert plan.max_users == 43
      assert plan.is_active == false
    end

    test "update_plan/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan = plan_fixture(scope)

      assert_raise MatchError, fn ->
        Plans.update_plan(other_scope, plan, %{})
      end
    end

    test "update_plan/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Plans.update_plan(scope, plan, @invalid_attrs)
      assert plan == Plans.get_plan!(scope, plan.id)
    end

    test "delete_plan/2 deletes the plan" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert {:ok, %Plan{}} = Plans.delete_plan(scope, plan)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(scope, plan.id) end
    end

    test "delete_plan/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert_raise MatchError, fn -> Plans.delete_plan(other_scope, plan) end
    end

    test "change_plan/2 returns a plan changeset" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert %Ecto.Changeset{} = Plans.change_plan(scope, plan)
    end
  end

  describe "plan_features" do
    alias BinduBackend.Plans.Plan_Feature

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.PlansFixtures

    @invalid_attrs %{is_enabled: nil, feature_name: nil, feature_value: nil}

    test "list_plan_features/1 returns all scoped plan_features" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)
      other_plan__feature = plan__feature_fixture(other_scope)
      assert Plans.list_plan_features(scope) == [plan__feature]
      assert Plans.list_plan_features(other_scope) == [other_plan__feature]
    end

    test "get_plan__feature!/2 returns the plan__feature with given id" do
      scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)
      other_scope = user_scope_fixture()
      assert Plans.get_plan__feature!(scope, plan__feature.id) == plan__feature

      assert_raise Ecto.NoResultsError, fn ->
        Plans.get_plan__feature!(other_scope, plan__feature.id)
      end
    end

    test "create_plan__feature/2 with valid data creates a plan__feature" do
      valid_attrs = %{
        is_enabled: true,
        feature_name: "some feature_name",
        feature_value: "some feature_value"
      }

      scope = user_scope_fixture()

      assert {:ok, %Plan_Feature{} = plan__feature} =
               Plans.create_plan__feature(scope, valid_attrs)

      assert plan__feature.is_enabled == true
      assert plan__feature.feature_name == "some feature_name"
      assert plan__feature.feature_value == "some feature_value"
      assert plan__feature.user_id == scope.user.id
    end

    test "create_plan__feature/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.create_plan__feature(scope, @invalid_attrs)
    end

    test "update_plan__feature/3 with valid data updates the plan__feature" do
      scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)

      update_attrs = %{
        is_enabled: false,
        feature_name: "some updated feature_name",
        feature_value: "some updated feature_value"
      }

      assert {:ok, %Plan_Feature{} = plan__feature} =
               Plans.update_plan__feature(scope, plan__feature, update_attrs)

      assert plan__feature.is_enabled == false
      assert plan__feature.feature_name == "some updated feature_name"
      assert plan__feature.feature_value == "some updated feature_value"
    end

    test "update_plan__feature/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)

      assert_raise MatchError, fn ->
        Plans.update_plan__feature(other_scope, plan__feature, %{})
      end
    end

    test "update_plan__feature/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Plans.update_plan__feature(scope, plan__feature, @invalid_attrs)

      assert plan__feature == Plans.get_plan__feature!(scope, plan__feature.id)
    end

    test "delete_plan__feature/2 deletes the plan__feature" do
      scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)
      assert {:ok, %Plan_Feature{}} = Plans.delete_plan__feature(scope, plan__feature)

      assert_raise Ecto.NoResultsError, fn ->
        Plans.get_plan__feature!(scope, plan__feature.id)
      end
    end

    test "delete_plan__feature/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)
      assert_raise MatchError, fn -> Plans.delete_plan__feature(other_scope, plan__feature) end
    end

    test "change_plan__feature/2 returns a plan__feature changeset" do
      scope = user_scope_fixture()
      plan__feature = plan__feature_fixture(scope)
      assert %Ecto.Changeset{} = Plans.change_plan__feature(scope, plan__feature)
    end
  end

  describe "subscriptions" do
    alias BinduBackend.Plans.Subscription

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.PlansFixtures

    @invalid_attrs %{status: nil, start_date: nil, end_date: nil, auto_renew: nil}

    test "list_subscriptions/1 returns all scoped subscriptions" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      subscription = subscription_fixture(scope)
      other_subscription = subscription_fixture(other_scope)
      assert Plans.list_subscriptions(scope) == [subscription]
      assert Plans.list_subscriptions(other_scope) == [other_subscription]
    end

    test "get_subscription!/2 returns the subscription with given id" do
      scope = user_scope_fixture()
      subscription = subscription_fixture(scope)
      other_scope = user_scope_fixture()
      assert Plans.get_subscription!(scope, subscription.id) == subscription

      assert_raise Ecto.NoResultsError, fn ->
        Plans.get_subscription!(other_scope, subscription.id)
      end
    end

    test "create_subscription/2 with valid data creates a subscription" do
      valid_attrs = %{
        status: "some status",
        start_date: ~D[2026-05-11],
        end_date: ~D[2026-05-11],
        auto_renew: true
      }

      scope = user_scope_fixture()

      assert {:ok, %Subscription{} = subscription} = Plans.create_subscription(scope, valid_attrs)
      assert subscription.status == "some status"
      assert subscription.start_date == ~D[2026-05-11]
      assert subscription.end_date == ~D[2026-05-11]
      assert subscription.auto_renew == true
      assert subscription.user_id == scope.user.id
    end

    test "create_subscription/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.create_subscription(scope, @invalid_attrs)
    end

    test "update_subscription/3 with valid data updates the subscription" do
      scope = user_scope_fixture()
      subscription = subscription_fixture(scope)

      update_attrs = %{
        status: "some updated status",
        start_date: ~D[2026-05-12],
        end_date: ~D[2026-05-12],
        auto_renew: false
      }

      assert {:ok, %Subscription{} = subscription} =
               Plans.update_subscription(scope, subscription, update_attrs)

      assert subscription.status == "some updated status"
      assert subscription.start_date == ~D[2026-05-12]
      assert subscription.end_date == ~D[2026-05-12]
      assert subscription.auto_renew == false
    end

    test "update_subscription/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      subscription = subscription_fixture(scope)

      assert_raise MatchError, fn ->
        Plans.update_subscription(other_scope, subscription, %{})
      end
    end

    test "update_subscription/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      subscription = subscription_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Plans.update_subscription(scope, subscription, @invalid_attrs)

      assert subscription == Plans.get_subscription!(scope, subscription.id)
    end

    test "delete_subscription/2 deletes the subscription" do
      scope = user_scope_fixture()
      subscription = subscription_fixture(scope)
      assert {:ok, %Subscription{}} = Plans.delete_subscription(scope, subscription)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_subscription!(scope, subscription.id) end
    end

    test "delete_subscription/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      subscription = subscription_fixture(scope)
      assert_raise MatchError, fn -> Plans.delete_subscription(other_scope, subscription) end
    end

    test "change_subscription/2 returns a subscription changeset" do
      scope = user_scope_fixture()
      subscription = subscription_fixture(scope)
      assert %Ecto.Changeset{} = Plans.change_subscription(scope, subscription)
    end
  end
end
