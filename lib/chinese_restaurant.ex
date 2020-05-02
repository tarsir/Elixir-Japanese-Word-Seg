defmodule ChineseRestaurant do
  @moduledoc """
  Methods related to the Chinese restaurant process.
  """

  @discount_factor 1.0
  @concentration_factor 0.0

  @doc ~S"""
  Add an element to the existing partitions.

  ## Examples
  
  iex> add_element(1, [])
  [[1]]
  """
  def add_element(value, blocks \\ [], opts \\ %{})

  def add_element(value, [], _opts), do: [[value]]

  def add_element(value, blocks, opts) do
    {block_sizes, count} = successive_partition_sizes(blocks)

    strength = Map.get(opts, :strength, @concentration_factor)
    discount = Map.get(opts, :discount, @discount_factor)
    target_block = :rand.uniform(count + 1) - 1

    if target_block == empty_table_threshold(Enum.count(blocks), strength, discount) do
      add_to_new_block(value, blocks)
    else
      target_index = Enum.find_index(block_sizes, fn block_size ->
        target_block <= occupied_table_threshold(count, block_size, strength, discount)
      end)
      IO.inspect({:ok, target_index})
      List.replace_at(blocks, target_index, Enum.at(blocks, target_index) ++ [value])
    end
  end

  def add_to_new_block(value, blocks) do
    blocks ++ [[value]]
  end

  def partition_values(enum, opts \\ %{}) do
    Enum.reduce(enum, [], fn val, acc -> add_element(val, acc, opts) end)
  end

  @doc ~S"""
  Count the number of total values in the current partitions.

  ## Examples
  
  iex> number_of_values([])
  0

  iex> number_of_values([[1, 2], [3], [4]])
  4
  """
  def number_of_values(blocks) do
    Enum.reduce(
      blocks,
      0,
      fn block, acc -> acc + Enum.count(block) end
    )
  end

  @doc ~S"""
  Count the number of total values in the current partitions.

  ## Examples
  
  iex> successive_partition_sizes([])
  {[], 0}

  iex> successive_partition_sizes([[1, 2], [3], [4]])
  {[2, 3, 4], 4}
  """
  def successive_partition_sizes(blocks) do
    Enum.map_reduce(
      blocks,
      0,
      fn block, acc -> {Enum.count(block) + acc, Enum.count(block) + acc} end
    ) 
  end

  defp empty_table_threshold(table_count, concentration_factor, discount_factor), do: discount_factor + table_count * concentration_factor

  defp occupied_table_threshold(occupant_count, table_size, concentration_factor, discount_factor) do
    table_size - (concentration_factor) / (occupant_count + discount_factor)
  end
end
