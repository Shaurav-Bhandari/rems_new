defmodule BinduBackend.NotificationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Notifications` context.
  """

  @doc """
  Generate a notification.
  """
  def notification_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        is_read: true,
        message: "some message",
        notification_type: "some notification_type"
      })

    {:ok, notification} = BinduBackend.Notifications.create_notification(scope, attrs)
    notification
  end
end
