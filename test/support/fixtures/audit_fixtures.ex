defmodule BinduBackend.AuditFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Audit` context.
  """

  @doc """
  Generate a audit_trail.
  """
  def audit_trail_fixture(attrs \\ %{}) do
    {:ok, audit_trail} =
      attrs
      |> Enum.into(%{
        anomaly_reason: "some anomaly_reason",
        compliance_flags: %{},
        entity_id: "some entity_id",
        entity_type: "some entity_type",
        event_category: "some event_category",
        event_description: "some event_description",
        event_type: "some event_type",
        geolocation: %{},
        http_method: "some http_method",
        ip_address: "some ip_address",
        is_anomalous: true,
        is_gdpr_relevant: true,
        is_pci_relevant: true,
        new_values: %{},
        old_values: %{},
        request_url: "some request_url",
        requires_review: true,
        reviewed_at: ~U[2026-05-10 06:03:00Z],
        risk_level: "some risk_level",
        session_id: "some session_id",
        severity: "some severity",
        timestamp: ~U[2026-05-10 06:03:00Z],
        user_agent: "some user_agent"
      })
      |> BinduBackend.Audit.create_audit_trail()

    audit_trail
  end

  @doc """
  Generate a anomaly_record.
  """
  def anomaly_record_fixture(attrs \\ %{}) do
    {:ok, anomaly_record} =
      attrs
      |> Enum.into(%{
        anomaly_type: "some anomaly_type",
        description: "some description",
        detected_at: ~U[2026-05-10 06:06:00Z]
      })
      |> BinduBackend.Audit.create_anomaly_record()

    anomaly_record
  end
end
