defmodule BinduBackend.AuditLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.AuditLogs` context.
  """

  @doc """
  Generate a audit_log.
  """
  def audit_log_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        action: "some action",
        details: "some details",
        entity_name: "some entity_name"
      })

    {:ok, audit_log} = BinduBackend.AuditLogs.create_audit_log(scope, attrs)
    audit_log
  end
end
