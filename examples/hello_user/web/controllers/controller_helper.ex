defmodule HelloUser.Controllers.ControllerHelper do

  @moduledoc """
  This module provides helper functions that are used by controllers to
  format incoming and outgoing data.
  """

  @doc """
  to_sendable prepares a List of structs or maps for transmission by converting structs
  to plain old maps (if a struct is passed in), and stripping out any fields
  in the allowed_fields list. If allowed_fields is empty, then all fields are
  sent.
  """
  def to_sendable(item) when is_list(item), do: to_sendable_list([], item)
  def to_sendable(%{__struct__: _} = struct) do
    to_sendable(Map.from_struct(struct))
  end

  defp to_sendable_list(sendable_items, []), do: sendable_items  
  defp to_sendable_list(sendable_items, [item|remaining_items]) do
    to_sendable_list(sendable_items ++ [to_sendable(item)], remaining_items)
  end  
end