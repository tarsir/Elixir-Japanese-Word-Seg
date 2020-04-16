defmodule ChineseRestaurantTest do
  import ChineseRestaurant
  use ExUnit.Case
  doctest ChineseRestaurant
  @basic_test_list [[1, 2, 3], [4]]
  @discount_factor 5.0
  @concentration_factor -5.0

  test "adds to non-empty structure" do
    new_blocks = add_element(20, @basic_test_list, factor_ops())
    assert number_of_values(new_blocks) == 5
  end

  test "add_to_new_block forces a new block" do
    new_blocks = Enum.reduce(1..10, [], fn x, acc -> add_to_new_block(x, acc) end)
    assert Enum.count(new_blocks) == 10
  end

  test "works with 100 elements" do
    new_blocks = Enum.reduce(0..99, [], fn x, acc -> add_element(x, acc, factor_ops()) end)
    IO.inspect(successive_partition_sizes(new_blocks), charlists: :as_lists)
    assert number_of_values(new_blocks)
  end

  defp factor_ops(), do: %{discount: @discount_factor, strength: @concentration_factor}
end
