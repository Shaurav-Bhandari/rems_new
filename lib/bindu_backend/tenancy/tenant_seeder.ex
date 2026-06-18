# lib/bindu_backend/tenancy/tenant_seeder.ex

defmodule BinduBackend.Tenancy.TenantSeeder do
  import Ecto.Query
  require Logger

  alias BinduBackend.Repo
  alias BinduBackend.Accounts

  # ── Phase 1: Lookups / Flags ──────────────────────────────────────────────

  def seed_lookups(slug) do
    with {:ok, _} <- seed_table_statuses(slug),
         {:ok, _} <- seed_order_types(slug),
         {:ok, _} <- seed_order_item_statuses(slug),
         {:ok, _} <- seed_kot_statuses(slug),
         {:ok, _} <- seed_kot_priorities(slug),
         {:ok, _} <- seed_kot_item_statuses(slug),
         {:ok, _} <- seed_reservation_statuses(slug),
         {:ok, _} <- seed_notification_types(slug),
         {:ok, _} <- seed_audit_events(slug),
         {:ok, _} <- seed_rate_types(slug),
         {:ok, _} <- seed_kitchen_stations(slug),
         {:ok, _} <- seed_rule_types(slug),
         {:ok, _} <- seed_audit_severities(slug) do
      {:ok, :lookups_seeded}
    end
  end

  defp seed_table_statuses(slug) do
    rows =
      [
        %{name: "available", label: "Available", color: "#22c55e", is_system: true, position: 1},
        %{name: "occupied", label: "Occupied", color: "#ef4444", is_system: true, position: 2},
        %{name: "reserved", label: "Reserved", color: "#f59e0b", is_system: true, position: 3},
        %{name: "cleaning", label: "Cleaning", color: "#6b7280", is_system: true, position: 4},
        %{name: "inactive", label: "Inactive", color: "#d1d5db", is_system: true, position: 5}
      ]
      |> put_timestamps()

    Repo.insert_all("table_statuses", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_order_types(slug) do
    rows =
      [
        %{name: "dine_in", label: "Dine In", is_system: true, position: 1},
        %{name: "takeaway", label: "Takeaway", is_system: true, position: 2},
        %{name: "delivery", label: "Delivery", is_system: true, position: 3},
        %{name: "bar", label: "Bar", is_system: true, position: 4}
      ]
      |> put_timestamps()

    Repo.insert_all("order_types", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_order_item_statuses(slug) do
    rows =
      [
        %{name: "pending", label: "Pending", is_system: true, position: 1},
        %{name: "sent_to_kitchen", label: "Sent to Kitchen", is_system: true, position: 2},
        %{name: "preparing", label: "Preparing", is_system: true, position: 3},
        %{name: "ready", label: "Ready", is_system: true, position: 4},
        %{name: "served", label: "Served", is_system: true, position: 5},
        %{name: "cancelled", label: "Cancelled", is_system: true, position: 6},
        %{name: "voided", label: "Voided", is_system: true, position: 7}
      ]
      |> put_timestamps()

    Repo.insert_all("order_item_statuses", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_kot_statuses(slug) do
    rows =
      [
        %{name: "pending", label: "Pending", is_system: true, position: 1},
        %{name: "accepted", label: "Accepted", is_system: true, position: 2},
        %{name: "preparing", label: "Preparing", is_system: true, position: 3},
        %{name: "ready", label: "Ready", is_system: true, position: 4},
        %{name: "completed", label: "Completed", is_system: true, position: 5},
        %{name: "cancelled", label: "Cancelled", is_system: true, position: 6}
      ]
      |> put_timestamps()

    Repo.insert_all("kot_statuses", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_kot_priorities(slug) do
    rows =
      [
        %{name: "normal", label: "Normal", level: 1, is_system: true},
        %{name: "rush", label: "Rush", level: 2, is_system: true},
        %{name: "fire", label: "Fire", level: 3, is_system: true}
      ]
      |> put_timestamps()

    Repo.insert_all("kot_priorities", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_kot_item_statuses(slug) do
    rows =
      [
        %{name: "pending", label: "Pending", is_system: true, position: 1},
        %{name: "preparing", label: "Preparing", is_system: true, position: 2},
        %{name: "ready", label: "Ready", is_system: true, position: 3},
        %{name: "cancelled", label: "Cancelled", is_system: true, position: 4}
      ]
      |> put_timestamps()

    Repo.insert_all("kot_item_statuses", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_reservation_statuses(slug) do
    rows =
      [
        %{name: "pending", label: "Pending", is_system: true, position: 1},
        %{name: "confirmed", label: "Confirmed", is_system: true, position: 2},
        %{name: "seated", label: "Seated", is_system: true, position: 3},
        %{name: "completed", label: "Completed", is_system: true, position: 4},
        %{name: "cancelled", label: "Cancelled", is_system: true, position: 5},
        %{name: "no_show", label: "No Show", is_system: true, position: 6}
      ]
      |> put_timestamps()

    Repo.insert_all("reservation_statuses", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_notification_types(slug) do
    rows =
      [
        %{name: "order_placed", label: "Order Placed", is_system: true},
        %{name: "kot_ready", label: "KOT Ready", is_system: true},
        %{name: "payment_received", label: "Payment Received", is_system: true},
        %{name: "reservation_confirmed", label: "Reservation Confirmed", is_system: true},
        %{name: "low_stock", label: "Low Stock", is_system: true}
      ]
      |> put_timestamps()

    Repo.insert_all("notification_types", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_audit_events(slug) do
    rows =
      [
        %{name: "user_login", label: "User Login", is_system: true},
        %{name: "user_logout", label: "User Logout", is_system: true},
        %{name: "order_created", label: "Order Created", is_system: true},
        %{name: "order_voided", label: "Order Voided", is_system: true},
        %{name: "payment_taken", label: "Payment Taken", is_system: true},
        %{name: "discount_applied", label: "Discount Applied", is_system: true},
        %{name: "menu_updated", label: "Menu Updated", is_system: true},
        %{name: "settings_changed", label: "Settings Changed", is_system: true}
      ]
      |> put_timestamps()

    Repo.insert_all("audit_events", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_rate_types(slug) do
    rows =
      [
        %{name: "standard", label: "Standard", is_system: true},
        %{name: "happy_hour", label: "Happy Hour", is_system: true},
        %{name: "seasonal", label: "Seasonal", is_system: true}
      ]
      |> put_timestamps()

    Repo.insert_all("rate_types", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_kitchen_stations(slug) do
    rows =
      [
        %{name: "main_kitchen", label: "Main Kitchen", is_system: true, position: 1},
        %{name: "cold_station", label: "Cold Station", is_system: true, position: 2},
        %{name: "grill_station", label: "Grill Station", is_system: true, position: 3},
        %{name: "bar", label: "Bar", is_system: true, position: 4},
        %{name: "pastry", label: "Pastry", is_system: true, position: 5}
      ]
      |> put_timestamps()

    Repo.insert_all("kitchen_stations", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_rule_types(slug) do
    rows =
      [
        %{name: "discount", label: "Discount", is_system: true},
        %{name: "surcharge", label: "Surcharge", is_system: true},
        %{name: "tax", label: "Tax", is_system: true},
        %{name: "service_charge", label: "Service Charge", is_system: true},
        %{name: "promotion", label: "Promotion", is_system: true}
      ]
      |> put_timestamps()

    Repo.insert_all("rule_types", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  defp seed_audit_severities(slug) do
    rows =
      [
        %{name: "info", label: "Info", level: 1, is_system: true},
        %{name: "warning", label: "Warning", level: 2, is_system: true},
        %{name: "critical", label: "Critical", level: 3, is_system: true}
      ]
      |> put_timestamps()

    Repo.insert_all("audit_severities", rows,
      prefix: Triplex.to_prefix(slug),
      on_conflict: :nothing,
      conflict_target: :name
    )
    |> wrap_ok()
  end

  # ── Phase 2: Roles, Permissions, Role-Permissions ─────────────────────────

  def seed_roles_and_permissions(slug) do
    prefix = Triplex.to_prefix(slug)
    roles = insert_roles(prefix)
    permissions = insert_permissions(prefix)
    insert_role_permissions(prefix, roles, permissions)
    {:ok, :roles_and_permissions_seeded}
  end

  defp insert_roles(prefix) do
    now = utc_now()

    rows = [
      %{id: uuid(), role_name: "owner", is_system: true, inserted_at: now, updated_at: now},
      %{id: uuid(), role_name: "manager", is_system: true, inserted_at: now, updated_at: now},
      %{id: uuid(), role_name: "cashier", is_system: true, inserted_at: now, updated_at: now},
      %{id: uuid(), role_name: "waiter", is_system: true, inserted_at: now, updated_at: now},
      %{id: uuid(), role_name: "kitchen", is_system: true, inserted_at: now, updated_at: now}
    ]

    Repo.insert_all("roles", rows,
      prefix: prefix,
      on_conflict: :nothing,
      conflict_target: :role_name,
      returning: [:id, :role_name]
    )
    |> then(fn {_, rows} -> Map.new(rows, &{&1.role_name, &1.id}) end)
  end

  defp insert_permissions(prefix) do
    now = utc_now()

    # Group → [actions]
    resources = %{
      "orders" => ~w(create read update void cancel split_bill),
      "menu" => ~w(create read update delete manage_prices),
      "tables" => ~w(create read update delete manage_floors),
      "kot" => ~w(create read update cancel),
      "payments" => ~w(create read refund apply_discount),
      "reservations" => ~w(create read update cancel),
      "employees" => ~w(create read update delete manage_roles),
      "customers" => ~w(create read update delete),
      "reports" => ~w(read export),
      "settings" => ~w(read update manage_integrations),
      "audit" => ~w(read)
    }

    rows =
      for {resource, actions} <- resources,
          action <- actions do
        %{
          id: uuid(),
          permission_name: "#{resource}:#{action}",
          is_system: true,
          inserted_at: now,
          updated_at: now
        }
      end

    Repo.insert_all("permissions", rows,
      prefix: prefix,
      on_conflict: :nothing,
      conflict_target: :permission_name,
      returning: [:id, :permission_name]
    )
    |> then(fn {_, rows} -> Map.new(rows, &{&1.permission_name, &1.id}) end)
  end

  defp insert_role_permissions(prefix, roles, permissions) do
    now = utc_now()

    # Permission matrix: role → [permission names]
    matrix = %{
      # all permissions
      "owner" => Map.keys(permissions),
      "manager" => ~w(
        orders:create orders:read orders:update orders:void orders:cancel orders:split_bill
        menu:create menu:read menu:update menu:delete menu:manage_prices
        tables:create tables:read tables:update tables:manage_floors
        kot:create kot:read kot:update kot:cancel
        payments:create payments:read payments:refund payments:apply_discount
        reservations:create reservations:read reservations:update reservations:cancel
        employees:read
        customers:create customers:read customers:update
        reports:read reports:export
        settings:read
      ),
      "cashier" => ~w(
        orders:read orders:update
        payments:create payments:read payments:apply_discount
        customers:create customers:read
        reports:read
      ),
      "waiter" => ~w(
        orders:create orders:read orders:update
        tables:read
        kot:create kot:read
        reservations:create reservations:read reservations:update
        customers:read
        menu:read
      ),
      "kitchen" => ~w(
        kot:read kot:update
        orders:read
        menu:read
      )
    }

    rows =
      for {role_name, perm_names} <- matrix,
          role_id = roles[role_name],
          perm_name <- perm_names,
          perm_id = permissions[perm_name],
          not is_nil(role_id) and not is_nil(perm_id) do
        %{role_id: role_id, permission_id: perm_id, inserted_at: now, updated_at: now}
      end

    Repo.insert_all("role_permissions", rows,
      prefix: prefix,
      on_conflict: :nothing,
      conflict_target: [:role_id, :permission_id]
    )
  end

  # ── Phase 3: Default Admin User ───────────────────────────────────────────

  def seed_admin_user(%{slug: slug, owner_email: email, owner_name: name} = _tenant) do
    # Generate a secure one-time password — tenant owner MUST reset this
    temp_password = :crypto.strong_rand_bytes(12) |> Base.url_encode64(padding: false)
    [first_name | rest] = String.split(name, " ", parts: 2)
    last_name = List.first(rest, "")

    user_id = uuid()
    now = utc_now()
    prefix = Triplex.to_prefix(slug)

    {:ok, account} =
      Accounts.ensure_tenant_admin_account(%{
        email: email,
        first_name: first_name,
        last_name: last_name
      })

    {:ok, {_account, _expired_tokens}} =
      Accounts.update_user_password(account, %{"password" => temp_password})

    {:ok, account} = Accounts.confirm_user(account)

    # Insert tenant-local profile/member row. Authentication stays in public accounts.
    Repo.insert_all(
      "users",
      [
        %{
          id: user_id,
          account_id: account.id,
          email: email,
          first_name: first_name,
          last_name: last_name,
          is_active: true,
          is_deleted: false,
          is_email_verified: true,
          inserted_at: now,
          updated_at: now
        }
      ],
      prefix: prefix,
      on_conflict: :nothing,
      conflict_target: :email
    )

    # Assign owner role
    owner_role =
      from(r in "roles", where: r.role_name == "owner", select: %{id: r.id})
      |> Repo.one(prefix: prefix)

    if owner_role do
      Repo.insert_all(
        "user_roles",
        [
          %{
            user_id: user_id,
            role_id: owner_role.id,
            inserted_at: now,
            updated_at: now
          }
        ],
        prefix: prefix
      )
    end

    # Send welcome + temp password email OUTSIDE the DB transaction
    BinduBackend.Mailer.send_tenant_welcome(email, name, temp_password)
    {:ok, %{account_id: account.id, user_id: user_id, temp_password: temp_password}}
  end

  # ── Helpers ───────────────────────────────────────────────────────────────

  defp put_timestamps(rows) do
    now = utc_now()
    Enum.map(rows, &Map.merge(&1, %{inserted_at: now, updated_at: now}))
  end

  defp utc_now, do: DateTime.utc_now() |> DateTime.truncate(:second)
  defp uuid, do: Ecto.UUID.bingenerate()
  defp wrap_ok({:ok, _} = ok), do: ok
  defp wrap_ok({:error, _} = err), do: err
  defp wrap_ok(_), do: {:ok, :done}
end
