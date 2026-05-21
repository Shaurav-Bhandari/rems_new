defmodule BinduBackend.AuditLogsTest do
  use BinduBackend.DataCase

  alias BinduBackend.AuditLogs

  describe "activity_log" do
    alias BinduBackend.Audit.ActivityLog

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.AuditLogsFixtures

    @invalid_attrs %{action: nil, details: nil, entity_name: nil}

    test "list_activity_logs/1 returns all scoped activity_logs" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)
      other_activity_log = activity_log_fixture(other_scope)
      assert AuditLogs.list_activity_logs(scope) == [activity_log]
      assert AuditLogs.list_activity_logs(other_scope) == [other_activity_log]
    end

    test "get_activity_log!/2 returns the activity_log with given id" do
      scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)
      other_scope = user_scope_fixture()
      assert AuditLogs.get_activity_log!(scope, activity_log.id) == activity_log

      assert_raise Ecto.NoResultsError, fn ->
        AuditLogs.get_activity_log!(other_scope, activity_log.id)
      end
    end

    test "create_activity_log/2 with valid data creates a activity_log" do
      valid_attrs = %{
        action: "some action",
        details: "some details",
        entity_name: "some entity_name"
      }

      scope = user_scope_fixture()

      assert {:ok, %ActivityLog{} = activity_log} =
               AuditLogs.create_activity_log(scope, valid_attrs)

      assert activity_log.action == "some action"
      assert activity_log.details == "some details"
      assert activity_log.entity_name == "some entity_name"
      assert activity_log.user_id == scope.user.id
    end

    test "create_activity_log/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = AuditLogs.create_activity_log(scope, @invalid_attrs)
    end

    test "update_activity_log/3 with valid data updates the activity_log" do
      scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)

      update_attrs = %{
        action: "some updated action",
        details: "some updated details",
        entity_name: "some updated entity_name"
      }

      assert {:ok, %ActivityLog{} = activity_log} =
               AuditLogs.update_activity_log(scope, activity_log, update_attrs)

      assert activity_log.action == "some updated action"
      assert activity_log.details == "some updated details"
      assert activity_log.entity_name == "some updated entity_name"
    end

    test "update_activity_log/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)

      assert_raise MatchError, fn ->
        AuditLogs.update_activity_log(other_scope, activity_log, %{})
      end
    end

    test "update_activity_log/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               AuditLogs.update_activity_log(scope, activity_log, @invalid_attrs)

      assert activity_log == AuditLogs.get_activity_log!(scope, activity_log.id)
    end

    test "delete_activity_log/2 deletes the activity_log" do
      scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)
      assert {:ok, %ActivityLog{}} = AuditLogs.delete_activity_log(scope, activity_log)

      assert_raise Ecto.NoResultsError, fn ->
        AuditLogs.get_activity_log!(scope, activity_log.id)
      end
    end

    test "delete_activity_log/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)
      assert_raise MatchError, fn -> AuditLogs.delete_activity_log(other_scope, activity_log) end
    end

    test "change_activity_log/2 returns a activity_log changeset" do
      scope = user_scope_fixture()
      activity_log = activity_log_fixture(scope)
      assert %Ecto.Changeset{} = AuditLogs.change_activity_log(scope, activity_log)
    end
  end
end
