defmodule BinduBackend.NotificationsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Notifications

  describe "notifications" do
    alias BinduBackend.Notifications.Notification

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.NotificationsFixtures

    @invalid_attrs %{message: nil, notification_type: nil, is_read: nil}

    test "list_notifications/1 returns all scoped notifications" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      notification = notification_fixture(scope)
      other_notification = notification_fixture(other_scope)
      assert Notifications.list_notifications(scope) == [notification]
      assert Notifications.list_notifications(other_scope) == [other_notification]
    end

    test "get_notification!/2 returns the notification with given id" do
      scope = user_scope_fixture()
      notification = notification_fixture(scope)
      other_scope = user_scope_fixture()
      assert Notifications.get_notification!(scope, notification.id) == notification

      assert_raise Ecto.NoResultsError, fn ->
        Notifications.get_notification!(other_scope, notification.id)
      end
    end

    test "create_notification/2 with valid data creates a notification" do
      valid_attrs = %{
        message: "some message",
        notification_type: "some notification_type",
        is_read: true
      }

      scope = user_scope_fixture()

      assert {:ok, %Notification{} = notification} =
               Notifications.create_notification(scope, valid_attrs)

      assert notification.message == "some message"
      assert notification.notification_type == "some notification_type"
      assert notification.is_read == true
      assert notification.user_id == scope.user.id
    end

    test "create_notification/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Notifications.create_notification(scope, @invalid_attrs)
    end

    test "update_notification/3 with valid data updates the notification" do
      scope = user_scope_fixture()
      notification = notification_fixture(scope)

      update_attrs = %{
        message: "some updated message",
        notification_type: "some updated notification_type",
        is_read: false
      }

      assert {:ok, %Notification{} = notification} =
               Notifications.update_notification(scope, notification, update_attrs)

      assert notification.message == "some updated message"
      assert notification.notification_type == "some updated notification_type"
      assert notification.is_read == false
    end

    test "update_notification/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      notification = notification_fixture(scope)

      assert_raise MatchError, fn ->
        Notifications.update_notification(other_scope, notification, %{})
      end
    end

    test "update_notification/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      notification = notification_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Notifications.update_notification(scope, notification, @invalid_attrs)

      assert notification == Notifications.get_notification!(scope, notification.id)
    end

    test "delete_notification/2 deletes the notification" do
      scope = user_scope_fixture()
      notification = notification_fixture(scope)
      assert {:ok, %Notification{}} = Notifications.delete_notification(scope, notification)

      assert_raise Ecto.NoResultsError, fn ->
        Notifications.get_notification!(scope, notification.id)
      end
    end

    test "delete_notification/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      notification = notification_fixture(scope)

      assert_raise MatchError, fn ->
        Notifications.delete_notification(other_scope, notification)
      end
    end

    test "change_notification/2 returns a notification changeset" do
      scope = user_scope_fixture()
      notification = notification_fixture(scope)
      assert %Ecto.Changeset{} = Notifications.change_notification(scope, notification)
    end
  end
end
