defmodule BinduBackend.AuditLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.AuditLogs` context.
  """

  @doc """
  Generate a activity_log.
  """
  def activity_log_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        action: "some action",
        details: "some details",
        entity_name: "some entity_name"
      })

    {:ok, activity_log} = BinduBackend.AuditLogs.create_activity_log(scope, attrs)
    activity_log
  end
end
