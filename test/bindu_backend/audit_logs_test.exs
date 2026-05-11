defmodule BinduBackend.AuditLogsTest do
  use BinduBackend.DataCase

  alias BinduBackend.AuditLogs

  describe "activity_log" do
    alias BinduBackend.AuditLogs.AuditLog

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.AuditLogsFixtures

    @invalid_attrs %{action: nil, details: nil, entity_name: nil}

    test "list_activity_log/1 returns all scoped activity_log" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)
      other_audit_log = audit_log_fixture(other_scope)
      assert AuditLogs.list_activity_log(scope) == [audit_log]
      assert AuditLogs.list_activity_log(other_scope) == [other_audit_log]
    end

    test "get_audit_log!/2 returns the audit_log with given id" do
      scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)
      other_scope = user_scope_fixture()
      assert AuditLogs.get_audit_log!(scope, audit_log.id) == audit_log
      assert_raise Ecto.NoResultsError, fn -> AuditLogs.get_audit_log!(other_scope, audit_log.id) end
    end

    test "create_audit_log/2 with valid data creates a audit_log" do
      valid_attrs = %{action: "some action", details: "some details", entity_name: "some entity_name"}
      scope = user_scope_fixture()

      assert {:ok, %AuditLog{} = audit_log} = AuditLogs.create_audit_log(scope, valid_attrs)
      assert audit_log.action == "some action"
      assert audit_log.details == "some details"
      assert audit_log.entity_name == "some entity_name"
      assert audit_log.user_id == scope.user.id
    end

    test "create_audit_log/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = AuditLogs.create_audit_log(scope, @invalid_attrs)
    end

    test "update_audit_log/3 with valid data updates the audit_log" do
      scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)
      update_attrs = %{action: "some updated action", details: "some updated details", entity_name: "some updated entity_name"}

      assert {:ok, %AuditLog{} = audit_log} = AuditLogs.update_audit_log(scope, audit_log, update_attrs)
      assert audit_log.action == "some updated action"
      assert audit_log.details == "some updated details"
      assert audit_log.entity_name == "some updated entity_name"
    end

    test "update_audit_log/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)

      assert_raise MatchError, fn ->
        AuditLogs.update_audit_log(other_scope, audit_log, %{})
      end
    end

    test "update_audit_log/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = AuditLogs.update_audit_log(scope, audit_log, @invalid_attrs)
      assert audit_log == AuditLogs.get_audit_log!(scope, audit_log.id)
    end

    test "delete_audit_log/2 deletes the audit_log" do
      scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)
      assert {:ok, %AuditLog{}} = AuditLogs.delete_audit_log(scope, audit_log)
      assert_raise Ecto.NoResultsError, fn -> AuditLogs.get_audit_log!(scope, audit_log.id) end
    end

    test "delete_audit_log/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)
      assert_raise MatchError, fn -> AuditLogs.delete_audit_log(other_scope, audit_log) end
    end

    test "change_audit_log/2 returns a audit_log changeset" do
      scope = user_scope_fixture()
      audit_log = audit_log_fixture(scope)
      assert %Ecto.Changeset{} = AuditLogs.change_audit_log(scope, audit_log)
    end
  end
end
