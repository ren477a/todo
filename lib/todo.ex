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




defmodule Todo.CsvImporter do
  # CSV Format:
  # 20/1/20,feed dogs
  # 20/1/20,throw trash
  # 21/1/20,buy bread
  # 21/1/20,do homework

  def import_todo(filename) do
    filename
      |> File.stream!()
      |> Enum.map(&(String.split(&1, ",")))
      |> Enum.map(&parse_line/1)
      |> Todo.new
  end

  defp parse_line([date, text]) do
    %{
      date: parse_date(date),
      text: String.trim(text)
    }
  end

  defp parse_date(date) do
    [day, month, year] = String.split(date, "/")
    {day, month, year}
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
Todo.CsvImporter.import_todo("mytodo.csv")
