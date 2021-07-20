defmodule Todo do
  @moduledoc """
  Documentation for `Todo`.
  """
  defstruct auto_id: 1, items: %{}

  def new do
    %Todo{}
  end

  def new(items) do
    Enum.reduce(
      items,
      %Todo{},
      &add_item(&2, &1)
    )
  end

  def add_item(%Todo{auto_id: auto_id, items: items}, item) do
    %Todo{
      auto_id: auto_id + 1,
      items: Map.put(items, auto_id, item)
    }
  end

  def get_item(%Todo{items: items}, id) do
    items[id]
  end

  def update_item(%Todo{auto_id: auto_id, items: items} = todo, id, updater_fun) do
    case items[id] do
      nil -> todo
      _ ->
        %Todo{
          auto_id: auto_id,
          items: Map.update!(items, id, updater_fun)
        }
    end
  end

  def delete_item(%Todo{auto_id: auto_id, items: items}, id) do
    {_, new_items} = Map.pop(items, id)
    %Todo{
      auto_id: auto_id,
      items: new_items
    }
  end
end


Todo.new
  |> Todo.add_item(%{text: "new item"})
  |> Todo.add_item(%{text: "new item2"})
  |> Todo.update_item(1, fn _ -> %{text: "updated_item"} end)
  |> Todo.get_item(1)


items = [
  %{text: "Item 1"},
  %{text: "Item 2"},
  %{text: "Item 3"},
  %{text: "Item 4"},
]
Todo.new(items)
