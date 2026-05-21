defmodule BinduBackend.AuditTest do
  use BinduBackend.DataCase

  alias BinduBackend.Audit

  describe "audit_trails" do
    alias BinduBackend.Audit.AuditTrail

    import BinduBackend.AuditFixtures

    @invalid_attrs %{
      timestamp: nil,
      severity: nil,
      session_id: nil,
      event_type: nil,
      event_category: nil,
      event_description: nil,
      entity_type: nil,
      entity_id: nil,
      old_values: nil,
      new_values: nil,
      request_url: nil,
      http_method: nil,
      ip_address: nil,
      user_agent: nil,
      geolocation: nil,
      risk_level: nil,
      requires_review: nil,
      is_anomalous: nil,
      anomaly_reason: nil,
      compliance_flags: nil,
      is_pci_relevant: nil,
      is_gdpr_relevant: nil,
      reviewed_at: nil
    }

    test "list_audit_trails/0 returns all audit_trails" do
      audit_trail = audit_trail_fixture()
      assert Audit.list_audit_trails() == [audit_trail]
    end

    test "get_audit_trail!/1 returns the audit_trail with given id" do
      audit_trail = audit_trail_fixture()
      assert Audit.get_audit_trail!(audit_trail.id) == audit_trail
    end

    test "create_audit_trail/1 with valid data creates a audit_trail" do
      valid_attrs = %{
        timestamp: ~U[2026-05-10 06:03:00Z],
        severity: "some severity",
        session_id: "some session_id",
        event_type: "some event_type",
        event_category: "some event_category",
        event_description: "some event_description",
        entity_type: "some entity_type",
        entity_id: "some entity_id",
        old_values: %{},
        new_values: %{},
        request_url: "some request_url",
        http_method: "some http_method",
        ip_address: "some ip_address",
        user_agent: "some user_agent",
        geolocation: %{},
        risk_level: "some risk_level",
        requires_review: true,
        is_anomalous: true,
        anomaly_reason: "some anomaly_reason",
        compliance_flags: %{},
        is_pci_relevant: true,
        is_gdpr_relevant: true,
        reviewed_at: ~U[2026-05-10 06:03:00Z]
      }

      assert {:ok, %AuditTrail{} = audit_trail} = Audit.create_audit_trail(valid_attrs)
      assert audit_trail.timestamp == ~U[2026-05-10 06:03:00Z]
      assert audit_trail.severity == "some severity"
      assert audit_trail.session_id == "some session_id"
      assert audit_trail.event_type == "some event_type"
      assert audit_trail.event_category == "some event_category"
      assert audit_trail.event_description == "some event_description"
      assert audit_trail.entity_type == "some entity_type"
      assert audit_trail.entity_id == "some entity_id"
      assert audit_trail.old_values == %{}
      assert audit_trail.new_values == %{}
      assert audit_trail.request_url == "some request_url"
      assert audit_trail.http_method == "some http_method"
      assert audit_trail.ip_address == "some ip_address"
      assert audit_trail.user_agent == "some user_agent"
      assert audit_trail.geolocation == %{}
      assert audit_trail.risk_level == "some risk_level"
      assert audit_trail.requires_review == true
      assert audit_trail.is_anomalous == true
      assert audit_trail.anomaly_reason == "some anomaly_reason"
      assert audit_trail.compliance_flags == %{}
      assert audit_trail.is_pci_relevant == true
      assert audit_trail.is_gdpr_relevant == true
      assert audit_trail.reviewed_at == ~U[2026-05-10 06:03:00Z]
    end

    test "create_audit_trail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audit.create_audit_trail(@invalid_attrs)
    end

    test "update_audit_trail/2 with valid data updates the audit_trail" do
      audit_trail = audit_trail_fixture()

      update_attrs = %{
        timestamp: ~U[2026-05-11 06:03:00Z],
        severity: "some updated severity",
        session_id: "some updated session_id",
        event_type: "some updated event_type",
        event_category: "some updated event_category",
        event_description: "some updated event_description",
        entity_type: "some updated entity_type",
        entity_id: "some updated entity_id",
        old_values: %{},
        new_values: %{},
        request_url: "some updated request_url",
        http_method: "some updated http_method",
        ip_address: "some updated ip_address",
        user_agent: "some updated user_agent",
        geolocation: %{},
        risk_level: "some updated risk_level",
        requires_review: false,
        is_anomalous: false,
        anomaly_reason: "some updated anomaly_reason",
        compliance_flags: %{},
        is_pci_relevant: false,
        is_gdpr_relevant: false,
        reviewed_at: ~U[2026-05-11 06:03:00Z]
      }

      assert {:ok, %AuditTrail{} = audit_trail} =
               Audit.update_audit_trail(audit_trail, update_attrs)

      assert audit_trail.timestamp == ~U[2026-05-11 06:03:00Z]
      assert audit_trail.severity == "some updated severity"
      assert audit_trail.session_id == "some updated session_id"
      assert audit_trail.event_type == "some updated event_type"
      assert audit_trail.event_category == "some updated event_category"
      assert audit_trail.event_description == "some updated event_description"
      assert audit_trail.entity_type == "some updated entity_type"
      assert audit_trail.entity_id == "some updated entity_id"
      assert audit_trail.old_values == %{}
      assert audit_trail.new_values == %{}
      assert audit_trail.request_url == "some updated request_url"
      assert audit_trail.http_method == "some updated http_method"
      assert audit_trail.ip_address == "some updated ip_address"
      assert audit_trail.user_agent == "some updated user_agent"
      assert audit_trail.geolocation == %{}
      assert audit_trail.risk_level == "some updated risk_level"
      assert audit_trail.requires_review == false
      assert audit_trail.is_anomalous == false
      assert audit_trail.anomaly_reason == "some updated anomaly_reason"
      assert audit_trail.compliance_flags == %{}
      assert audit_trail.is_pci_relevant == false
      assert audit_trail.is_gdpr_relevant == false
      assert audit_trail.reviewed_at == ~U[2026-05-11 06:03:00Z]
    end

    test "update_audit_trail/2 with invalid data returns error changeset" do
      audit_trail = audit_trail_fixture()
      assert {:error, %Ecto.Changeset{}} = Audit.update_audit_trail(audit_trail, @invalid_attrs)
      assert audit_trail == Audit.get_audit_trail!(audit_trail.id)
    end

    test "delete_audit_trail/1 deletes the audit_trail" do
      audit_trail = audit_trail_fixture()
      assert {:ok, %AuditTrail{}} = Audit.delete_audit_trail(audit_trail)
      assert_raise Ecto.NoResultsError, fn -> Audit.get_audit_trail!(audit_trail.id) end
    end

    test "change_audit_trail/1 returns a audit_trail changeset" do
      audit_trail = audit_trail_fixture()
      assert %Ecto.Changeset{} = Audit.change_audit_trail(audit_trail)
    end
  end

  describe "anomaly_records" do
    alias BinduBackend.Audit.AnomalyRecord

    import BinduBackend.AuditFixtures

    @invalid_attrs %{description: nil, detected_at: nil, anomaly_type: nil}

    test "list_anomaly_records/0 returns all anomaly_records" do
      anomaly_record = anomaly_record_fixture()
      assert Audit.list_anomaly_records() == [anomaly_record]
    end

    test "get_anomaly_record!/1 returns the anomaly_record with given id" do
      anomaly_record = anomaly_record_fixture()
      assert Audit.get_anomaly_record!(anomaly_record.id) == anomaly_record
    end

    test "create_anomaly_record/1 with valid data creates a anomaly_record" do
      valid_attrs = %{
        description: "some description",
        detected_at: ~U[2026-05-10 06:06:00Z],
        anomaly_type: "some anomaly_type"
      }

      assert {:ok, %AnomalyRecord{} = anomaly_record} = Audit.create_anomaly_record(valid_attrs)
      assert anomaly_record.description == "some description"
      assert anomaly_record.detected_at == ~U[2026-05-10 06:06:00Z]
      assert anomaly_record.anomaly_type == "some anomaly_type"
    end

    test "create_anomaly_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audit.create_anomaly_record(@invalid_attrs)
    end

    test "update_anomaly_record/2 with valid data updates the anomaly_record" do
      anomaly_record = anomaly_record_fixture()

      update_attrs = %{
        description: "some updated description",
        detected_at: ~U[2026-05-11 06:06:00Z],
        anomaly_type: "some updated anomaly_type"
      }

      assert {:ok, %AnomalyRecord{} = anomaly_record} =
               Audit.update_anomaly_record(anomaly_record, update_attrs)

      assert anomaly_record.description == "some updated description"
      assert anomaly_record.detected_at == ~U[2026-05-11 06:06:00Z]
      assert anomaly_record.anomaly_type == "some updated anomaly_type"
    end

    test "update_anomaly_record/2 with invalid data returns error changeset" do
      anomaly_record = anomaly_record_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Audit.update_anomaly_record(anomaly_record, @invalid_attrs)

      assert anomaly_record == Audit.get_anomaly_record!(anomaly_record.id)
    end

    test "delete_anomaly_record/1 deletes the anomaly_record" do
      anomaly_record = anomaly_record_fixture()
      assert {:ok, %AnomalyRecord{}} = Audit.delete_anomaly_record(anomaly_record)
      assert_raise Ecto.NoResultsError, fn -> Audit.get_anomaly_record!(anomaly_record.id) end
    end

    test "change_anomaly_record/1 returns a anomaly_record changeset" do
      anomaly_record = anomaly_record_fixture()
      assert %Ecto.Changeset{} = Audit.change_anomaly_record(anomaly_record)
    end
  end
end
